package mui;

#if (mui_backend == "sui")
typedef ViewComponent = sui.ViewComponent;
#elseif (mui_backend == "wui")
typedef ViewComponent = wui.ViewComponent;
#elseif (mui_backend == "cui")
typedef ViewComponent = cui.ViewComponent;
#else
#error "mui requires -D mui_backend=sui|wui|cui"
#end
