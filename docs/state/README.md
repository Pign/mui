# State Management

mui uses the backend's reactive state system. Declare state with `@:state` and the UI re-renders automatically when values change.

## Declaring State

```haxe
class MyApp extends App {
    @:state var count:Int = 0;
    @:state var name:String = "";
    @:state var active:Bool = false;
}
```

The `@:state` macro (inherited from the backend's `App` class) transforms fields into reactive `State<T>` wrappers at compile time.

## Reading and Writing

All backends support both `.get()`/`.set()` and `.value`:

```haxe
// Read
var c = count.get();
var c = count.value;      // equivalent

// Write
count.set(5);
count.value = 5;          // equivalent
```

Use whichever style you prefer. Both work on all backends.

## State in UI

```haxe
override function body():View {
    return new VStack([
        new Text('Count: ${count.get()}'),
        new Button("Increment", function() count.set(count.get() + 1)),
    ]);
}
```

## State in Bindings

Toggle and TextInput accept `@:state` fields directly:

```haxe
@:state var darkMode:Bool = false;
@:state var username:String = "";

new Toggle("Dark Mode", darkMode),      // auto-converted via ToggleBinding
new TextInput("Username", username),     // auto-converted via TextInputBinding
```

See [Bindings](state/bindings.md) for details.

## Backend-Specific Methods

Some methods are only available on certain backends:

| Method | sui | wui | cui | Description |
|--------|-----|-----|-----|-------------|
| `.get()` | Yes | Yes | Yes | Read value |
| `.set(v)` | Yes | Yes | Yes | Write value |
| `.value` | Yes | Yes | Yes | Read/write property |
| `.inc(n)` | Yes | Yes | Yes* | Increment (returns StateAction on sui/wui) |
| `.dec(n)` | Yes | Yes | Yes* | Decrement (returns StateAction on sui/wui) |
| `.tog()` | Yes | Yes | -- | Toggle boolean (returns StateAction) |
| `.toggle()` | -- | -- | Yes | Toggle boolean (void, cui only) |
| `.subscribe()` | -- | Yes | -- | Register change listener |

*cui `IntState`/`FloatState` have `.inc()`/`.dec()` that mutate directly (void return).
