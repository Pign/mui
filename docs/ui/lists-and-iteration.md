# Lists & Iteration

## ForEach

`ForEach.build()` is a compile-time macro that lets you iterate over a state array with a builder function, producing the correct code for each backend.

### Basic usage

```haxe
@:state var items:Array<String> = [];

ForEach.build(items, function(item) {
    return new Text(item);
})
```

### With object fields

```haxe
ForEach.build(todos, function(item) {
    return new HStack([
        new Text(item.title),
        new Spacer(),
    ]);
})
```

### How it works

The macro inspects `Context.definedValue("mui_backend")` and transforms the call:

**SUI path**: Walks the builder body AST. Replaces references to the item parameter with string templates (e.g., `item.title` becomes `{todos[_i].title}`). Converts `new Text(item)` to `Text.withState("{todos[_i]}")`. Outputs `new sui.ui.ForEach(todos, "_i", transformedView)` — sui natively accepts typed state field references.

**CUI path**: Outputs `new cui.ui.ForEach(items.get(), builder)` -- the closure runs at runtime.

**WUI path**: Outputs `new wui.ui.ForEach(items, builder)` -- same runtime approach.

### Supported patterns

The macro handles these item reference patterns in the builder body:

| Pattern | SUI template | CUI/WUI |
|---------|-------------|---------|
| `item` | `{items[_i]}` | direct reference |
| `item.field` | `{items[_i].field}` | direct field access |
| `new Text(item)` | `Text.withState(...)` | `new Text(item)` |
| `new Text(item.field)` | `Text.withState(...)` | `new Text(item.field)` |

Expressions that don't reference the item parameter pass through unchanged on all backends.

### Limitations

- On SUI, only item references in `Text` constructors are converted to templates. Complex expressions (string concatenation, method calls on the item) may need `#if` blocks.
- Actions (delete buttons, toggles) within ForEach items typically need backend-specific code since SUI uses `StateAction.CustomSwift` while CUI/WUI use closures.

## ListView

ListView has different constructors per backend and is exposed as a direct typedef. Use `#if` blocks:

```haxe
#if (mui_backend == "sui")
new sui.ui.List(contentViews)
#elseif (mui_backend == "wui")
new wui.ui.ListView(items, template)
#elseif (mui_backend == "cui")
new cui.ui.ListView(items, selection, onSelect, onDelete)
#end
```

## ScrollView

ScrollView is also backend-specific:

```haxe
#if (mui_backend == "sui")
new sui.ui.ScrollView(contentArray)
#elseif (mui_backend == "wui")
new wui.ui.ScrollViewer(contentView)
#elseif (mui_backend == "cui")
new cui.ui.ScrollView(child, scrollOffset)
#end
```
