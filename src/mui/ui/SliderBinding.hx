package mui.ui;

/**
    Type-safe binding for Slider. Accepts a backend @:state Float field
    and converts to the backend's native binding type via @:from.

    Usage: new Slider(progress, 0.0, 1.0)
**/
#if (mui_backend == "sui")
abstract SliderBinding(String) {
    public inline function new(v:String) this = v;

    @:from static inline function fromState(s:sui.state.State<Float>):SliderBinding
        return new SliderBinding(s.name);

    public inline function unwrap():String return this;
}
#elseif (mui_backend == "wui")
abstract SliderBinding(wui.state.State<Float>) {
    public inline function new(v:wui.state.State<Float>) this = v;

    @:from static inline function fromState(s:wui.state.State<Float>):SliderBinding
        return new SliderBinding(s);

    public inline function unwrap():wui.state.State<Float> return this;
}
#elseif (mui_backend == "aui")
abstract SliderBinding(aui.state.State<Float>) {
    public inline function new(v:aui.state.State<Float>) this = v;

    @:from static inline function fromState(s:aui.state.State<Float>):SliderBinding
        return new SliderBinding(s);

    public inline function unwrap():aui.state.State<Float> return this;
}
#elseif (mui_backend == "cui")
// cui has no Slider — binding provided for API compatibility
abstract SliderBinding(cui.state.Binding<Float>) {
    public inline function new(v:cui.state.Binding<Float>) this = v;

    @:from static inline function fromState(s:cui.state.State<Float>):SliderBinding
        return new SliderBinding(cui.state.Binding.from(s));

    public inline function unwrap():cui.state.Binding<Float> return this;
}
#else
#error "mui requires -D mui_backend=sui|wui|cui|aui"
#end
