# Native SDK libraries / 原生 SDK 函式庫

This showcase uses a version 2 Bottle manifest and the current native SDK. The application imports the named
module `Showcase` / `動態連結範例`; the host loads the declared native library automatically.

```aqua
var library=import("Showcase");
print(library.Greeting());
print(library.Echo("你好 / Hello"));
print(library.Sum([10,20,12]));
```

The library lives in `libraries/showcase`: `aqua.toml` declares its module and native source folder,
`src/CMakeLists.txt` calls `aqua_add_library(showcase SOURCES showcase.c)`, and `src/showcase.c` registers functions
with `AQUA_LIBRARY(showcase)` from `<aqua/aqua.h>`. SDK values carry strings and arrays across the function table.
Each call validates its arguments; failures use `aqua_fail`. No application-level symbol lookup is required.

```powershell
aqua library build libraries/showcase --targets windows-x64,web,android-arm64-v8a,android-x86_64
aqua bottle update --project . --offline
aqua run .
aqua build . --target web -o dist/web
```

Build the Linux binary from Linux/WSL with the SDK's pinned Clang toolchain. Desktop and Android use shared
native libraries; the browser loads the same C source compiled to a Wasm side module. Desktop exports keep their
`libraries/` directory alongside the executable. Running the project directory preserves the resolved Bottle
dependency graph. A standalone `.wasm` file alone does not carry paths to external native libraries.

The old `DynamicLibrary` module, buffer ABI 1 header, JavaScript library adapter and C# runtime binding design
have been retired. The compiler remains C#; native application runtimes and this library do not require .NET.