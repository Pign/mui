# Modifiers

Modifiers style and configure views via method chaining. Since mui components extend their backend's View class, all backend-native modifiers are available.

## Common Modifiers

These modifiers are available on all backends:

| Modifier | Description |
|----------|-------------|
| `.padding(?value)` | Add padding around the view |
| `.bold()` | Bold text |
| `.italic()` | Italic text |
| `.foregroundColor(color)` | Set text/foreground color |
| `.background(color)` | Set background color |
| `.opacity(value)` | Set opacity (0.0-1.0) |
| `.disabled(bool)` | Disable interaction |

```haxe
new Text("Hello")
    .bold()
    .padding()
```

## Color and Font Types

Modifier parameters use backend-specific types. Use `mui.enums.ColorValue` and `mui.enums.FontStyle` with `.toBackend()` for cross-platform code:

```haxe
import mui.enums.ColorValue;

new Text("Warning")
    .foregroundColor(ColorValue.Red.toBackend())
```

See [Enums](enums.md) for the full color and font mappings.

## Presentation Modifiers (sui)

On sui, presentation modifiers accept `@:state` field references directly — no string names needed:

```haxe
@:state var showSheet:Bool = false;

view.sheet(showSheet, sheetContent)
view.alert("Warning", showAlert, "message")
view.fullScreenCover(showModal, content)
view.popover(showPopover, content)
view.confirmationDialog("Confirm", showConfirm, content)
```

## View Helper Functions

All backends support extracting repeated UI patterns into functions that return `View`. On sui, the SwiftGenerator inlines these at compile time:

```haxe
function statusRow(label:String, value:Float):View {
    return new HStack([
        new Text(label),
        new ProgressView(null, value),
    ], 8);
}

override function body():View {
    return new VStack([
        statusRow("CPU", 0.73),
        statusRow("Memory", 0.45),
    ]);
}
```

Both instance methods and static methods on other classes are supported.

## Backend-Specific Modifiers

Use `#if` blocks for modifiers that only exist on one backend:

```haxe
var view = new Text("Hello");

#if (mui_backend == "sui")
view.navigationTitle("Page");
view.font(sui.View.FontStyle.Title);
#elseif (mui_backend == "wui")
view.font(wui.modifiers.ViewModifier.FontStyle.Title);
view.toolTip("Tooltip text");
#elseif (mui_backend == "cui")
view.border(cui.render.BorderStyle.Rounded);
view.underline();
#end
```
