# Dependency management

## Coverage

| Requirement | Automation | Limits |
| --- | --- | --- |
| GitHub Actions references | Weekly Dependabot PRs for workflows and supported action metadata | Referenced actions' internal dependencies are owned upstream. Review major changes. |
| Dev Container features | Weekly Dependabot `devcontainers` PRs for root and image configurations, including supported lockfile updates | Major feature changes, configuration migrations, and image manifest bumps still require review. Check that both configuration and lockfile are consistent in each PR. |
| Docker base references | Weekly Dependabot Docker PRs where references can be parsed | `${VARIANT}` references and manifest-driven new variants cannot be comprehensively updated by Dependabot. |
| New LTS/STS/stable releases and EOL | Weekly lifecycle tracking issue, generated from every image manifest and endoflife.date | Candidates require official upstream release/tag/architecture verification. Future release dates are excluded. API failures, unknown cycles, and unmapped runtimes are reported as coverage gaps. |
| Root npm dependencies | Weekly Dependabot npm PRs; GitHub alerts/security PRs when enabled and supported | Embedded packages and dependencies installed in shell commands are not npm manifests. |
| OS and embedded language vulnerabilities | Weekly Trivy scans of every manifest variant and declared architecture; one tracking issue plus full JSON/Markdown artifacts | Detection depends on Trivy support, installed package metadata, and advisory databases. This is not a guarantee of detecting every upstream vulnerability. |

The monitor runs on Tuesdays and can be dispatched manually using **Dependency lifecycle and vulnerability reports**. Pull requests touching the monitor run its offline tests only. It never executes pull request code with a write token.

## Maintainer setup

1. Enable the dependency graph, Dependabot alerts, and Dependabot security updates in repository **Settings > Advanced Security** (the exact UI can vary). The configuration file enables version updates, not these repository settings. Availability of security alerts/updates varies by ecosystem.
2. Enable Actions, allow the actions used by the monitoring workflow, enable repository Issues, and permit `GITHUB_TOKEN` to write issues in the reporting jobs. No personal access token or registry write credentials are needed. Organization policies may restrict these permissions.
3. Merge these files to the default branch. Dependabot and scheduled workflows use that branch. Manually dispatch the monitor to confirm image pulls, scanner database downloads, lifecycle lookups, and issue writes work in the repository's runner/network environment.
4. Assign maintainers to the two tracking issues. The workflow refreshes open bot-owned issues rather than creating duplicate issues on every run. A closed tracking issue is recreated on the next run. Reports are uploaded before issue publishing, so a failed issue write still leaves a downloadable report in the run.

Dependabot PRs use the existing image smoke-test workflows. For image changes, also update the image's manifest version: major for breaking changes such as a base OS change, minor for features, patch for fixes. Dependabot does not perform that repository-specific bump. Major/minor changes must update README version pins; patch changes must leave those pins to release preparation. Do not auto-merge image changes without these checks.

## Release and EOL reporting

The report covers Python, .NET, Go, Node.js, Ruby (including Jekyll's Ruby base), PHP, Alpine, Debian, and Ubuntu release cycles. OS codenames are resolved from lifecycle metadata, not a fixed codename list. Both expired standard support and EOL dates are reported for mapped OS cycles. Debian's recorded EOL can include its LTS phase; Ubuntu extended paid support is not treated as standard support.

All released, non-EOL cycles absent from each mapped manifest are reported as candidates, including stable/STS and LTS cycles. This can include older supported cycles intentionally omitted by maintainers. LTS status comes from the lifecycle feed; an absent/false LTS marker is not proof of an upstream STS policy. The report does not automatically add variants or set `latest`. Upstream tag availability, preview status, distro combinations, architecture support, and compatibility must be validated before a PR.

New variants need `variants`, `build.architectures`, `build.variantTags`, and `build.latest` updates (unless a preview). Follow the manifest/README version rules and run the affected image's smoke tests.

Java vendor-specific support policies are not selected automatically. Anaconda, Miniconda, rolling Rust/tool versions, Jekyll itself, and additional runtimes installed by features or scripts do not currently have complete runtime lifecycle mapping. They are explicitly reported as gaps; review their upstream policies manually. Unknown OS variants likewise require manual review. Lifecycle lookup failures are reported, not interpreted as supported versions.

## Vulnerability reporting and remediation

Scan targets use the first `build.tags` template, the manifest's major-version alias, every `variants` entry, and `build.architectures` (defaulting to `linux/amd64`, as the build does). These are published MCR images, not newly built PR images or all historical releases. Other tag aliases for the same variant are not scanned separately. A new major/variant not yet published is reported as a coverage gap, not silently skipped. Stable aliases can lag main-branch changes until release; unpublished changes are not covered by these scans.

Trivy scans OS and language packages at all severities, including findings without a fixed version. This can detect supported Linux system libraries, Python packages, npm packages, Go modules/binaries, and other supported ecosystems in the final image. It cannot guarantee coverage of every statically linked, vendored, manually compiled, or metadata-free dependency. Missing artifacts, registry errors, scanner failures, and API errors are visible in reports. Full scanner output is retained for 14 days; Markdown reports for 30 days. Large issue bodies are explicitly truncated and link to the full run artifacts.

Dependabot creates mitigation PRs only for supported dependencies it can update safely. There is no automatic patch PR generator for container vulnerability findings. Maintainers must trace a finding to its base image, OS package, feature, or install script; update/rebuild using an available fix; bump the image manifest; and validate with smoke tests. Findings without fixes remain in the report. Refer to upstream advisories and scanner package paths before selecting a mitigation.

The scan matrix is currently below GitHub's 256-job limit and runs with four concurrent scans. The monitor fails explicitly if growth exceeds that limit; split the matrix before adding more targets. The full run can consume substantial runner time and bandwidth, particularly for large multi-architecture images. Adjust frequency/concurrency according to repository capacity without silently dropping variants.

## Local checks

```bash
python3 -m unittest discover -s build -p 'test_dependency_report.py' -v
python3 build/dependency-report.py matrix
python3 build/dependency-report.py lifecycle --output lifecycle-report.md
```

The tests are offline and use Python's standard library. The lifecycle command requires network access. End-to-end vulnerability scans, GitHub issue writes, Dependabot PR creation, and repository settings must be verified in GitHub; local tests do not establish that these services are enabled.