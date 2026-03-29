package mui.ui;

import mui.ui.SliderBinding;

// Unified Slider.
// User writes: new Slider(progress, 0.0, 1.0)
// The SliderBinding abstract handles conversion via @:from.
//
// On cui: Slider is not available (terminal has no slider widget).
// Guard with #if (mui_backend != "cui") when used in cross-platform code.

#if (mui_backend == "sui")
@:swiftView("Slider")
class Slider extends sui.ui.Slider {
    public function new(@:swiftBinding state:SliderBinding, min:Float = 0.0, max:Float = 1.0) {
        super(state.unwrap(), min, max);
    }
}
#elseif (mui_backend == "wui")
class Slider extends wui.ui.Slider {
    public function new(state:SliderBinding, min:Float = 0.0, max:Float = 1.0) {
        super(min, max, state.unwrap());
    }
}
#elseif (mui_backend == "aui")
class Slider extends aui.ui.Slider {
    public function new(state:SliderBinding, min:Float = 0.0, max:Float = 1.0) {
        super(state.unwrap(), min, max);
    }
}
#elseif (mui_backend == "cui")
#error "mui.ui.Slider is not available on the cui (terminal) backend. Use #if (mui_backend != \"cui\") to guard Slider usage."
#else
#error "mui requires -D mui_backend=sui|wui|cui|aui"
#end
