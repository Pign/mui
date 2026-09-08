# Form

A registration form with text inputs, toggles, and action buttons.

```haxe
import mui.App;
import mui.View;
import mui.ui.*;

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
            new TextInput("Enter your name", name_),
            new TextInput("Enter your email", email_),
            new Divider(),
            new Toggle("Subscribe to newsletter", newsletter_),
            new Toggle("I accept the terms", terms_),
            new Divider(),
            new HStack([
                new Button("Submit", function() { /* handle */ }),
                new Button("Clear", function() {
                    name = "";
                    email = "";
                    newsletter = true;
                    terms = false;
                }),
            ], 8),
            new Spacer(),
        ], 8);
    }

    static function main() {
        #if mui_owns_main
        new FormApp().run();
        #end
    }
}
```

## What it demonstrates

- `TextInput` with type-safe `TextInputBinding` -- no `#if` blocks
- `Toggle` with type-safe `ToggleBinding` -- no `#if` blocks
- `Divider` as a visual separator
- `appTitle` for setting the window title
