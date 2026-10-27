# Aquarius native library showcase

The application imports `Showcase` / `動態連結範例`, a version 2 Bottle library written in C17 against `<aqua/aqua.h>`. It demonstrates UTF-8 strings and numeric arrays on Windows, Linux, Android and the web. The native library exports only the SDK entry point; there is no application-level DLL loader, buffer ABI or JavaScript library.

Use the current `aqua` compiler on PATH and install its pinned native toolchains first. On Windows:

```powershell
./build.ps1 -Targets wasm,windows,web,android
aqua run .
```

For Linux, build the library from Linux or WSL with `aqua library build libraries/showcase --targets linux-x64`, then build/run the project with the Linux compiler. Pass `-Aqua` to select a compiler explicitly. Exported applications do not need .NET. Preserve the exported `libraries/` directory alongside desktop executables.

The application exits with an error if the sum or Unicode round trip is wrong. A successful run prints `DYNAMIC_LINKING_OK`.
