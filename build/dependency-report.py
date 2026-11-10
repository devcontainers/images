#!/usr/bin/env python3
"""Report dependency lifecycle and image vulnerability coverage using the standard library."""

import argparse
import datetime
import json
import os
from pathlib import Path
import re
import urllib.request


ROOT = Path(__file__).resolve().parents[1]
PRODUCTS = {
    "python": "python", "dotnet": "dotnet", "go": "go",
    "javascript-node": "nodejs", "typescript-node": "nodejs",
    "ruby": "ruby", "jekyll": "ruby", "php": "php",
    "base-alpine": "alpine",
}
OS_PRODUCTS = ("debian", "ubuntu", "alpine")


def get_json(url, token=None, method=None, data=None):
    headers = {"User-Agent": "devcontainers-images-dependency-monitor"}
    if token:
        headers["Authorization"] = f"Bearer {token}"
        headers["Accept"] = "application/vnd.github+json"
    payload = None if data is None else json.dumps(data).encode()
    if payload is not None:
        headers["Content-Type"] = "application/json"
    request = urllib.request.Request(url, data=payload, headers=headers, method=method)
    with urllib.request.urlopen(request, timeout=60) as response:
        return json.load(response)


def manifests(root=ROOT):
    return [(path.parent.name, json.loads(path.read_text()))
            for path in sorted((root / "src").glob("*/manifest.json"))]


def scan_matrix(entries):
    targets = []
    for name, manifest in entries:
        build = manifest["build"]
        for variant in manifest.get("variants", ["NOVARIANT"]):
            architectures = build.get("architectures", ["linux/amd64"])
            if isinstance(architectures, dict):
                architectures = architectures[variant]
            tag = build["tags"][0].replace("${VERSION}", manifest["version"].split(".")[0])
            tag = tag.replace("${VARIANT}", variant).replace("-NOVARIANT", "")
            if "$" in tag:
                raise ValueError(f"Unresolved image tag: {name}: {tag}")
            for platform in architectures:
                targets.append({"id": f"{name}-{variant}-{platform.replace('/', '-')}",
                                "image": f"mcr.microsoft.com/devcontainers/{tag}",
                                "platform": platform})
    if not targets or len(targets) > 256:
        raise ValueError(f"Unsupported matrix size: {len(targets)}")
    return {"include": targets}


def released(cycle, today):
    return bool(cycle.get("releaseDate")) and cycle["releaseDate"] <= today


def expired(value, today):
    return value is True or (isinstance(value, str) and value <= today)


def aliases(cycle):
    values = {str(cycle["cycle"]).lower()}
    codename = cycle.get("codename", "").lower()
    if codename:
        values.update((codename, codename.split()[0]))
    return values


def lifecycle_report(entries, fetch=get_json, today=None):
    today = today or datetime.date.today().isoformat()
    cache = {}
    lines = [f"# Image lifecycle report ({today})", "",
             "Source: https://endoflife.date. Dates and release policies require upstream verification.",
             "A released cycle is a candidate, not confirmation that a compatible container tag exists.", ""]

    def cycles(product):
        if product not in cache:
            try:
                cache[product] = fetch(f"https://endoflife.date/api/{product}.json")
            except Exception as error:
                cache[product] = []
                lines.append(f"- COVERAGE GAP: {product} lifecycle lookup failed: {error}")
        return cache[product]

    for product in OS_PRODUCTS:
        cycles(product)
    for name, manifest in entries:
        lines.extend(["", f"## {name}"])
        product = PRODUCTS.get(name)
        tracked = {}
        variants = manifest.get("variants", [manifest.get("dependencies", {}).get("image", "unknown")])
        for variant in variants:
            matched_os = False
            for os_product in OS_PRODUCTS:
                for cycle in cycles(os_product):
                    if any(alias in re.split(r"[-:]", variant.lower()) for alias in aliases(cycle)):
                        if os_product == "alpine" and name != "base-alpine":
                            continue
                        tracked.setdefault(os_product, set()).add(str(cycle["cycle"]))
                        matched_os = True
                        for field in ("support", "eol"):
                            if expired(cycle.get(field), today):
                                lines.append(f"- {variant}: {os_product} {cycle['cycle']} {field} ended ({cycle[field]}).")
            if not matched_os:
                lines.append(f"- COVERAGE GAP: OS lifecycle not resolved for `{variant}`.")
            if product:
                match = re.match(r"\d+(?:\.\d+)*", variant)
                version = match.group() if match else None
                if product == "dotnet" and version:
                    version = version.removesuffix(".0")
                if version:
                    tracked.setdefault(product, set()).add(version)
                    cycle = next((item for item in cycles(product) if str(item["cycle"]) == version), None)
                    if cycle is None:
                        lines.append(f"- COVERAGE GAP: {product} {version} has no lifecycle record.")
                    elif expired(cycle.get("eol"), today):
                        lines.append(f"- EOL: {variant}: {product} {version} ({cycle['eol']}).")
                else:
                    lines.append(f"- COVERAGE GAP: runtime version not resolved for `{variant}`.")
        if not product:
            lines.append("- COVERAGE GAP: no runtime lifecycle mapping; installed runtimes/tools need manual review.")
        for tracked_product, present in sorted(tracked.items()):
            missing = [cycle for cycle in cycles(tracked_product)
                       if released(cycle, today) and not expired(cycle.get("eol"), today)
                       and str(cycle["cycle"]) not in present]
            for cycle in missing:
                policy = "LTS" if cycle.get("lts") else "stable/STS (verify upstream policy)"
                lines.append(f"- RELEASE CANDIDATE: {tracked_product} {cycle['cycle']} ({policy}), "
                             f"released {cycle['releaseDate']}; not represented in this manifest.")
        lines.append("- Reviewed variants: " + ", ".join(f"`{variant}`" for variant in variants))
    lines.extend(["", "## Maintainer action", "",
                  "Verify upstream release status, tags, architecture support, and lifecycle policy before changing variants.",
                  "Update variants, build.architectures, build.variantTags, and build.latest (except previews), then run smoke tests.",
                  "Bump the image manifest: major for breaking/base OS changes, minor for features, patch for fixes.",
                  "Update README version pins only for major/minor changes; release preparation handles patch pins."])
    return "\n".join(lines) + "\n"


def vulnerability_report(directory, matrix):
    lines = ["# Published image vulnerability report", "",
             "All severities, including unfixed findings. A missing scan is not a clean result.", ""]
    for target in matrix["include"]:
        lines.extend(["", f"## {target['image']} ({target['platform']})"])
        status = directory / f"{target['id']}.status"
        result = directory / f"{target['id']}.json"
        if not status.exists() or status.read_text().strip() != "success" or not result.exists():
            lines.append("- COVERAGE GAP: scan failed or artifact missing. Inspect the scan job logs.")
            continue
        try:
            data = json.loads(result.read_text())
        except (ValueError, OSError) as error:
            lines.append(f"- COVERAGE GAP: unreadable scanner result: {error}")
            continue
        count = 0
        for component in data.get("Results", []):
            for finding in component.get("Vulnerabilities", []):
                count += 1
                lines.append(f"- {finding['Severity']} {finding['VulnerabilityID']}: "
                             f"`{finding['PkgName']}` {finding['InstalledVersion']}; "
                             f"fixed: {finding.get('FixedVersion') or 'not available'}; "
                             f"target: `{component['Target']}`; {finding.get('PrimaryURL', '')}")
        lines.append(f"- Findings: {count}. Detection is limited to packages supported by Trivy and its advisory databases.")
    lines.extend(["", "## Mitigation", "",
                  "Use Dependabot PRs for supported declared dependencies. For container findings, verify the installed package's owner:",
                  "upstream base, apt/apk packages, Dev Container feature, or an installation script.",
                  "Rebuild with a fixed base/package/feature when available; otherwise track the upstream fix or remove the dependency.",
                  "Automatic container remediation PRs are not enabled: changing build scripts or variants requires maintainer validation."])
    return "\n".join(lines) + "\n"


def publish_issue(path, title):
    repository = os.environ["GITHUB_REPOSITORY"]
    token = os.environ["GH_TOKEN"]
    base = f"{os.environ.get('GITHUB_API_URL', 'https://api.github.com')}/repos/{repository}/issues"
    run = f"{os.environ.get('GITHUB_SERVER_URL', 'https://github.com')}/{repository}/actions/runs/{os.environ['GITHUB_RUN_ID']}"
    report = path.read_text()
    suffix = f"\n\nFull report and scanner artifacts: {run}\n"
    if len(report.encode()) > 55000:
        report = report.encode()[:55000].decode(errors="ignore") + "\n\nTRUNCATED: download the full report artifact."
    body = report + suffix
    page = 1
    while True:
        issues = get_json(f"{base}?state=open&per_page=100&page={page}", token)
        for issue in issues:
            if (issue["title"] == title and "pull_request" not in issue
                    and issue["user"]["login"] == "github-actions[bot]"):
                get_json(f"{base}/{issue['number']}", token, "PATCH", {"body": body})
                return
        if len(issues) < 100:
            break
        page += 1
    get_json(base, token, "POST", {"title": title, "body": body})


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("matrix", "lifecycle", "vulnerabilities", "publish"))
    parser.add_argument("--output", type=Path)
    parser.add_argument("--reports", type=Path)
    parser.add_argument("--title")
    args = parser.parse_args()
    if args.command == "publish":
        publish_issue(args.output, args.title)
        return
    if args.command == "matrix":
        content = json.dumps(scan_matrix(manifests()))
    elif args.command == "lifecycle":
        content = lifecycle_report(manifests())
    else:
        content = vulnerability_report(args.reports, scan_matrix(manifests()))
    if args.output:
        args.output.write_text(content)
    else:
        print(content)


if __name__ == "__main__":
    main()