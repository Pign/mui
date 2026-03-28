package mui.enums;

enum FontStyleKind {
    LargeTitle;
    Title;
    Headline;
    Body;
    Caption;
    Custom(name:String, size:Float);
}

abstract FontStyle(FontStyleKind) from FontStyleKind to FontStyleKind {
    public inline function new(v:FontStyleKind) {
        this = v;
    }

    public static inline var LargeTitle = new FontStyle(FontStyleKind.LargeTitle);
    public static inline var Title = new FontStyle(FontStyleKind.Title);
    public static inline var Headline = new FontStyle(FontStyleKind.Headline);
    public static inline var Body = new FontStyle(FontStyleKind.Body);
    public static inline var Caption = new FontStyle(FontStyleKind.Caption);

    public static inline function custom(name:String, size:Float):FontStyle {
        return new FontStyle(FontStyleKind.Custom(name, size));
    }

    #if (mui_backend == "sui")
    public function toBackend():sui.View.FontStyle {
        return switch (cast this : FontStyleKind) {
            case LargeTitle: sui.View.FontStyle.LargeTitle;
            case Title: sui.View.FontStyle.Title;
            case Headline: sui.View.FontStyle.Headline;
            case Body: sui.View.FontStyle.Body;
            case Caption: sui.View.FontStyle.Caption;
            case Custom(name, size): sui.View.FontStyle.Custom(name, size);
        };
    }
    #elseif (mui_backend == "wui")
    public function toBackend():wui.modifiers.ViewModifier.FontStyle {
        return switch (cast this : FontStyleKind) {
            case LargeTitle: wui.modifiers.ViewModifier.FontStyle.Display;
            case Title: wui.modifiers.ViewModifier.FontStyle.Title;
            case Headline: wui.modifiers.ViewModifier.FontStyle.Subtitle;
            case Body: wui.modifiers.ViewModifier.FontStyle.Body;
            case Caption: wui.modifiers.ViewModifier.FontStyle.Caption;
            case Custom(_, _): wui.modifiers.ViewModifier.FontStyle.Body;
        };
    }
    #elseif (mui_backend == "cui")
    // cui has no font system -- font style is a no-op.
    // Users can check isBold() to apply .bold() manually if desired.
    public function isBold():Bool {
        return switch (cast this : FontStyleKind) {
            case LargeTitle | Title | Headline: true;
            default: false;
        };
    }

    public function isDim():Bool {
        return switch (cast this : FontStyleKind) {
            case Caption: true;
            default: false;
        };
    }
    #elseif (mui_backend == "aui")
    public function toBackend():aui.modifiers.ViewModifier.FontStyle {
        return switch (cast this : FontStyleKind) {
            case LargeTitle: aui.modifiers.ViewModifier.FontStyle.DisplayLarge;
            case Title: aui.modifiers.ViewModifier.FontStyle.TitleLarge;
            case Headline: aui.modifiers.ViewModifier.FontStyle.HeadlineMedium;
            case Body: aui.modifiers.ViewModifier.FontStyle.BodyMedium;
            case Caption: aui.modifiers.ViewModifier.FontStyle.LabelSmall;
            case Custom(name, size): aui.modifiers.ViewModifier.FontStyle.CustomFont(name, size);
        };
    }
    #end
}
