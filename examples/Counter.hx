import mui.App;
import mui.View;
import mui.ui.Text;
import mui.ui.VStack;
import mui.ui.HStack;
import mui.ui.Button;
import mui.ui.Spacer;

// A counter app that compiles to SwiftUI, WinUI, and terminal.
//
// Build:
//   haxe build-sui.hxml
//   haxe build-wui.hxml
//   haxe build-cui.hxml

class Counter extends App {
    @:state var count:Int = 0;

    #if (mui_backend == "wui")
    override function appName():String return "Counter";
    #end

    override function body():View {
        // State read: sui/wui use .value, cui uses .get()
        #if (mui_backend == "cui")
        var c = count.get();
        #else
        var c = count.value;
        #end

        return new VStack([
            new Spacer(),
            new Text("Counter"),
            new Text('Count: $c'),
            new HStack([
                // State write: closures use the backend's state API
                #if (mui_backend == "cui")
                new Button("-", function() count.set(count.get() - 1)),
                new Button("Reset", function() count.set(0)),
                new Button("+", function() count.set(count.get() + 1)),
                #else
                new Button("-", function() count.value = count.value - 1),
                new Button("Reset", function() count.value = 0),
                new Button("+", function() count.value = count.value + 1),
                #end
            ], 8),
            new Spacer(),
        ], 10);
    }

    // cui requires explicit event handling for quit
    #if (mui_backend == "cui")
    override function handleEvent(event:cui.event.Event):Bool {
        switch (event) {
            case Key(key):
                switch (key.code) {
                    case Char("q"): quit(); return true;
                    default:
                }
            default:
        }
        return false;
    }
    #end

    static function main() {
        #if (mui_backend == "cui")
        new Counter().run();
        #end
    }
}
