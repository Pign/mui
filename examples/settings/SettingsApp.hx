import mui.App;
import mui.View;
import mui.ui.Text;
import mui.ui.VStack;
import mui.ui.HStack;
import mui.ui.Button;
import mui.ui.Spacer;
import mui.ui.Toggle;
import mui.ui.Divider;

class SettingsApp extends App {
    @:state var darkMode:Bool = false;
    @:state var notifications:Bool = true;
    @:state var analytics:Bool = false;
    @:state var autoUpdate:Bool = true;

    public function new() {
        super();
        appTitle = "Settings";
    }

    override function body():View {
        return new VStack([
            new Text("Settings"),
            new Divider(),
            new Text("Appearance"),
            new Toggle("Dark Mode", darkMode_),
            new Divider(),
            new Text("Notifications"),
            new Toggle("Push Notifications", notifications_),
            new Divider(),
            new Text("Privacy"),
            new Toggle("Send Analytics", analytics_),
            new Toggle("Auto-Update", autoUpdate_),
            new Divider(),
            new Text("Version 0.1.0"),
            new Spacer(),
        ], 8);
    }

    static function main() {
        #if (mui_backend == "cui")
        new SettingsApp().run();
        #end
    }
}
