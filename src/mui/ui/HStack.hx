package mui.ui;

// Unified constructor: (content:Array<View>, ?spacing:Float)

#if (mui_backend == "sui")
class HStack extends sui.ui.HStack {
    public function new(content:Array<sui.View>, ?spacing:Float) {
        super(null, spacing, content);
    }
}
#elseif (mui_backend == "wui")
class HStack extends wui.ui.HStack {
    public function new(content:Array<wui.View>, ?spacing:Float) {
        super(content, spacing);
    }
}
#elseif (mui_backend == "cui")
class HStack extends cui.ui.HStack {
    public function new(content:Array<cui.View>, ?spacing:Float) {
        super(content, spacing != null ? Std.int(spacing) : 0);
    }
}
#else
#error "mui requires -D mui_backend=sui|wui|cui"
#end
