package mui.ui;

/**
    Cross-platform ForEach. Uses a compile-time macro to transform
    a builder closure into the correct backend-specific ForEach.

    Usage:
        ForEach.build(todos, item -> new Text(item))
        ForEach.build(todos, item -> new HStack([
            new Text(item.title),
            new Spacer(),
        ]))

    On SUI: transforms to sui.ui.ForEach with string templates for Swift codegen.
    On CUI: transforms to cui.ui.ForEach with runtime builder closure.
    On WUI: transforms to wui.ui.ForEach with runtime builder closure.
**/
class ForEach {
    public static macro function build(items:haxe.macro.Expr, builder:haxe.macro.Expr):haxe.macro.Expr {
        return mui.macros.ForEachMacro.transform(items, builder);
    }
}
