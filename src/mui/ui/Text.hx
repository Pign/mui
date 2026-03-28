package mui.ui;

// Text has identical constructors across all backends: new Text(content:String)

#if (mui_backend == "sui")
typedef Text = sui.ui.Text;
#elseif (mui_backend == "wui")
typedef Text = wui.ui.Text;
#elseif (mui_backend == "cui")
typedef Text = cui.ui.Text;
#else
#error "mui requires -D mui_backend=sui|wui|cui"
#end
