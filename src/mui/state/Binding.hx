package mui.state;

#if (mui_backend == "sui")
typedef Binding<T> = sui.state.Binding<T>;
#elseif (mui_backend == "wui")
typedef Binding<T> = wui.state.Binding<T>;
#elseif (mui_backend == "cui")
typedef Binding<T> = cui.state.Binding<T>;
#else
#error "mui requires -D mui_backend=sui|wui|cui"
#end
