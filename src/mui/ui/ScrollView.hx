package mui.ui;

// ScrollView constructors differ:
//   sui: ScrollView(content:Array<View>)
//   wui: ScrollViewer(content:View) -- single child
//   cui: ScrollView(child:View, offset:ScrollOffset) -- needs scroll offset binding

#if (mui_backend == "sui")
typedef ScrollView = sui.ui.ScrollView;
#elseif (mui_backend == "wui")
class ScrollView extends wui.ui.ScrollViewer {
    public function new(content:wui.View) {
        super(content);
    }
}
#elseif (mui_backend == "cui")
class ScrollView extends cui.ui.ScrollView {
    public function new(child:cui.View, offset:cui.ui.ScrollView.ScrollOffset) {
        super(child, offset);
    }
}
#elseif (mui_backend == "aui")
typedef ScrollView = aui.ui.ScrollView;
#else
#error "mui requires -D mui_backend=sui|wui|cui|aui"
#end
