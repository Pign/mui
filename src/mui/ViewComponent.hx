package mui;

#if (mui_backend == "sui")
typedef ViewComponent = sui.ViewComponent;
#elseif (mui_backend == "wui")
typedef ViewComponent = wui.ViewComponent;
#elseif (mui_backend == "cui")
typedef ViewComponent = cui.ViewComponent;
#elseif (mui_backend == "aui")
class ViewComponent extends aui.View {
    public function body():aui.View { return this; }
}
#else
#error "mui requires -D mui_backend=sui|wui|cui|aui"
#end
