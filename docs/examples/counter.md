# Counter

The simplest example: a counter with increment, decrement, and reset buttons.

```haxe
import mui.App;
import mui.View;
import mui.ui.Text;
import mui.ui.VStack;
import mui.ui.HStack;
import mui.ui.Button;
import mui.ui.Spacer;

class Counter extends App {
    @:state var count:Int = 0;

    override function body():View {
        return new VStack([
            new Spacer(),
            new Text("Counter"),
            new Text('Count: $count'),
            new HStack([
                new Button("-", function() count -= 1),
                new Button("Reset", function() count = 0),
                new Button("+", function() count += 1),
            ], 8),
            new Spacer(),
        ], 10);
    }

    static function main() {
        #if mui_owns_main
        new Counter().run();
        #end
    }
}
```

## What it demonstrates

- `@:state` reactive state declaration
- `count` reads and `count = …` writes: the same spelling on every backend
- `VStack` / `HStack` layout
- `Button` with closure actions
- Zero `#if` blocks in the UI code
