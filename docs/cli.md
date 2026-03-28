# CLI Reference

The mui CLI is invoked via `haxelib run mui <command>`.

## Commands

### init

```bash
mui init [name]
```

Scaffolds a new project with:
- `src/<Name>.hx` -- app template with a counter
- `build-sui.hxml` / `build-wui.hxml` / `build-cui.hxml` -- build configs
- `mui.json` -- project metadata
- `.gitignore`

### build

```bash
mui build <backend> [options]
```

Builds the project for the specified backend.

| Backend | What happens |
|---------|-------------|
| `sui` | Delegates to `haxelib run sui build` (Haxe + Swift + Xcode) |
| `wui` | Delegates to `haxelib run wui build` (Haxe + C++/WinRT + MSBuild) |
| `cui` | Runs `haxe build-cui.hxml` directly (Haxe + hxcpp) |

### run

```bash
mui run <backend> [options]
```

Builds (if needed) and runs the app.

### clean

```bash
mui clean
```

Removes the `build/` directory.

### version

```bash
mui version
```

Prints `mui 0.1.0`.

## Build Files

Each backend has its own `.hxml` build file:

```
# build-sui.hxml
-cp src
-lib mui
-lib sui
-D mui_backend=sui
--macro sui.macros.SwiftGenerator.register()
-main MyApp
-cpp build/sui

# build-wui.hxml
-cp src
-lib mui
-lib wui
-D mui_backend=wui
-main MyApp
-cpp build/wui

# build-cui.hxml
-cp src
-lib mui
-lib cui
-D mui_backend=cui
-main MyApp
-cpp build/cui
```

The key line is `-D mui_backend=<backend>` which activates the correct backend at compile time.
