import mui.App;
import mui.View;
import mui.ui.Text;
import mui.ui.VStack;
import mui.ui.HStack;
import mui.ui.Button;
import mui.ui.Spacer;
import mui.ui.Toggle;
import mui.ui.TextInput;
import mui.ui.Divider;

class FormApp extends App {
    @:state var name:String = "";
    @:state var email:String = "";
    @:state var newsletter:Bool = true;
    @:state var terms:Bool = false;

    public function new() {
        super();
        appTitle = "Form";
    }

    override function body():View {
        return new VStack([
            new Text("Registration"),
            new Divider(),
            new TextInput("Enter your name", name),
            new TextInput("Enter your email", email),
            new Divider(),
            new Toggle("Subscribe to newsletter", newsletter),
            new Toggle("I accept the terms", terms),
            new Divider(),
            new HStack([
                new Button("Submit", function() {
                    // Handle submit
                }),
                new Button("Clear", function() {
                    name.set("");
                    email.set("");
                    newsletter.set(true);
                    terms.set(false);
                }),
            ], 8),
            new Spacer(),
        ], 8);
    }

    static function main() {
        #if (mui_backend == "cui")
        new FormApp().run();
        #end
    }
}
