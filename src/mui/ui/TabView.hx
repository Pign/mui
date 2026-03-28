package mui.ui;

// Unified TabItem -- the common subset across backends
typedef TabItem = {
    label:String,
    content:mui.View,
};

#if (mui_backend == "sui")
class TabView extends sui.ui.TabView {
    public function new(tabs:Array<TabItem>) {
        super([for (t in tabs) {label: t.label, systemImage: "", content: t.content}]);
    }
}
#elseif (mui_backend == "wui")
class TabView extends wui.ui.TabView {
    public function new(tabs:Array<TabItem>) {
        super([for (t in tabs) {label: t.label, content: t.content}]);
    }
}
#elseif (mui_backend == "cui")
class TabView extends cui.ui.Tabs {
    public function new(tabs:Array<TabItem>, active:cui.ui.Tabs.TabSelection) {
        super([for (t in tabs) {label: t.label, content: t.content}], active);
    }
}
#elseif (mui_backend == "aui")
class TabView extends aui.ui.TabView {
    public function new(tabs:Array<TabItem>) {
        super([for (t in tabs) new aui.ui.Tab(t.label, "", t.content)]);
    }
}
#else
#error "mui requires -D mui_backend=sui|wui|cui|aui"
#end
