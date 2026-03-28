package mui;

#if (mui_backend == "sui")
typedef App = sui.App;
#elseif (mui_backend == "wui")
typedef App = wui.App;
#elseif (mui_backend == "cui")
typedef App = cui.App;
#else
#error "mui requires -D mui_backend=sui|wui|cui"
#end
