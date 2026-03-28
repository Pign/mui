# Enums

mui provides unified color, font, and alignment enums that map to each backend's native types via `.toBackend()`.

## ColorValue

```haxe
import mui.enums.ColorValue;

view.foregroundColor(ColorValue.Red.toBackend());
view.background(ColorValue.Accent.toBackend());
view.foregroundColor(ColorValue.rgb(66, 133, 244).toBackend());
```

### Semantic Colors

| Value | sui | wui | cui |
|-------|-----|-----|-----|
| `Primary` | Primary | White | Default |
| `Secondary` | Secondary | White | Default |
| `Accent` | Accent | AccentColor | Default |
| `Clear` | Clear | Transparent | Default |

### Named Colors

`Red`, `Orange`, `Yellow`, `Green`, `Blue`, `Purple`, `Pink`, `White`, `Black`, `Gray`

### Custom Colors

- `ColorValue.rgb(r, g, b)` -- RGB values (0-255)
- `ColorValue.hex("#RRGGBB")` -- hex string

## FontStyle

```haxe
import mui.enums.FontStyle;

view.font(FontStyle.Title.toBackend());
```

| Value | sui | wui | cui |
|-------|-----|-----|-----|
| `LargeTitle` | LargeTitle | Display | bold |
| `Title` | Title | Title | bold |
| `Headline` | Headline | Subtitle | bold |
| `Body` | Body | Body | normal |
| `Caption` | Caption | Caption | dim |

On cui, which has no font system, `FontStyle` provides `.isBold()` and `.isDim()` helpers.

## Alignment

```haxe
import mui.enums.Alignment;

// HorizontalAlignment: Leading, Center, Trailing
// VerticalAlignment: Top, Center, Bottom
```

These map to each backend's alignment system (e.g., `Leading` maps to `Left` on wui).
