### **IMPORTANT NOTE**

Scripts in this directory are sourced externally and not maintained by the Dev Container spec maintainers. Do not make changes directly as they might be overwritten at any moment.

## dotnet-install.sh

`dotnet-install.sh` is a copy of <https://dot.net/v1/dotnet-install.sh>. ([Script reference](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script))

Quick options reminder for `dotnet-install.sh`:

- `--version`: `"latest"` (default) or an exact version in the form A.B.C like `"6.0.413"`
- `--channel`: `"LTS"` (default), `"STS"`, a two-part version in the form A.B like `"6.0"` or three-part form A.B.Cxx like `"6.0.1xx"`
- `--quality`: `"daily"`, `"preview"` or `"GA"`
- The channel option is only used when version is 'latest' because an exact version overrides the channel option
- The quality option is only used when channel is 'A.B' or 'A.B.Cxx' because it can't be used with STS or LTS

Examples

```
dotnet-install.sh [--version latest] [--channel LTS]
dotnet-install.sh [--version latest] --channel STS
dotnet-install.sh [--version latest] --channel 6.0 [--quality GA]
dotnet-install.sh [--version latest] --channel 6.0.4xx [--quality GA]
dotnet-install.sh [--version latest] --channel 8.0 --quality preview
dotnet-install.sh [--version latest] --channel 8.0 --quality daily
dotnet-install.sh --version 6.0.413
```