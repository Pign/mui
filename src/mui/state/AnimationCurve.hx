package mui.state;

#if (mui_backend == "sui")
typedef AnimationCurve = sui.state.AnimationCurve;
#elseif (mui_backend == "wui")
// AnimationCurve is defined in the StateAction module in wui
typedef AnimationCurve = wui.state.StateAction.AnimationCurve;
#elseif (mui_backend == "cui")
// TUI has no animation system -- enum is provided for API compatibility
enum AnimationCurve {
    Default;
    EaseIn;
    EaseOut;
    EaseInOut;
    Spring;
    Linear;
    Bouncy;
}
#else
#error "mui requires -D mui_backend=sui|wui|cui"
#end
