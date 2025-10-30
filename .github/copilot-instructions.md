# For Copilot Code Review
- Every image change must bump the version in the image's `manifest.json` using semantic versioning.
- Breaking changes (for example, swapping the base OS) require a major bump; new non-breaking features require a minor bump; security or bug fixes require a patch bump.
- Adding a variant means updating the architecture entry in `manifest.json`, listing the variant in `variantTags`, and setting it as `latest` unless it is a preview.
- Keep the README in sync: update variant tables, tags, and version references to match the manifest.
- Example: PR #1548 switched `src/typescript-node/.devcontainer/Dockerfile` to the `4-*` JavaScript base, so `src/typescript-node/manifest.json` moved from 3.0.3 to 4.0.0, added the `*-trixie` variants to both `variants` and `build.architectures`, updated `variantTags`, and set `build.latest` to `24-trixie`; `src/typescript-node/README.md` then reflected the new default tags.