# Bindings

## The Problem

Toggle and TextInput require different binding types per backend:

- **sui**: a string name of the `@:state` variable (for Swift code generation)
- **wui**: the `State<T>` object directly
- **cui**: a `CheckboxBinding` or `Binding<String>` wrapper

## The Solution: Abstract Types

mui provides `ToggleBinding` and `TextInputBinding` -- Haxe abstract types with `@:from` implicit conversions. When you pass a `@:state` field, Haxe automatically converts it to the correct backend type at compile time.

### ToggleBinding

```haxe
@:state var darkMode:Bool = false;

// This works on all backends:
new Toggle("Dark Mode", darkMode)
```

The `ToggleBinding` abstract wraps a different underlying type per backend:

| Backend | Underlying type | `@:from` conversion |
|---------|----------------|---------------------|
| sui | `String` | Extracts `state.name` |
| wui | `State<Bool>` | Passes through |
| cui | `CheckboxBinding` | Calls `CheckboxBinding.fromState()` |

### TextInputBinding

```haxe
@:state var email:String = "";

// This works on all backends:
new TextInput("Enter email", email)
```

| Backend | Underlying type | `@:from` conversion |
|---------|----------------|---------------------|
| sui | `String` | Extracts `state.name` |
| wui | `State<String>` | Passes through |
| cui | `Binding<String>` | Calls `Binding.from()` |

## How @:from Works

Haxe's `@:from` on abstract types enables implicit conversion at the call site. When the compiler sees:

```haxe
new Toggle("Dark Mode", darkMode)
```

It recognizes that `darkMode` (a `BoolState` on cui, `State<Bool>` on sui/wui) doesn't match `ToggleBinding`, so it looks for an `@:from` function that accepts the source type. The conversion runs at compile time with zero runtime overhead.
