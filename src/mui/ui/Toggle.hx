package mui.ui;

// Toggle/Checkbox binding mechanisms differ fundamentally across backends:
//   sui: string name of a @:state Bool var (for Swift codegen)
//   wui: Dynamic binding
//   cui: CheckboxBinding object
//
// The constructor accepts the backend-specific binding type.
// Use #if (mui_backend == "xxx") around the binding argument at call sites
// for cross-backend code, or use the common closure-based approach.

#if (mui_backend == "sui")
class Toggle extends sui.ui.Toggle {
    public function new(label:String, isOnBinding:String) {
        super(label, isOnBinding);
    }
}
#elseif (mui_backend == "wui")
class Toggle extends wui.ui.ToggleSwitch {
    public function new(?label:String, ?binding:Dynamic) {
        super(label, binding);
    }
}
#elseif (mui_backend == "cui")
class Toggle extends cui.ui.Checkbox {
    public function new(label:String, binding:cui.ui.Checkbox.CheckboxBinding) {
        super(label, binding);
    }
}
#else
#error "mui requires -D mui_backend=sui|wui|cui"
#end
