# Getting Started

## Prerequisites

- [Haxe](https://haxe.org/) 4.3+
- [hxcpp](https://lib.haxe.org/p/hxcpp/)
- At least one backend library installed

Backend-specific requirements:
- **sui**: macOS with Xcode
- **wui**: Windows with Visual Studio 2022 (C++ workload)
- **cui**: any terminal (macOS, Linux)

## Installation

```bash
# Install mui
haxelib git mui https://github.com/Pign/mui

# Install backend(s)
haxelib git sui https://github.com/Pign/sui
haxelib git wui https://github.com/Pign/wui
haxelib git cui https://github.com/Pign/cui
```

## Create a Project

```bash
haxelib run mui init MyApp
cd MyApp
```

This creates:
- `src/MyApp.hx` -- your app with a counter template
- `build-sui.hxml` / `build-wui.hxml` / `build-cui.hxml` -- build files for each backend
- `mui.json` -- project metadata

## Build and Run

```bash
# Terminal (fastest for development)
haxelib run mui build cui
haxelib run mui run cui

# macOS/iOS
haxelib run mui build sui

# Windows
haxelib run mui build wui
```

## Project Structure

A typical mui project:

```
myapp/
  src/
    MyApp.hx          -- your main app class
    MyComponent.hx     -- reusable components
  build-sui.hxml       -- SwiftUI build config
  build-wui.hxml       -- WinUI build config
  build-cui.hxml       -- TUI build config
  mui.json             -- project metadata
```

## Your First App

```haxe
import mui.App;
import mui.View;
import mui.ui.Text;
import mui.ui.VStack;
import mui.ui.Button;

class MyApp extends App {
    @:state var greeting:String = "Hello!";

    public function new() {
        super();
        appTitle = "My First App";
    }

    override function body():View {
        return new VStack([
            new Text(greeting.get()),
            new Button("Change", function() greeting.set("Hi there!")),
        ], 10);
    }

    static function main() {
        #if (mui_backend == "cui")
        new MyApp().run();
        #end
    }
}
```

## Next Steps

- [UI Components](ui/README.md) -- layout, text, controls
- [State Management](state/README.md) -- reactive state with `@:state`
- [Examples](examples/README.md) -- counter, form, todo, dashboard
