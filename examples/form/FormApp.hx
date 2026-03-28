import mui.App;
import mui.View;
import mui.ui.Text;
import mui.ui.VStack;
import mui.ui.HStack;
import mui.ui.Button;
import mui.ui.Spacer;
import mui.ui.Toggle;

// A form with text inputs, toggles, and submit/clear.
//
// Demonstrates how input bindings differ per backend while
// layout and flow remain shared.

class FormApp extends App {
    @:state var name:String = "";
    @:state var email:String = "";
    @:state var newsletter:Bool = true;
    @:state var terms:Bool = false;
    @:state var submitted:Bool = false;

    public function new() {
        super();
        #if (mui_backend == "sui")
        appName = "Form";
        bundleIdentifier = "com.mui.form";
        #end
    }

    #if (mui_backend == "wui")
    override function appName():String return "Form";
    #end

    override function body():View {
        // -- Submitted confirmation view --
        #if (mui_backend == "cui")
        if (submitted.get()) {
            return new VStack([
                new Text("Form Submitted!")
                    .bold()
                    .foregroundColor(cui.render.Color.Named(cui.render.Color.NamedColor.Green)),
                new Spacer(),
                new Text('Name:       ${name.get()}'),
                new Text('Email:      ${email.get()}'),
                new Text('Newsletter: ${newsletter.get() ? "Yes" : "No"}'),
                new Text('Terms:      ${terms.get() ? "Accepted" : "Not accepted"}'),
                new Spacer(),
                new Button("Back", function() submitted.set(false)),
            ], 1).padding(1).border(cui.render.BorderStyle.Rounded);
        }
        #end

        // -- Form view --
        #if (mui_backend == "sui")
        return new sui.ui.NavigationStack(
            new sui.ui.Form([
                new sui.ui.Section("Profile", [
                    new sui.ui.TextField("Name", "name"),
                    new sui.ui.TextField("Email", "email"),
                ]),
                new sui.ui.Section("Preferences", [
                    new Toggle("Subscribe to newsletter", "newsletter"),
                    new Toggle("I accept the terms", "terms"),
                ]),
                new sui.ui.Section("Actions", [
                    new Button("Submit", function() {
                        submitted.value = true;
                    }),
                    new Button("Clear", function() {
                        name.value = "";
                        email.value = "";
                        newsletter.value = true;
                        terms.value = false;
                    }),
                ]),
            ]).navigationTitle("Registration")
        );

        #elseif (mui_backend == "wui")
        return new VStack([
            new Text("Registration").font(wui.modifiers.ViewModifier.FontStyle.Title).padding(),
            new Text("Name").padding(),
            new wui.ui.TextBox("Enter your name...", name).padding(),
            new Text("Email").padding(),
            new wui.ui.TextBox("Enter your email...", email).padding(),
            new Toggle("Subscribe to newsletter", newsletter),
            new Toggle("I accept the terms", terms),
            new HStack([
                new Button("Submit", function() submitted.value = true).padding(),
                new Button("Clear", function() {
                    name.value = "";
                    email.value = "";
                    newsletter.value = true;
                    terms.value = false;
                }).padding(),
            ]),
            new Spacer(),
        ]).padding();

        #elseif (mui_backend == "cui")
        return new VStack([
            new Text("Registration Form")
                .bold()
                .foregroundColor(cui.render.Color.Named(cui.render.Color.NamedColor.Cyan)),
            new Spacer(),
            new HStack([
                new Text("Name:  ").foregroundColor(cui.render.Color.Named(cui.render.Color.NamedColor.Yellow)),
                new cui.ui.Input(cui.state.Binding.from(name), "Enter your name")
                    .border(cui.render.BorderStyle.Single),
            ], 0),
            new HStack([
                new Text("Email: ").foregroundColor(cui.render.Color.Named(cui.render.Color.NamedColor.Yellow)),
                new cui.ui.Input(cui.state.Binding.from(email), "Enter your email")
                    .border(cui.render.BorderStyle.Single),
            ], 0),
            new Spacer(),
            new Toggle("Subscribe to newsletter", cui.ui.Checkbox.CheckboxBinding.fromState(newsletter)),
            new Toggle("I accept the terms", cui.ui.Checkbox.CheckboxBinding.fromState(terms)),
            new Spacer(),
            new HStack([
                new Spacer(),
                new Button("Submit", function() submitted.set(true)),
                new Spacer(),
                new Button("Clear", function() {
                    name.set("");
                    email.set("");
                    newsletter.set(true);
                    terms.set(false);
                }),
                new Spacer(),
            ], 1),
            new Text("Tab: navigate | Enter/Space: toggle | Ctrl+C: quit").dim(),
        ], 1).padding(1).border(cui.render.BorderStyle.Rounded);
        #end
    }

    #if (mui_backend == "cui")
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
        new FormApp().run();
        #end
    }
}
