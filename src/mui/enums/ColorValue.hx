package mui.enums;

enum ColorValueKind {
    // Semantic
    Primary;
    Secondary;
    Accent;

    // Named
    Red;
    Orange;
    Yellow;
    Green;
    Blue;
    Purple;
    Pink;
    White;
    Black;
    Gray;
    Clear;

    // Custom
    Rgb(r:Int, g:Int, b:Int);
    Hex(hex:String);
}

abstract ColorValue(ColorValueKind) from ColorValueKind to ColorValueKind {
    public inline function new(v:ColorValueKind) {
        this = v;
    }

    // Convenience constructors matching enum cases
    public static inline var Primary = new ColorValue(ColorValueKind.Primary);
    public static inline var Secondary = new ColorValue(ColorValueKind.Secondary);
    public static inline var Accent = new ColorValue(ColorValueKind.Accent);
    public static inline var Red = new ColorValue(ColorValueKind.Red);
    public static inline var Orange = new ColorValue(ColorValueKind.Orange);
    public static inline var Yellow = new ColorValue(ColorValueKind.Yellow);
    public static inline var Green = new ColorValue(ColorValueKind.Green);
    public static inline var Blue = new ColorValue(ColorValueKind.Blue);
    public static inline var Purple = new ColorValue(ColorValueKind.Purple);
    public static inline var Pink = new ColorValue(ColorValueKind.Pink);
    public static inline var White = new ColorValue(ColorValueKind.White);
    public static inline var Black = new ColorValue(ColorValueKind.Black);
    public static inline var Gray = new ColorValue(ColorValueKind.Gray);
    public static inline var Clear = new ColorValue(ColorValueKind.Clear);

    public static inline function rgb(r:Int, g:Int, b:Int):ColorValue {
        return new ColorValue(ColorValueKind.Rgb(r, g, b));
    }

    public static inline function hex(h:String):ColorValue {
        return new ColorValue(ColorValueKind.Hex(h));
    }

    #if (mui_backend == "sui")
    public function toBackend():sui.View.ColorValue {
        return switch (cast this : ColorValueKind) {
            case Primary: sui.View.ColorValue.Primary;
            case Secondary: sui.View.ColorValue.Secondary;
            case Accent: sui.View.ColorValue.Accent;
            case Red: sui.View.ColorValue.Red;
            case Orange: sui.View.ColorValue.Orange;
            case Yellow: sui.View.ColorValue.Yellow;
            case Green: sui.View.ColorValue.Green;
            case Blue: sui.View.ColorValue.Blue;
            case Purple: sui.View.ColorValue.Purple;
            case Pink: sui.View.ColorValue.Pink;
            case White: sui.View.ColorValue.White;
            case Black: sui.View.ColorValue.Black;
            case Gray: sui.View.ColorValue.Gray;
            case Clear: sui.View.ColorValue.Clear;
            case Rgb(r, g, b): sui.View.ColorValue.Custom('#${StringTools.hex(r, 2)}${StringTools.hex(g, 2)}${StringTools.hex(b, 2)}');
            case Hex(h): sui.View.ColorValue.Custom(h);
        };
    }
    #elseif (mui_backend == "wui")
    public function toBackend():wui.modifiers.ViewModifier.ColorValue {
        return switch (cast this : ColorValueKind) {
            case Primary | Secondary: wui.modifiers.ViewModifier.ColorValue.White;
            case Accent: wui.modifiers.ViewModifier.ColorValue.AccentColor;
            case Red: wui.modifiers.ViewModifier.ColorValue.Red;
            case Orange: wui.modifiers.ViewModifier.ColorValue.Orange;
            case Yellow: wui.modifiers.ViewModifier.ColorValue.Yellow;
            case Green: wui.modifiers.ViewModifier.ColorValue.Green;
            case Blue: wui.modifiers.ViewModifier.ColorValue.Blue;
            case Purple: wui.modifiers.ViewModifier.ColorValue.Purple;
            case Pink: wui.modifiers.ViewModifier.ColorValue.Red;
            case White: wui.modifiers.ViewModifier.ColorValue.White;
            case Black: wui.modifiers.ViewModifier.ColorValue.Black;
            case Gray: wui.modifiers.ViewModifier.ColorValue.Gray;
            case Clear: wui.modifiers.ViewModifier.ColorValue.Transparent;
            case Rgb(r, g, b): wui.modifiers.ViewModifier.ColorValue.Rgb(r, g, b);
            case Hex(h): wui.modifiers.ViewModifier.ColorValue.Hex(h);
        };
    }
    #elseif (mui_backend == "cui")
    public function toBackend():cui.render.Color {
        return switch (cast this : ColorValueKind) {
            case Red: cui.render.Color.Named(cui.render.Color.NamedColor.Red);
            case Orange | Yellow: cui.render.Color.Named(cui.render.Color.NamedColor.Yellow);
            case Green: cui.render.Color.Named(cui.render.Color.NamedColor.Green);
            case Blue: cui.render.Color.Named(cui.render.Color.NamedColor.Blue);
            case Purple | Pink: cui.render.Color.Named(cui.render.Color.NamedColor.Magenta);
            case White: cui.render.Color.Named(cui.render.Color.NamedColor.White);
            case Black: cui.render.Color.Named(cui.render.Color.NamedColor.Black);
            case Gray: cui.render.Color.Named(cui.render.Color.NamedColor.BrightBlack);
            case Rgb(r, g, b): cui.render.Color.Rgb(r, g, b);
            case Hex(h): hexToRgb(h);
            case Primary | Secondary | Accent | Clear: cui.render.Color.Default;
        };
    }

    private static function hexToRgb(h:String):cui.render.Color {
        var s = StringTools.startsWith(h, "#") ? h.substr(1) : h;
        var r = Std.parseInt("0x" + s.substr(0, 2));
        var g = Std.parseInt("0x" + s.substr(2, 2));
        var b = Std.parseInt("0x" + s.substr(4, 2));
        return cui.render.Color.Rgb(r != null ? r : 0, g != null ? g : 0, b != null ? b : 0);
    }
    #elseif (mui_backend == "aui")
    public function toBackend():aui.modifiers.ViewModifier.ColorValue {
        return switch (cast this : ColorValueKind) {
            case Primary: aui.modifiers.ViewModifier.ColorValue.Primary;
            case Secondary: aui.modifiers.ViewModifier.ColorValue.Secondary;
            case Accent: aui.modifiers.ViewModifier.ColorValue.Accent;
            case Red: aui.modifiers.ViewModifier.ColorValue.Red;
            case Orange: aui.modifiers.ViewModifier.ColorValue.Orange;
            case Yellow: aui.modifiers.ViewModifier.ColorValue.Yellow;
            case Green: aui.modifiers.ViewModifier.ColorValue.Green;
            case Blue: aui.modifiers.ViewModifier.ColorValue.Blue;
            case Purple: aui.modifiers.ViewModifier.ColorValue.Purple;
            case Pink: aui.modifiers.ViewModifier.ColorValue.Pink;
            case White: aui.modifiers.ViewModifier.ColorValue.White;
            case Black: aui.modifiers.ViewModifier.ColorValue.Black;
            case Gray: aui.modifiers.ViewModifier.ColorValue.Gray;
            case Clear: aui.modifiers.ViewModifier.ColorValue.Transparent;
            case Rgb(r, g, b): aui.modifiers.ViewModifier.ColorValue.Custom('#${StringTools.hex(r, 2)}${StringTools.hex(g, 2)}${StringTools.hex(b, 2)}');
            case Hex(h): aui.modifiers.ViewModifier.ColorValue.Custom(h);
        };
    }
    #end
}
