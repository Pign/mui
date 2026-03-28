# Examples

mui includes 5 example apps that compile to all three backends. Each demonstrates different features of the unified API.

| Example | Features | `#if` blocks |
|---------|----------|-------------|
| [Counter](examples/counter.md) | State, buttons, layout | 1 (main) |
| [Form](examples/form.md) | TextInput, Toggle, Divider | 1 (main) |
| [Todo](examples/todo.md) | ForEach macro, dynamic lists | 1 (main) |
| [Settings](examples/settings.md) | Toggle, Divider, appTitle | 1 (main) |
| [Dashboard](examples/dashboard.md) | ProgressView, helper functions | 1 (main) |

## Building Examples

Each example directory has `build-sui.hxml`, `build-wui.hxml`, and `build-cui.hxml`:

```bash
cd examples/counter
haxe build-cui.hxml
./build/cui/Counter
```
