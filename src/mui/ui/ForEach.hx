package mui.ui;

// ForEach APIs are irreconcilable across backends:
//   sui: string-based codegen (arrayName, itemName, itemView)
//   wui: dynamic items + template function
//   cui: typed Array<T> + builder function
// Exposed as direct typedef -- use #if blocks for cross-backend code.

#if (mui_backend == "sui")
typedef ForEach = sui.ui.ForEach;
#elseif (mui_backend == "wui")
typedef ForEach = wui.ui.ForEach;
#elseif (mui_backend == "cui")
typedef ForEach = cui.ui.ForEach;
#else
#error "mui requires -D mui_backend=sui|wui|cui"
#end
