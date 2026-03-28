# UI Components

mui provides unified UI components that work across all backends. Each component normalizes constructor signatures so you write the same code regardless of backend.

## Component Matrix

| Component | Constructor | sui | wui | cui |
|-----------|------------|-----|-----|-----|
| [Text](ui/text-and-input.md) | `Text(content)` | Text | Text | Text |
| [VStack](ui/layout.md) | `VStack(children, ?spacing)` | VStack | StackPanel | VStack |
| [HStack](ui/layout.md) | `HStack(children, ?spacing)` | HStack | StackPanel | HStack |
| [Button](ui/controls.md) | `Button(label, ?action)` | Button | Button | Button |
| [Toggle](ui/controls.md) | `Toggle(label, state)` | Toggle | ToggleSwitch | Checkbox |
| [TextInput](ui/text-and-input.md) | `TextInput(placeholder, state)` | TextField | TextBox | Input |
| [ForEach](ui/lists-and-iteration.md) | `ForEach.build(items, builder)` | ForEach | ForEach | ForEach |
| [Spacer](ui/layout.md) | `Spacer()` | Spacer | Spacer | Spacer |
| [Divider](ui/layout.md) | `Divider()` | Divider | Border | Divider |
| [ProgressView](ui/controls.md) | `ProgressView(?label, ?value)` | ProgressView | ProgressRing | ProgressBar |
| [Image](ui/controls.md) | `Image(source)` | Image | Image | N/A |

## Backend-Specific Components

Some components have irreconcilable APIs and are exposed as direct typedefs. Use `#if` blocks when using these:

- **ListView** -- different constructor per backend
- **ScrollView** -- cui requires scroll offset binding
- **TabView** -- cui requires active tab binding
