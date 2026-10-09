# Security Policy

## Reporting a vulnerability

Please report security issues privately through GitHub's **Report a vulnerability** feature for this repository. Include affected versions, impact, and a minimal reproduction. Do not publish exploit details before a fix is available.

## Scope and safe testing

CompactGUI performs filesystem compression and interacts with Windows APIs. Do not test destructive operations on data you do not own. Supported builds use the pinned .NET 10 target; dependency and code-scanning reports are reviewed through GitHub Actions.
