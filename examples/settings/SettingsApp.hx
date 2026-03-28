import mui.App;
import mui.View;
import mui.ui.Text;
import mui.ui.VStack;
import mui.ui.HStack;
import mui.ui.Button;
import mui.ui.Spacer;
import mui.ui.Toggle;
import mui.ui.Divider;

// A settings screen with toggles, sections, and an about view.
//
// Demonstrates conditional views (switching between settings and about)
// as a cross-platform alternative to navigation.

class SettingsApp extends App {
    @:state var darkMode:Bool = false;
    @:state var notifications:Bool = true;
    @:state var analytics:Bool = false;
    @:state var autoUpdate:Bool = true;
    @:state var showAbout:Bool = false;

    public function new() {
        super();
        #if (mui_backend == "sui")
        appName = "Settings";
        bundleIdentifier = "com.mui.settings";
        #end
    }

    #if (mui_backend == "wui")
    override function appName():String return "Settings";
    #end

    override function body():View {
        // -- About sub-view --
        #if (mui_backend == "cui")
        if (showAbout.get()) {
        #else
        if (showAbout.value) {
        #end
            return aboutView();
        }

        // -- Main settings view --
        #if (mui_backend == "sui")
        return new sui.ui.NavigationStack(
            new sui.ui.Form([
                new sui.ui.Section("Appearance", [
                    new Toggle("Dark Mode", "darkMode"),
                ]),
                new sui.ui.Section("Notifications", [
                    new Toggle("Push Notifications", "notifications"),
                ]),
                new sui.ui.Section("Privacy", [
                    new Toggle("Send Analytics", "analytics"),
                    new Toggle("Auto-Update", "autoUpdate"),
                ]),
                new sui.ui.Section("Info", [
                    new Button("About", function() showAbout.value = true),
                    new Text("Version 0.1.0")
                        .foregroundColor(sui.View.ColorValue.Secondary),
                ]),
            ]).navigationTitle("Settings")
        );

        #elseif (mui_backend == "wui")
        return new VStack([
            new Text("Settings")
                .font(wui.modifiers.ViewModifier.FontStyle.Title)
                .padding(),
            new Text("Appearance").font(wui.modifiers.ViewModifier.FontStyle.Subtitle).padding(),
            new Toggle("Dark Mode", darkMode),
            new Divider(),
            new Text("Notifications").font(wui.modifiers.ViewModifier.FontStyle.Subtitle).padding(),
            new Toggle("Push Notifications", notifications),
            new Divider(),
            new Text("Privacy").font(wui.modifiers.ViewModifier.FontStyle.Subtitle).padding(),
            new Toggle("Send Analytics", analytics),
            new Toggle("Auto-Update", autoUpdate),
            new Divider(),
            new Button("About", function() showAbout.value = true).padding(),
            new Text("Version 0.1.0").opacity(0.6).padding(),
            new Spacer(),
        ]).padding();

        #elseif (mui_backend == "cui")
        return new VStack([
            new Text("Settings")
                .bold()
                .foregroundColor(cui.render.Color.Named(cui.render.Color.NamedColor.Cyan)),
            new Spacer(),
            sectionHeader("Appearance"),
            new Toggle("Dark Mode", cui.ui.Checkbox.CheckboxBinding.fromState(darkMode)),
            new Divider(),
            sectionHeader("Notifications"),
            new Toggle("Push Notifications", cui.ui.Checkbox.CheckboxBinding.fromState(notifications)),
            new Divider(),
            sectionHeader("Privacy"),
            new Toggle("Send Analytics", cui.ui.Checkbox.CheckboxBinding.fromState(analytics)),
            new Toggle("Auto-Update", cui.ui.Checkbox.CheckboxBinding.fromState(autoUpdate)),
            new Divider(),
            new Spacer(),
            new HStack([
                new Spacer(),
                new Button("About", function() showAbout.set(true)),
                new Spacer(),
            ], 1),
            new Text("Version 0.1.0").dim(),
            new Text("Tab: navigate | Space: toggle | Ctrl+C: quit").dim(),
        ], 1).padding(1).border(cui.render.BorderStyle.Rounded);
        #end
    }

    function aboutView():View {
        #if (mui_backend == "sui")
        return new VStack(null, 20, [
            new Spacer(),
            new Text("Settings App")
                .font(sui.View.FontStyle.LargeTitle),
            new Text("Built with mui")
                .font(sui.View.FontStyle.Title)
                .foregroundColor(sui.View.ColorValue.Secondary),
            new Text("A cross-platform UI abstraction for Haxe.")
                .foregroundColor(sui.View.ColorValue.Secondary)
                .multilineTextAlignment(sui.View.TextAlignment.Center)
                .padding(),
            new Text("Backends: SwiftUI, WinUI, TUI")
                .font(sui.View.FontStyle.Caption),
            new Button("Back", function() showAbout.value = false),
            new Spacer(),
        ]);

        #elseif (mui_backend == "wui")
        return new VStack([
            new Spacer(),
            new Text("Settings App")
                .font(wui.modifiers.ViewModifier.FontStyle.TitleLarge)
                .padding(),
            new Text("Built with mui")
                .font(wui.modifiers.ViewModifier.FontStyle.Subtitle)
                .padding(),
            new Text("A cross-platform UI abstraction for Haxe.").padding(),
            new Text("Backends: SwiftUI, WinUI, TUI")
                .font(wui.modifiers.ViewModifier.FontStyle.Caption)
                .padding(),
            new Button("Back", function() showAbout.value = false).padding(),
            new Spacer(),
        ]).padding();

        #elseif (mui_backend == "cui")
        return new VStack([
            new Spacer(),
            new Text("Settings App")
                .bold()
                .foregroundColor(cui.render.Color.Named(cui.render.Color.NamedColor.Cyan)),
            new Text("Built with mui"),
            new Spacer(),
            new Text("A cross-platform UI abstraction for Haxe."),
            new Text("Backends: SwiftUI, WinUI, TUI").dim(),
            new Spacer(),
            new Button("Back", function() showAbout.set(false)),
            new Spacer(),
        ], 1).padding(1).border(cui.render.BorderStyle.Rounded);
        #end
    }

    #if (mui_backend == "cui")
    function sectionHeader(title:String):View {
        return new Text(title)
            .foregroundColor(cui.render.Color.Named(cui.render.Color.NamedColor.Yellow));
    }

    override function handleEvent(event:cui.event.Event):Bool {
        switch (event) {
            case Key(key):
                switch (key.code) {
                    case Char("q") if (key.ctrl): quit(); return true;
                    default:
                }
            default:
        }
        return false;
    }
    #end

    static function main() {
        #if (mui_backend == "cui")
        new SettingsApp().run();
        #end
    }
}
