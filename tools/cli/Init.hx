package tools.cli;

import sys.io.File;
import sys.FileSystem;

/**
    Scaffolds a new mui project with build files for all backends.
**/
class Init {
    public static function run(cwd:String, args:Array<String>) {
        var projectName = if (args.length > 0) args[0] else "MyApp";
        var projectDir = '$cwd/$projectName';

        if (FileSystem.exists(projectDir)) {
            Sys.println('Error: Directory "$projectName" already exists.');
            Sys.exit(1);
        }

        Sys.println('Creating new mui project: $projectName');

        FileSystem.createDirectory(projectDir);
        FileSystem.createDirectory('$projectDir/src');

        // build-sui.hxml
        File.saveContent('$projectDir/build-sui.hxml', '-cp src
-lib mui
-lib sui
-D mui_backend=sui
--macro sui.macros.SwiftGenerator.register()
-main $projectName
-cpp build/cpp
');

        // build-wui.hxml
        File.saveContent('$projectDir/build-wui.hxml', '-cp src
-lib mui
-lib wui
-D mui_backend=wui
-main $projectName
-cpp build/wui
');

        // build-cui.hxml
        File.saveContent('$projectDir/build-cui.hxml', '-cp src
-lib mui
-lib cui
-D mui_backend=cui
-main $projectName
-cpp build/cui
');

        // mui.json
        File.saveContent('$projectDir/mui.json', '{
    "appName": "$projectName",
    "bundleIdentifier": "com.example.${projectName.toLowerCase()}"
}
');

        // Main app file
        File.saveContent('$projectDir/src/$projectName.hx', 'import mui.App;
import mui.View;
import mui.ui.Text;
import mui.ui.VStack;
import mui.ui.HStack;
import mui.ui.Button;
import mui.ui.Spacer;

class $projectName extends App {
    @:state var count:Int = 0;

    #if (mui_backend == "wui")
    override function appName():String return "$projectName";
    #end

    override function body():View {
        #if (mui_backend == "cui")
        var c = count.get();
        #else
        var c = count.value;
        #end

        return new VStack([
            new Spacer(),
            new Text("Hello from $projectName!"),
            new Text(\'Count: $$c\'),
            new HStack([
                #if (mui_backend == "cui")
                new Button("-", function() count.set(count.get() - 1)),
                new Button("+", function() count.set(count.get() + 1)),
                #else
                new Button("-", function() count.value = count.value - 1),
                new Button("+", function() count.value = count.value + 1),
                #end
            ], 8),
            new Spacer(),
        ], 10);
    }

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
        new $projectName().run();
        #end
    }
}
');

        // .gitignore
        File.saveContent('$projectDir/.gitignore', 'build/\n');

        Sys.println('Project "$projectName" created successfully!');
        Sys.println("");
        Sys.println("Next steps:");
        Sys.println('  cd $projectName');
        Sys.println("  mui build cui      # terminal");
        Sys.println("  mui build sui      # macOS/iOS");
        Sys.println("  mui build wui      # Windows");
    }
}
