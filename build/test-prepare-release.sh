#!/bin/bash

# Tests for the update_readme_version function in prepare-release.sh.
# Run from anywhere: bash build/test-prepare-release.sh

set -euo pipefail

SCRIPT_SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TMPDIR_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_ROOT"' EXIT

PASS=0
FAIL=0

run_test() {
	local name="$1"
	local old_version="$2"
	local new_version="$3"
	local readme_content="$4"
	local expected_readme="$5"

	local test_dir="$TMPDIR_ROOT/$name"
	mkdir -p "$test_dir"
	printf '%s\n' "$readme_content" > "$test_dir/README.md"

	# Source update_readme_version by extracting it from the script
	(
		# Define only update_readme_version and its dependencies
		source <(sed -n '/^update_readme_version()/,/^}/p' "$SCRIPT_SOURCE_DIR/prepare-release.sh")
		update_readme_version "$test_dir" "$old_version" "$new_version"
	) || { echo "FAIL: $name (update_readme_version failed)"; FAIL=$((FAIL + 1)); return; }

	local actual_readme
	actual_readme=$(cat "$test_dir/README.md")

	if [ "$actual_readme" = "$expected_readme" ]; then
		echo "PASS: $name"
		PASS=$((PASS + 1))
	else
		echo "FAIL: $name"
		echo "  Expected: $expected_readme"
		echo "  Actual:   $actual_readme"
		FAIL=$((FAIL + 1))
	fi
}

# ---------------------------------------------------------------------------
# Test 1: Only semantic tags in the pinned release section are updated.
# Development tags and major release tags must remain unchanged.
# ---------------------------------------------------------------------------
run_test "updates_only_pinned_release_tags" \
	"2.1.3" \
	"2.1.4" \
	"### Release tags
- \`mcr.microsoft.com/devcontainers/go:2-1.26\`

### Development tags (\`dev-*\`)
- \`mcr.microsoft.com/devcontainers/go:dev-1.26\`

### Pinned release tags
- \`mcr.microsoft.com/devcontainers/go:2.1-1.26\` (or \`2.1-1.26-trixie\`, \`2.1-1.26-bookworm\`)
- \`mcr.microsoft.com/devcontainers/go:2.1.3-1.26\` (or \`2.1.3-1.26-trixie\`, \`2.1.3-1.26-bookworm\`)

## Other guidance
- \`mcr.microsoft.com/devcontainers/go:2.1.3-unchanged\`" \
	"### Release tags
- \`mcr.microsoft.com/devcontainers/go:2-1.26\`

### Development tags (\`dev-*\`)
- \`mcr.microsoft.com/devcontainers/go:dev-1.26\`

### Pinned release tags
- \`mcr.microsoft.com/devcontainers/go:2.1-1.26\` (or \`2.1-1.26-trixie\`, \`2.1-1.26-bookworm\`)
- \`mcr.microsoft.com/devcontainers/go:2.1.4-1.26\` (or \`2.1.4-1.26-trixie\`, \`2.1.4-1.26-bookworm\`)

## Other guidance
- \`mcr.microsoft.com/devcontainers/go:2.1.3-unchanged\`"

# ---------------------------------------------------------------------------
# Test 2: Standard backtick-terminated patch tag is updated correctly.
# ---------------------------------------------------------------------------
run_test "patch_backtick_tag_updated" \
	"2.1.3" \
	"2.1.4" \
	"### Pinned release tags
- \`mcr.microsoft.com/devcontainers/go:2.1.3\` (latest patch)" \
	"### Pinned release tags
- \`mcr.microsoft.com/devcontainers/go:2.1.4\` (latest patch)"

# ---------------------------------------------------------------------------
# Test 3: Colon-prefixed patch tag with variant suffix is updated.
# ---------------------------------------------------------------------------
run_test "patch_colon_variant_tag_updated" \
	"1.3.5" \
	"1.3.6" \
	"### Pinned release tags
mcr.microsoft.com/devcontainers/python:1.3.5-bullseye" \
	"### Pinned release tags
mcr.microsoft.com/devcontainers/python:1.3.6-bullseye"

# ---------------------------------------------------------------------------
# Test 4: mid-line backtick-prefixed patch tag with variant is updated.
# The README must also contain a colon-prefixed reference to pass the guard.
# ---------------------------------------------------------------------------
run_test "patch_backtick_variant_tag_updated" \
	"3.0.1" \
	"3.0.2" \
	"### Pinned release tags
- \`mcr.microsoft.com/devcontainers/base:3.0.1-bookworm\`
- Use \`3.0.1-bookworm\` for the stable variant." \
	"### Pinned release tags
- \`mcr.microsoft.com/devcontainers/base:3.0.2-bookworm\`
- Use \`3.0.2-bookworm\` for the stable variant."

# ---------------------------------------------------------------------------
# Test 5: The updater replaces the previous semantic tag with the final manifest
# version even when a contributor made a major or minor version change first.
# ---------------------------------------------------------------------------
run_test "arbitrary_manifest_version_transition" \
	"3.1.6" \
	"4.0.1" \
	"### Pinned release tags
- \`mcr.microsoft.com/devcontainers/anaconda:3.1.6-3\`" \
	"### Pinned release tags
- \`mcr.microsoft.com/devcontainers/anaconda:4.0.1-3\`"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
