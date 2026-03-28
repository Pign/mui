package mui.ui;

// Unified constructor: (content:Array<View>, ?spacing:Float)
// sui: (?alignment, ?spacing, content) -- reordered
// wui: (children, ?spacing)
// cui: (children, spacing:Int=0) -- Float->Int conversion

#if (mui_backend == "sui")
class VStack extends sui.ui.VStack {
    public function new(content:Array<sui.View>, ?spacing:Float) {
        super(null, spacing, content);
    }
}
#elseif (mui_backend == "wui")
class VStack extends wui.ui.VStack {
    public function new(content:Array<wui.View>, ?spacing:Float) {
        super(content, spacing);
    }
}
#elseif (mui_backend == "cui")
class VStack extends cui.ui.VStack {
    public function new(content:Array<cui.View>, ?spacing:Float) {
        super(content, spacing != null ? Std.int(spacing) : 0);
    }
}
#else
#error "mui requires -D mui_backend=sui|wui|cui"
#end
