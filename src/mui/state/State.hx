package mui.state;

#if (mui_backend == "sui")
typedef State<T> = sui.state.State<T>;
#elseif (mui_backend == "wui")
typedef State<T> = wui.state.State<T>;
#elseif (mui_backend == "cui")
typedef State<T> = cui.state.State<T>;
#else
#error "mui requires -D mui_backend=sui|wui|cui"
#end
