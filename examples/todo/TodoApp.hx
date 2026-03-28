import mui.App;
import mui.View;
import mui.ui.Text;
import mui.ui.VStack;
import mui.ui.HStack;
import mui.ui.Button;
import mui.ui.Spacer;

// A todo list app showing state management and dynamic lists.
//
// Each backend handles lists/input differently, so this example
// uses #if blocks for the interactive parts while keeping
// layout and structure shared.

class TodoApp extends App {
    @:state var inputText:String = "";
    @:state var selectedIdx:Int = 0;
    var todos:Array<String>;

    public function new() {
        super();
        todos = ["Buy groceries", "Write documentation", "Review pull request"];
        #if (mui_backend == "sui")
        appName = "Todo";
        bundleIdentifier = "com.mui.todo";
        #end
    }

    #if (mui_backend == "wui")
    override function appName():String return "Todo";
    #end

    override function body():View {
        #if (mui_backend == "sui")
        return new sui.ui.NavigationStack(
            new VStack([
                new HStack(null, 8, [
                    new sui.ui.TextField("New item...", "inputText")
                        .textFieldStyle(sui.View.TextFieldStyleValue.RoundedBorder),
                    new Button("Add", null,
                        sui.state.StateAction.CustomSwift('if !inputText.isEmpty { todos.append(TodoItem(title: inputText, completed: false)); inputText = "" }'))
                ]).padding(),
                new sui.ui.List([
                    new sui.ui.ForEach("todos", "i",
                        new HStack([
                            sui.ui.Text.withState("{todos[i].title}")
                                .font(sui.View.FontStyle.Body),
                            new Spacer(),
                            new Button("Done", null,
                                sui.state.StateAction.CustomSwift("todos.remove(at: i)"))
                        ])
                    )
                ]),
            ]).navigationTitle("Todo List")
        );

        #elseif (mui_backend == "wui")
        return new VStack([
            new Text("Todo List").font(wui.modifiers.ViewModifier.FontStyle.Title).padding(),
            new Text('${todos.length} items').padding(),
            new wui.ui.TextBox("New item...", inputText).padding(),
            new Button("Add", function() {
                if (inputText.value.length > 0) {
                    todos.push(inputText.value);
                    inputText.value = "";
                }
            }).padding(),
            new Spacer(),
        ]);

        #elseif (mui_backend == "cui")
        var selection = cui.ui.ListView.ListSelection.fromState(selectedIdx);

        return new VStack([
            new Text("Todo App")
                .bold()
                .foregroundColor(cui.render.Color.Named(cui.render.Color.NamedColor.Cyan)),
            new Text('${todos.length} items').dim(),
            new Spacer(),
            cast(new cui.ui.ListView(todos, selection, null, function(idx) {
                if (idx >= 0 && idx < todos.length) {
                    todos.splice(idx, 1);
                    if (selectedIdx.get() >= todos.length && todos.length > 0)
                        selectedIdx.set(todos.length - 1);
                    cui.state.State.StateBase.markDirty();
                }
            }), View)
                .border(cui.render.BorderStyle.Single),
            new Spacer(),
            new HStack([
                new Text("New: "),
                new cui.ui.Input(cui.state.Binding.from(inputText), "Enter a todo...")
                    .border(cui.render.BorderStyle.Single),
            ], 0),
            new HStack([
                new Spacer(),
                new Button("Add", function() {
                    var text = inputText.get();
                    if (text.length > 0) {
                        todos.push(text);
                        inputText.set("");
                    }
                }),
                new Spacer(),
            ], 1),
            new Text("Tab: navigate | d: delete | Ctrl+C: quit").dim(),
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
        new TodoApp().run();
        #end
    }
}
