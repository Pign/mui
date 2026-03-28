package mui;

#if (mui_backend == "sui")
typedef View = sui.View;
#elseif (mui_backend == "wui")
typedef View = wui.View;
#elseif (mui_backend == "cui")
typedef View = cui.View;
#else
#error "mui requires -D mui_backend=sui|wui|cui"
#end
