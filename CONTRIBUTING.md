# Contributing

1. Use the .NET 10 SDK and prepare the pinned localization dependency with `./eng/Prepare-LazyTranslate.ps1`.
2. Run `dotnet restore CompactGUI.slnx`, `dotnet build CompactGUI.slnx -c Release --no-restore --warnaserror`, and `dotnet test CompactGUI.slnx -c Release --no-build --no-restore`.
3. Keep changes scoped, add regression tests for behavior fixes, and never suppress diagnostics to make CI pass.
4. Do not run compression or decompression tests against user data; use temporary fixtures.

Pull requests should explain user-visible behavior changes, Windows/.NET requirements, and any filesystem or registry effects.
