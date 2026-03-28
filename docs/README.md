# mui

**mui** is a cross-platform UI abstraction layer for Haxe. It wraps four backend libraries under a single API:

| Backend | Platform | Library |
|---------|----------|---------|
| `sui` | macOS, iOS, visionOS (SwiftUI) | [Pign/sui](https://github.com/Pign/sui) |
| `wui` | Windows (WinUI 3) | [Pign/wui](https://github.com/Pign/wui) |
| `aui` | Android (Jetpack Compose) | [Pign/aui](https://github.com/Pign/aui) |
| `cui` | Terminal (TUI) | [Pign/cui](https://github.com/Pign/cui) |

You write your app once and compile to any backend by setting a `-D mui_backend` flag. All mui types compile down to backend types with zero runtime overhead.

## Minimal Example

```haxe
import mui.App;
import mui.View;
import mui.ui.*;

class Counter extends App {
    @:state var count:Int = 0;

    override function body():View {
        return new VStack([
            new Text('Count: ${count.get()}'),
            new HStack([
                new Button("-", function() count.set(count.get() - 1)),
                new Button("+", function() count.set(count.get() + 1)),
            ], 8),
        ], 10);
    }

    static function main() {
        #if (mui_backend == "cui")
        new Counter().run();
        #end
    }
}
```

No `#if` blocks in the UI code itself. The only conditional is the `main()` entry point for the terminal backend.

## How It Works

mui uses several Haxe techniques to abstract away backend differences:

- **Typedefs** for types with identical APIs (View, State, Binding)
- **Subclasses** to normalize constructor signatures (VStack, HStack, Button)
- **Abstract types with `@:from`** for type-safe binding conversion (Toggle, TextInput)
- **Compile-time macros** to transform code per backend (ForEach)
- **Conditional compilation** only inside the library, not in user code
