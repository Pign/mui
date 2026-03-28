package mui;

/**
    Base class for mui applications. Extend this and override body().

    Provides:
    - @:state macro support (inherited from backend)
    - appTitle property (sets window/app title on sui/wui)
    - Default Ctrl+C / q quit handling on cui
**/
#if (mui_backend == "sui")
@:autoBuild(sui.macros.StateMacro.build())
class App extends sui.App {
    /** Set the application title. Maps to sui's appName. **/
    public var appTitle(get, set):String;

    function get_appTitle():String return appName;
    function set_appTitle(v:String):String { appName = v; return v; }
}

#elseif (mui_backend == "wui")
@:autoBuild(wui.macros.StateMacro.build())
class App extends wui.App {
    var _appTitle:String = "App";

    /** Set the application title. Maps to wui's appName(). **/
    public var appTitle(get, set):String;

    function get_appTitle():String return _appTitle;
    function set_appTitle(v:String):String { _appTitle = v; return v; }

    override function appName():String return _appTitle;
}

#elseif (mui_backend == "cui")
@:autoBuild(cui.macros.StateMacro.build())
class App extends cui.App {
    /** App title (informational on cui — terminal has no title bar). **/
    public var appTitle:String = "App";

    /** Default event handler: Ctrl+C and q to quit. Override for custom keys. **/
    override function handleEvent(event:cui.event.Event):Bool {
        switch (event) {
            case Key(key):
                switch (key.code) {
                    case Char("c") if (key.ctrl): quit(); return true;
                    case Char("q"): quit(); return true;
                    default:
                }
            default:
        }
        return false;
    }
}

#else
#error "mui requires -D mui_backend=sui|wui|cui"
#end
