# Oryx local feature

This feature is vendored from `ghcr.io/devcontainers/features/oryx:2.0.1`,
previously locked to manifest digest
`sha256:8ae830d9e0f1c456e33c5436110d3eb1720a4565e5fcef089352f7d3b4feb74f`.
The feature metadata, installer, and bundled .NET installer are unchanged.

The universal image uses this local source so changes to the feature can be
maintained alongside the image. The installer still downloads and builds
[Microsoft Oryx](https://github.com/microsoft/Oryx); it does not vendor Oryx itself.

The bundled .NET installer is required to build Oryx with its pinned SDK. See
[the vendor documentation](scripts/vendor/README.md) for its source and usage.
