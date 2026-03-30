# Hot Reload

`mui watch` monitors your source files and automatically rebuilds when you save. For the terminal backend (cui), it uses CPPIA for sub-second reloads.

## Quick Start

### Step 1: Create or open a project

```bash
haxelib run mui init MyApp
cd MyApp
```

### Step 2: Start the watcher

```bash
# Terminal (CPPIA hot reload — ~0.3s per change)
haxelib run mui watch cui

# macOS (warm reload — rebuilds via Xcode)
haxelib run mui watch sui

# Android (warm reload — rebuilds via Gradle)
haxelib run mui watch aui

# Windows (warm reload — rebuilds via MSBuild)
haxelib run mui watch wui
```

### Step 3: Edit your code

Open `src/MyApp.hx` in your editor, change something, and save. The watcher detects the change, recompiles, and relaunches your app.

```
[watch] Tracking 12 .hx files
[watch] Ready. Launching...
[watch] Changed: MyApp.hx
[watch] Recompiling...
[watch] Ready. (312ms)
```

### Step 4: Stop

Press `Ctrl+C` to stop the watcher and kill the running app.

## How It Works

### cui: CPPIA hot reload (<1s)

[CPPIA](https://haxe.org/manual/target-cppia.html) is hxcpp's scripting mode. It splits compilation into two parts:

1. **Host binary** (built once by hxcpp, included with the library): contains the C++ runtime, terminal I/O, and standard library
2. **CPPIA script** (recompiled per change, ~0.3s): your app code as platform-independent bytecode

When you change a file, only the `.cppia` script is recompiled — no C++ compilation needed. The host binary reruns with the new script immediately.

This is why cui hot reload is so fast: a full hxcpp C++ build takes ~30s, but a CPPIA script recompile takes **0.3s** — a 100x speedup.

### sui / wui / aui: warm reload

For GUI backends, the watcher triggers a full rebuild via the backend CLI (`sui build`, `wui build`, `aui build`). These use incremental compilation (Xcode, MSBuild, Gradle), so subsequent rebuilds are faster than the first.

The app is killed and relaunched after each successful build.

| Backend | First build | Subsequent builds |
|---------|------------|-------------------|
| cui | ~30s | **~0.3s** (CPPIA) |
| sui | ~30s | ~10-20s (Xcode incremental) |
| wui | ~20s | ~10-15s (MSBuild incremental) |
| aui | ~60s | ~15-30s (Gradle incremental) |

## Build Errors

If your code has errors, the watcher prints the error and waits for the next change. It does not relaunch the app on failure:

```
[watch] Changed: MyApp.hx
[watch] Recompiling...
src/MyApp.hx:15: characters 8-12 : Unknown identifier: foo
[watch] Build failed. Waiting for changes...
```

Fix the error, save, and the watcher picks up the change automatically.

## watch vs build vs run

| Command | Purpose | Speed |
|---------|---------|-------|
| `mui build` | Production build. Static codegen, best performance. | One-time |
| `mui run` | Build once and run. | One-time |
| `mui watch` | Development. Auto-rebuild on save. CPPIA for cui. | Continuous |

Same source code works with all three commands. `watch` is for development, `build` is for shipping.
