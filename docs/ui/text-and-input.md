# Text & Input

## Text

Displays read-only text.

```haxe
new Text("Hello, world!")
new Text('Count: ${count.get()}')  // string interpolation
```

**Constructor**: `Text(content:String)`

## TextInput

A text input field with a placeholder and state binding.

```haxe
@:state var name:String = "";

new TextInput("Enter your name", name)
```

**Constructor**: `TextInput(placeholder:String, state:TextInputBinding)`

The second argument accepts a `@:state String` field directly. The `TextInputBinding` abstract handles the backend conversion automatically via `@:from`:

- **sui**: extracts the state name for Swift code generation
- **wui**: passes the State object as a binding
- **cui**: wraps in a `Binding<String>` for two-way data flow

No `#if` blocks needed.
