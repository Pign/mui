# mui

Multi-UI abstraction layer for Haxe. Write your app once, compile to native macOS/iOS (SwiftUI), Windows (WinUI 3), or terminal (TUI).

## Quick Start

```bash
haxelib git mui https://github.com/Pign/mui
haxelib run mui init MyApp
cd MyApp
mui run cui       # terminal
mui build sui     # macOS/iOS
mui build wui     # Windows
```

## How It Works

mui is a thin wrapper over three backend libraries:

| Backend | Target Platform | Library |
|---------|----------------|---------|
| `sui`   | macOS, iOS, visionOS (SwiftUI) | [Pign/sui](https://github.com/Pign/sui) |
| `wui`   | Windows (WinUI 3) | [Pign/wui](https://github.com/Pign/wui) |
| `cui`   | Terminal (TUI) | [Pign/cui](https://github.com/Pign/cui) |

Backend selection is compile-time via `-D mui_backend=sui|wui|cui`. All mui types compile down to the backend types with zero runtime overhead.

## Example

```haxe
import mui.App;
import mui.View;
import mui.ui.*;

class MyApp extends App {
    @:state var count:Int = 0;

    override function body():View {
        #if (mui_backend == "cui")
        var c = count.get();
        #else
        var c = count.value;
        #end

        return new VStack([
            new Text("Counter"),
            new Text('Count: $c'),
            new HStack([
                #if (mui_backend == "cui")
                new Button("-", function() count.set(count.get() - 1)),
                new Button("+", function() count.set(count.get() + 1)),
                #else
                new Button("-", function() count.value = count.value - 1),
                new Button("+", function() count.value = count.value + 1),
                #end
            ], 8),
        ], 10);
    }
}
```

## Unified Components

These components have normalized constructors that work across all backends:

| mui Component | sui | wui | cui |
|--------------|-----|-----|-----|
| `Text(content)` | Text | Text | Text |
| `VStack(children, ?spacing)` | VStack | VStack | VStack |
| `HStack(children, ?spacing)` | HStack | HStack | HStack |
| `Button(label, ?action)` | Button | Button | Button |
| `Spacer()` | Spacer | Spacer | Spacer |
| `Divider()` | Divider | Border | Divider |
| `ProgressView(?label, ?value)` | ProgressView | ProgressRing | ProgressBar |

These are direct typedefs (backend-specific constructors):

| mui Component | Notes |
|--------------|-------|
| `Toggle` | Binding types differ per backend |
| `TextInput` | Binding types differ per backend |
| `ForEach` | String-based codegen (sui) vs runtime (cui/wui) |
| `ListView` | Constructor differs per backend |
| `ScrollView` | cui requires scroll offset binding |
| `TabView` | cui requires active tab binding |
| `Image` | Not available on cui |

## Unified Enums

`mui.enums.ColorValue` and `mui.enums.FontStyle` provide cross-platform color and font types with `.toBackend()` conversion:

```haxe
import mui.enums.ColorValue;
import mui.enums.FontStyle;

// Use .toBackend() to pass to backend modifiers
view.foregroundColor(ColorValue.Red.toBackend());
view.font(FontStyle.Title.toBackend());
```

### ColorValue

`Primary`, `Secondary`, `Accent`, `Red`, `Orange`, `Yellow`, `Green`, `Blue`, `Purple`, `Pink`, `White`, `Black`, `Gray`, `Clear`, `Rgb(r,g,b)`, `Hex("#RRGGBB")`

### FontStyle

`LargeTitle`, `Title`, `Headline`, `Body`, `Caption`, `Custom(name, size)`

On cui (terminal), fonts map to bold/dim text attributes.

## State API

The `@:state` macro works on all backends:

```haxe
@:state var count:Int = 0;
```

State access methods differ by backend:

| Method | sui | wui | cui |
|--------|-----|-----|-----|
| `.value` | Yes | Yes | No |
| `.get()` | Yes | No | Yes |
| `.set(v)` | Yes | No | Yes |
| `.inc()` | Yes (returns StateAction) | Yes (returns StateAction) | Yes (returns Void) |
| `.dec()` | Yes (returns StateAction) | Yes (returns StateAction) | Yes (returns Void) |

Use `#if (mui_backend == "cui")` blocks around state access for cross-platform code.

## Platform-Specific Code

Use Haxe's conditional compilation for backend-specific features:

```haxe
#if (mui_backend == "sui")
// SwiftUI-specific: navigation, sheets, animations
view.navigationTitle("Settings");
view.sheet(isShowingBinding, sheetContent);
#elseif (mui_backend == "wui")
// WinUI-specific: window size, tooltips
windowWidth = 1024;
view.toolTip("Help text");
#elseif (mui_backend == "cui")
// Terminal-specific: event handling, borders
override function handleEvent(event:cui.event.Event):Bool { ... }
view.border(cui.render.BorderStyle.Rounded);
#end
```

## CLI

```
mui init [name]       Scaffold a new project
mui build <backend>   Build (sui, wui, or cui)
mui run <backend>     Build and run
mui clean             Remove build artifacts
mui version           Show version
```

## Adding a New Backend

To add a new backend (e.g., `gtk` for Linux):

1. Create the backend library with the standard structure:
   - `App` base class with `@:autoBuild` StateMacro
   - `View` base class with modifier methods
   - `state/State<T>` with reactive state
   - `ui/` components (Text, VStack, HStack, Button, etc.)

2. Add `#elseif (mui_backend == "gtk")` blocks to each mui file (~20 files). Each addition is 2-5 lines: import the backend type and adapt the constructor.

3. Add color/font mappings in `mui/enums/ColorValue.hx` and `FontStyle.hx`.

4. Add a build case in `tools/cli/Build.hx` and `Run.hx`.

## Prerequisites

- Haxe 4.3+
- hxcpp
- Backend-specific: Xcode (sui), Visual Studio 2022 (wui), or just a terminal (cui)

## License

MIT
