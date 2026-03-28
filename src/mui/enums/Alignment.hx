package mui.enums;

enum HorizontalAlignmentKind {
    Leading;
    Center;
    Trailing;
}

abstract HorizontalAlignment(HorizontalAlignmentKind) from HorizontalAlignmentKind to HorizontalAlignmentKind {
    public inline function new(v:HorizontalAlignmentKind) {
        this = v;
    }

    public static inline var Leading = new HorizontalAlignment(HorizontalAlignmentKind.Leading);
    public static inline var Center = new HorizontalAlignment(HorizontalAlignmentKind.Center);
    public static inline var Trailing = new HorizontalAlignment(HorizontalAlignmentKind.Trailing);

    #if (mui_backend == "sui")
    public function toBackend():sui.ui.VStack.HorizontalAlignment {
        return switch (cast this : HorizontalAlignmentKind) {
            case Leading: sui.ui.VStack.HorizontalAlignment.Leading;
            case Center: sui.ui.VStack.HorizontalAlignment.Center;
            case Trailing: sui.ui.VStack.HorizontalAlignment.Trailing;
        };
    }
    #elseif (mui_backend == "wui")
    public function toBackend():wui.modifiers.ViewModifier.HorizontalAlign {
        return switch (cast this : HorizontalAlignmentKind) {
            case Leading: wui.modifiers.ViewModifier.HorizontalAlign.Left;
            case Center: wui.modifiers.ViewModifier.HorizontalAlign.Center;
            case Trailing: wui.modifiers.ViewModifier.HorizontalAlign.Right;
        };
    }
    #elseif (mui_backend == "aui")
    public function toBackend():aui.ui.VStack.HorizontalAlignment {
        return switch (cast this : HorizontalAlignmentKind) {
            case Leading: aui.ui.VStack.HorizontalAlignment.Start;
            case Center: aui.ui.VStack.HorizontalAlignment.Center;
            case Trailing: aui.ui.VStack.HorizontalAlignment.End;
        };
    }
    #end
}

enum VerticalAlignmentKind {
    Top;
    Center;
    Bottom;
}

abstract VerticalAlignment(VerticalAlignmentKind) from VerticalAlignmentKind to VerticalAlignmentKind {
    public inline function new(v:VerticalAlignmentKind) {
        this = v;
    }

    public static inline var Top = new VerticalAlignment(VerticalAlignmentKind.Top);
    public static inline var Center = new VerticalAlignment(VerticalAlignmentKind.Center);
    public static inline var Bottom = new VerticalAlignment(VerticalAlignmentKind.Bottom);

    #if (mui_backend == "sui")
    public function toBackend():sui.ui.HStack.VerticalAlignment {
        return switch (cast this : VerticalAlignmentKind) {
            case Top: sui.ui.HStack.VerticalAlignment.Top;
            case Center: sui.ui.HStack.VerticalAlignment.Center;
            case Bottom: sui.ui.HStack.VerticalAlignment.Bottom;
        };
    }
    #elseif (mui_backend == "wui")
    public function toBackend():wui.modifiers.ViewModifier.VerticalAlign {
        return switch (cast this : VerticalAlignmentKind) {
            case Top: wui.modifiers.ViewModifier.VerticalAlign.Top;
            case Center: wui.modifiers.ViewModifier.VerticalAlign.Center;
            case Bottom: wui.modifiers.ViewModifier.VerticalAlign.Bottom;
        };
    }
    #elseif (mui_backend == "aui")
    public function toBackend():aui.ui.HStack.VerticalAlignment {
        return switch (cast this : VerticalAlignmentKind) {
            case Top: aui.ui.HStack.VerticalAlignment.Top;
            case Center: aui.ui.HStack.VerticalAlignment.Center;
            case Bottom: aui.ui.HStack.VerticalAlignment.Bottom;
        };
    }
    #end
}
