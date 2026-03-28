# UI Components

mui provides unified UI components that work across all backends. Each component normalizes constructor signatures so you write the same code regardless of backend.

## Component Matrix

| Component | Constructor | sui | wui | aui | cui |
|-----------|------------|-----|-----|-----|-----|
| [Text](ui/text-and-input.md) | `Text(content)` | Text | Text | Text | Text |
| [VStack](ui/layout.md) | `VStack(children, ?spacing)` | VStack | StackPanel | Column | VStack |
| [HStack](ui/layout.md) | `HStack(children, ?spacing)` | HStack | StackPanel | Row | HStack |
| [Button](ui/controls.md) | `Button(label, ?action)` | Button | Button | Button | Button |
| [Toggle](ui/controls.md) | `Toggle(label, state)` | Toggle | ToggleSwitch | Switch | Checkbox |
| [TextInput](ui/text-and-input.md) | `TextInput(placeholder, state)` | TextField | TextBox | TextField | Input |
| [ForEach](ui/lists-and-iteration.md) | `ForEach.build(items, builder)` | ForEach | ForEach | ForEach | ForEach |
| [Spacer](ui/layout.md) | `Spacer()` | Spacer | Spacer | Spacer | Spacer |
| [Divider](ui/layout.md) | `Divider()` | Divider | Border | HorizontalDivider | Divider |
| [ProgressView](ui/controls.md) | `ProgressView(?label, ?value)` | ProgressView | ProgressRing | ProgressView | ProgressBar |
| [SafeArea](ui/layout.md) | `SafeArea(children)` | no-op | no-op | safeDrawingPadding | no-op |
| [Image](ui/controls.md) | `Image(source)` | Image | Image | Image | N/A |

## Backend-Specific Components

Some components have irreconcilable APIs and are exposed as direct typedefs. Use `#if` blocks when using these:

- **ListView** -- different constructor per backend
- **ScrollView** -- cui requires scroll offset binding
- **TabView** -- cui requires active tab binding
