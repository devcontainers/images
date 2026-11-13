import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
from unittest import mock


SPEC = importlib.util.spec_from_file_location("dependency_report", Path(__file__).with_name("dependency-report.py"))
REPORT = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(REPORT)


class DependencyReportTests(unittest.TestCase):
    def test_matrix_expands_variants_and_architectures(self):
        manifest = {"version": "3.4.5", "variants": ["3.15-trixie"], "build": {
            "tags": ["python:${VERSION}-${VARIANT}"],
            "architectures": {"3.15-trixie": ["linux/amd64", "linux/arm64"]}}}
        targets = REPORT.scan_matrix([("python", manifest)])["include"]
        self.assertEqual(len(targets), 2)
        self.assertEqual(targets[0]["image"], "mcr.microsoft.com/devcontainers/python:3-3.15-trixie")
        self.assertEqual(targets[1]["platform"], "linux/arm64")

    def test_nonvariant_and_default_architecture(self):
        manifest = {"version": "2.1.0", "build": {"tags": ["universal:${VERSION}-noble"]}}
        target = REPORT.scan_matrix([("universal", manifest)])["include"][0]
        self.assertEqual(target["platform"], "linux/amd64")
        self.assertEqual(target["image"], "mcr.microsoft.com/devcontainers/universal:2-noble")

    def test_lifecycle_reports_eol_new_releases_and_unknowns(self):
        records = {
            "python": [
                {"cycle": "3.10", "releaseDate": "2021-10-04", "eol": "2026-10-01"},
                {"cycle": "3.16", "releaseDate": "2027-10-01", "eol": "2032-10-01"},
                {"cycle": "3.17", "releaseDate": "2028-10-01", "eol": False}],
            "debian": [{"cycle": "13", "codename": "Trixie", "releaseDate": "2025-08-09", "eol": "2030-06-30"}],
            "ubuntu": [], "alpine": []}
        report = REPORT.lifecycle_report(
            [("python", {"variants": ["3.10-trixie", "3.99-unknown"]})],
            fetch=lambda url: records[url.rsplit("/", 1)[1].replace(".json", "")], today="2027-11-01")
        self.assertIn("EOL: 3.10-trixie", report)
        self.assertIn("RELEASE CANDIDATE: python 3.16", report)
        self.assertNotIn("RELEASE CANDIDATE: python 3.17", report)
        self.assertIn("3.99 has no lifecycle record", report)
        self.assertIn("OS lifecycle not resolved", report)

    def test_lifecycle_service_failure_is_not_silent(self):
        def fail(_url):
            raise OSError("service unavailable")
        report = REPORT.lifecycle_report([("anaconda", {"dependencies": {"image": "anaconda:latest"}})], fetch=fail)
        self.assertIn("lookup failed", report)
        self.assertIn("no runtime lifecycle mapping", report)

    def test_dotnet_major_cycles_and_fixed_os_tags(self):
        records = {
            "dotnet": [{"cycle": "9", "releaseDate": "2024-11-12", "eol": "2026-11-10"}],
            "ubuntu": [{"cycle": "24.04", "codename": "Noble Numbat", "releaseDate": "2024-04-25", "eol": "2029-05-31"}],
            "debian": [], "alpine": []}
        report = REPORT.lifecycle_report(
            [("dotnet", {"variants": ["9.0-noble"]}),
             ("universal", {"dependencies": {"image": "ubuntu:noble"}})],
            fetch=lambda url: records[url.rsplit("/", 1)[1].replace(".json", "")], today="2026-11-10")
        self.assertIn("EOL: 9.0-noble: dotnet 9", report)
        self.assertNotIn("dotnet 9.0 has no lifecycle record", report)
        self.assertNotIn("OS lifecycle not resolved", report)
        self.assertNotIn("RELEASE CANDIDATE: dotnet 9", report)

    def test_scan_findings_include_unfixed_and_scan_failures(self):
        matrix = {"include": [
            {"id": "ok", "image": "python:3", "platform": "linux/amd64"},
            {"id": "missing", "image": "python:3", "platform": "linux/arm64"}]}
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            (directory / "ok.status").write_text("success")
            (directory / "ok.json").write_text(json.dumps({"Results": [{"Target": "site-packages", "Vulnerabilities": [
                {"Severity": "LOW", "VulnerabilityID": "CVE-test", "PkgName": "test", "InstalledVersion": "1"}]}]}))
            report = REPORT.vulnerability_report(directory, matrix)
        self.assertIn("LOW CVE-test", report)
        self.assertIn("fixed: not available", report)
        self.assertIn("COVERAGE GAP: scan failed", report)

    def test_repository_matrix_covers_every_manifest_variant(self):
        targets = REPORT.scan_matrix(REPORT.manifests())["include"]
        self.assertEqual(len({target["id"] for target in targets}), len(targets))
        self.assertTrue(all("$" not in target["image"] for target in targets))
        self.assertGreater(len(targets), len(REPORT.manifests()))

    def test_publisher_paginates_and_updates_only_bot_owned_issue(self):
        environment = {"GITHUB_REPOSITORY": "owner/images", "GH_TOKEN": "test-token",
                       "GITHUB_RUN_ID": "123", "GITHUB_API_URL": "https://api.github.test"}
        existing = [
            {"title": "Monitor", "number": 1, "user": {"login": "maintainer"}},
            {"title": "Monitor", "number": 2, "user": {"login": "github-actions[bot]"}}]
        with tempfile.TemporaryDirectory() as temporary, mock.patch.dict(REPORT.os.environ, environment):
            path = Path(temporary) / "report.md"
            path.write_text("Report")
            with mock.patch.object(REPORT, "get_json", side_effect=[[{"title": "other"}] * 100, existing, {}]) as api:
                REPORT.publish_issue(path, "Monitor")
        self.assertIn("page=2", api.call_args_list[1].args[0])
        self.assertTrue(api.call_args.args[0].endswith("/issues/2"))
        self.assertEqual(api.call_args.args[2], "PATCH")

    def test_publisher_truncates_with_artifact_link(self):
        environment = {"GITHUB_REPOSITORY": "owner/images", "GH_TOKEN": "test-token",
                       "GITHUB_RUN_ID": "123", "GITHUB_SERVER_URL": "https://github.com"}
        with tempfile.TemporaryDirectory() as temporary, mock.patch.dict(REPORT.os.environ, environment):
            path = Path(temporary) / "report.md"
            path.write_text("Finding\n" * 10000)
            with mock.patch.object(REPORT, "get_json", side_effect=[[], {}]) as api:
                REPORT.publish_issue(path, "Monitor")
        body = api.call_args.args[3]["body"]
        self.assertLess(len(body.encode()), 65536)
        self.assertIn("TRUNCATED", body)
        self.assertIn("https://github.com/owner/images/actions/runs/123", body)


if __name__ == "__main__":
    unittest.main()