# Conda local feature

Vendored from [devcontainers/features Conda](https://github.com/devcontainers/features/tree/87bc90767461e2b964fb9622e592ed83bea4548d/src/conda)
(feature version `2.0.1`).

Universal uses this local feature to install Miniconda and apply its security
patches in the same image layer, replacing the separate `patch-conda` feature.
The upstream version and `addCondaForge` options, environment variables, user
setup, and Anaconda notice are preserved.

Local changes:

- Install `cryptography=50.0.0`, `pyopenssl=26.4.0`, `openssl=3.5.8`, and
  `brotli=1.2.0` in one Conda transaction.
- Upgrade pip and install `python-dotenv==1.2.2` without a pip download cache.
  Pip is upgraded after the Conda transaction to avoid a solver downgrade.
- Clean Conda caches, vulnerable extracted pip packages older than `26.1`,
  Python bytecode, and root/target-user pip caches after patching, including
  when Conda is already installed.

The installer still downloads Miniconda from Anaconda; the distribution is
not vendored. Existing image smoke tests verify the security package versions
and check for vulnerable cached pip packages.
