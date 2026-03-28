# Controls

## Button

A clickable button with a label and action.

```haxe
new Button("Click me", function() {
    count.set(count.get() + 1);
})
```

**Constructor**: `Button(label:String, ?action:()->Void)`

All backends are normalized to accept closures. On backends that natively use `StateAction` (sui, wui), the closure is wrapped appropriately.

## Toggle

A boolean switch (toggle on sui/wui, checkbox on cui).

```haxe
@:state var darkMode:Bool = false;

new Toggle("Dark Mode", darkMode)
```

**Constructor**: `Toggle(label:String, state:ToggleBinding)`

Accepts a `@:state Bool` field directly. The `ToggleBinding` abstract handles backend conversion via `@:from`:

- **sui**: extracts the state name string for Swift code generation
- **wui**: passes the State object as a Dynamic binding
- **cui**: creates a `CheckboxBinding` from the `BoolState`

## ProgressView

A progress indicator.

```haxe
new ProgressView("Loading...", 0.75)  // 75% progress
new ProgressView()                     // indeterminate
```

**Constructor**: `ProgressView(?label:String, ?value:Float)`

Maps to `ProgressView` (sui), `ProgressRing` (wui), `ProgressBar` (cui).

## Image

Displays an image (not available on cui).

```haxe
new Image("photo.png")
```

**Constructor**: `Image(source:String)`

Guard with `#if (mui_backend != "cui")` when used in cross-platform code.
