package mui.ui;

// Text input binding mechanisms differ across backends:
//   sui: TextField(placeholder, textBinding:String) -- string name for Swift codegen
//   wui: TextBox(?placeholder, ?binding:Dynamic)
//   cui: Input(binding:Binding<String>, placeholder)

#if (mui_backend == "sui")
class TextInput extends sui.ui.TextField {
    public function new(placeholder:String, textBinding:String) {
        super(placeholder, textBinding);
    }
}
#elseif (mui_backend == "wui")
class TextInput extends wui.ui.TextBox {
    public function new(?placeholder:String, ?binding:Dynamic) {
        super(placeholder, binding);
    }
}
#elseif (mui_backend == "cui")
class TextInput extends cui.ui.Input {
    public function new(binding:cui.state.Binding<String>, placeholder:String = "") {
        super(binding, placeholder);
    }
}
#else
#error "mui requires -D mui_backend=sui|wui|cui"
#end
