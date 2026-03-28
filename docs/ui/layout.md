# Layout

## VStack

Arranges children vertically with optional spacing.

```haxe
new VStack([
    new Text("First"),
    new Text("Second"),
    new Text("Third"),
], 10)  // 10px spacing
```

**Constructor**: `VStack(content:Array<View>, ?spacing:Float)`

Internally, VStack normalizes the backend differences:
- sui: `VStack(?alignment, ?spacing, content)` -- reordered
- wui: `VStack(children, ?spacing)` -- matches
- cui: `VStack(children, spacing:Int)` -- Float-to-Int conversion

## HStack

Arranges children horizontally with optional spacing.

```haxe
new HStack([
    new Button("Cancel", onCancel),
    new Spacer(),
    new Button("OK", onOk),
], 8)
```

**Constructor**: `HStack(content:Array<View>, ?spacing:Float)`

## Spacer

Flexible space that fills available room.

```haxe
new VStack([
    new Text("Top"),
    new Spacer(),
    new Text("Bottom"),
])
```

**Constructor**: `Spacer()`

## Divider

A horizontal separator line.

```haxe
new VStack([
    new Text("Section 1"),
    new Divider(),
    new Text("Section 2"),
])
```

**Constructor**: `Divider()`

Maps to SwiftUI `Divider`, a styled `Border` on WinUI, and a terminal line on cui.
