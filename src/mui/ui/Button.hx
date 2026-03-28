package mui.ui;

// Unified constructor: (label:String, ?action:()->Void)
// Closures are the common denominator across all three backends.

#if (mui_backend == "sui")
class Button extends sui.ui.Button {
    public function new(label:String, ?action:() -> Void) {
        super(label, action);
    }
}
#elseif (mui_backend == "wui")
class Button extends wui.ui.Button {
    public function new(label:String, ?action:() -> Void) {
        super(label);
        if (action != null) {
            onClick(action);
        }
    }
}
#elseif (mui_backend == "cui")
class Button extends cui.ui.Button {
    public function new(label:String, ?action:() -> Void) {
        super(label, action != null ? action : function() {});
    }
}
#else
#error "mui requires -D mui_backend=sui|wui|cui"
#end
