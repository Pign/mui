# Hot Reload

`mui watch` monitors your source files and automatically rebuilds when you save changes. It uses different strategies per backend to minimize reload time.

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

# macOS (dynamic renderer — first build ~30s, subsequent ~10s)
haxelib run mui watch sui

# Android (dynamic renderer — first build ~60s, subsequent ~15s)
haxelib run mui watch aui

# Windows (warm reload — rebuilds via MSBuild)
haxelib run mui watch wui
```

### Step 3: Edit your code

Open `src/MyApp.hx` in your editor, change something, and save. The watcher detects the change, recompiles, and updates your app.

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

### sui / aui: Dynamic renderer

For GUI backends, the first build uses `--watch` mode which includes a **dynamic view renderer** in the host app:

- **sui**: `DynamicView.swift` — a recursive SwiftUI component that reads the Haxe view tree at runtime via the ViewNode bridge, instead of using statically generated Swift code
- **aui**: `DynamicComposable.kt` — same pattern for Jetpack Compose

The ViewNode bridge is a set of C functions (`viewnode_get_type`, `viewnode_child_count`, `viewnode_get_child`, etc.) that let the native renderer traverse the Haxe view tree. This bridge is shared across all backends.

On subsequent changes, the watcher triggers a rebuild. Because the host already contains the dynamic renderer, only the Haxe code needs to recompile — the Swift/Kotlin layer stays the same.

### wui: warm reload

WinUI uses standard warm reload — full rebuild + restart via MSBuild on each change.

### Reload speed

| Backend | First build | Subsequent builds | Strategy |
|---------|------------|-------------------|----------|
| cui | ~30s | **~0.3s** | CPPIA script recompile |
| sui | ~30s | ~10-20s | Dynamic renderer + Xcode incremental |
| aui | ~60s | ~15-30s | Dynamic renderer + Gradle incremental |
| wui | ~20s | ~10-15s | Full warm reload |

## Architecture

```
┌──────────────────────────────────────┐
│     Native Host App (built once)     │
│                                      │
│  ┌──────────────┐  ┌──────────────┐  │
│  │ Dynamic       │←─│  ViewNode    │  │
│  │ Renderer      │  │  Bridge     │  │
│  │ (SwiftUI /    │  │  (C funcs)   │  │
│  │  Compose)     │  │              │  │
│  └──────────────┘  └──────┬───────┘  │
│                           │          │
│  ┌────────────────────────┴────────┐ │
│  │     Haxe View Tree (runtime)    │ │
│  │     body() → VStack, Text, ...  │ │
│  └─────────────────────────────────┘ │
└──────────────────────────────────────┘
         ↑ rebuilt on each .hx change
```

The dynamic renderer (`DynamicView.swift` on sui, `DynamicComposable.kt` on aui) interprets the Haxe view tree at runtime:

1. Calls `viewnode_get_root()` to get the root ViewNode
2. Reads `viewnode_get_type()` to determine the view type (VStack, Text, Button, etc.)
3. Recursively renders children via `viewnode_get_child()`
4. Applies modifiers from `viewnode_modifier_type()` / `viewnode_modifier_float()`

This is only used during development. Production builds (`mui build`) use the static codegen path for best performance.

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

| Command | Purpose | Renderer | Speed |
|---------|---------|----------|-------|
| `mui build` | Production. Static codegen, best performance. | Static | One-time |
| `mui run` | Build once and run. | Static | One-time |
| `mui watch` | Development. Auto-rebuild on save. | Dynamic | Continuous |

Same source code works with all three commands. `watch` uses the dynamic renderer for fast iteration, `build` uses static codegen for shipping.
