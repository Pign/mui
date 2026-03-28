# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

mui is a cross-platform UI abstraction for Haxe that wraps three backend libraries under one API:
- **sui** (SwiftUI: macOS/iOS/visionOS) — compile-time Swift codegen via macros
- **wui** (WinUI 3: Windows) — compile-time C++/WinRT codegen
- **cui** (TUI: terminal) — runtime rendering with cell-level diffing

Backend selection is compile-time via `-D mui_backend=sui|wui|cui`. All abstraction compiles away to zero runtime overhead.

## Building and Running Examples

```bash
# Terminal (fastest for development)
cd examples/form && haxe build-cui.hxml && ./build/cui/FormApp

# macOS (delegates to sui CLI for full Xcode pipeline)
cd examples/form && haxelib run mui build sui

# Via mui CLI
haxelib run mui run cui    # build + run for terminal
haxelib run mui run sui    # build + run for macOS
haxelib run mui run sui ios  # iOS simulator
```

Each example directory has `build-sui.hxml`, `build-wui.hxml`, `build-cui.hxml`. The sui hxml MUST use `-cpp build/cpp` (not `build/sui`) because the sui CLI hardcodes that path for bridge compilation.

## Architecture: Three Abstraction Patterns

Every file in `src/mui/` uses `#if (mui_backend == "xxx")` blocks internally. The three patterns, from simplest to most complex:

### 1. Typedef (identical APIs)
Zero-cost alias to the backend type. Used by: `View.hx`, `ViewComponent.hx`, `Text.hx`, `Spacer.hx`, `State.hx`, `Binding.hx`, `Observable.hx`, `Image.hx`, `ListView.hx`.

### 2. Subclass (constructor normalization)
Extends backend class, reorders/transforms constructor args. Used by: `App.hx`, `VStack.hx`, `HStack.hx`, `Button.hx`, `Toggle.hx`, `TextInput.hx`, `ProgressView.hx`, `Divider.hx`, `TabView.hx`.

### 3. Abstract with @:from (type-safe binding conversion)
Wraps a different underlying type per backend with implicit compile-time conversion. Used by: `ToggleBinding.hx`, `TextInputBinding.hx`, `ColorValue.hx`, `FontStyle.hx`, `Alignment.hx`.

Additionally, `ForEach.hx` uses a **compile-time macro** (`ForEachMacro.hx`) that transforms builder closures into backend-specific code.

## Critical Gotchas

**@:autoBuild must NOT be repeated on mui.App.** The backend App classes (sui.App, wui.App, cui.App) already have `@:autoBuild(StateMacro.build())` which propagates to subclasses. Adding it again on mui.App causes the macro to run twice, corrupting `@:state` field types.

**Spacing is in pixels, not terminal cells.** VStack/HStack scale Float spacing for cui: `Math.ceil(spacing / 8)` capped at [1,2] for VStack, `Math.ceil(spacing / 4)` capped at [1,4] for HStack. Users pass pixel-scale values (e.g., `8`) and cui gets `1`.

**SUI SwiftGenerator processes typed AST, not runtime values.** Constructor arguments with `@:swiftBinding` metadata must resolve to extractable values. The `extractBindingFieldName()` function in SwiftGenerator walks `TField` chains back to `this` and unwraps through `@:from` calls (`TCall`, `TNew`, `TCast`). If it can't extract a string, the binding argument is silently skipped in generated Swift.

**TextInput parameter order is reversed on cui.** `cui.ui.Input` takes `(binding, placeholder)` while sui/wui take `(placeholder, binding)`. The TextInput wrapper corrects this.

**cui.state.State does NOT have a `.value` property.** All three backends have `.get()` and `.set()` (after patching wui). Using `.value` works on sui/wui but fails on cui. Use `.get()`/`.set()` for cross-platform code.

**cui padding()/with no args is a no-op.** cui's padding takes `Int` params defaulting to null/0. Unlike sui where `padding()` adds default 16pt padding, on cui it does nothing. Always pass explicit values: `padding(1)`.

## Build System Details

**cui builds** run `haxe build-cui.hxml` directly — no special pipeline.

**sui/wui builds** delegate to backend CLIs which handle the full pipeline. `Build.hx` creates a `build.hxml` include file and (for sui) a `sui.json` config so the backend CLI can find the configuration. The sui pipeline: Haxe → C++ (hxcpp) + Swift codegen → static library + bridge → Xcode → .app bundle.

**iOS cross-compilation**: hxcpp's iphonesim toolchain outputs x86_64. The bridge and Xcode destination must match. Device builds use arm64 via `-D iphoneos`.

## Adding a New Backend

Add `#elseif (mui_backend == "newbackend")` to ~20 files. Each is 2-5 lines: import + constructor adapter. Also add: `@:from` in ToggleBinding/TextInputBinding, color/font mappings in enums, ForEachMacro case, CLI build/run case. See `docs/adding-a-backend.md`.
