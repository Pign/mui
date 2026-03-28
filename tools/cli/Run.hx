package tools.cli;

/**
    Builds and runs a mui project for the specified backend.
**/
class Run {
    public static function run(cwd:String, args:Array<String>) {
        if (args.length == 0) {
            Sys.println("Error: specify a backend (sui, wui, or cui)");
            Sys.println("Usage: mui run <sui|wui|cui> [options]");
            Sys.exit(1);
        }

        var backend = args[0];
        var extraArgs = args.slice(1);

        // Build first (runs haxe build-<backend>.hxml)
        Build.run(cwd, args);

        switch (backend) {
            case "sui":
                // The sui CLI needs build.hxml — symlink our build-sui.hxml
                ensureBuildHxml(cwd, backend);
                var suiArgs = ["run", "sui", "run"];
                for (a in extraArgs) suiArgs.push(a);
                Sys.setCwd(cwd);
                Sys.command("haxelib", suiArgs);

            case "wui":
                ensureBuildHxml(cwd, backend);
                var wuiArgs = ["run", "wui", "run"];
                for (a in extraArgs) wuiArgs.push(a);
                Sys.setCwd(cwd);
                Sys.command("haxelib", wuiArgs);

            case "cui":
                Sys.setCwd(cwd);
                var mainClass = readMainClass('$cwd/build-cui.hxml');
                if (mainClass != null) {
                    var bin = '$cwd/build/cui/$mainClass';
                    if (sys.FileSystem.exists(bin)) {
                        Sys.println('Running $mainClass...');
                        Sys.exit(Sys.command(bin));
                        return;
                    }
                }
                Sys.println("Error: could not find compiled binary in build/cui/");
                Sys.exit(1);

            default:
                Sys.println('Unknown backend: $backend');
                Sys.exit(1);
        }
    }

    /**
        The backend CLIs (sui, wui) expect a build.hxml in the project root.
        Create one that includes our build-<backend>.hxml if it doesn't exist.
    **/
    static function ensureBuildHxml(cwd:String, backend:String):Void {
        var buildHxml = '$cwd/build.hxml';
        if (!sys.FileSystem.exists(buildHxml)) {
            sys.io.File.saveContent(buildHxml, 'build-$backend.hxml\n');
        }
    }

    static function readMainClass(hxmlPath:String):String {
        if (!sys.FileSystem.exists(hxmlPath)) return null;
        var content = sys.io.File.getContent(hxmlPath);
        for (line in content.split("\n")) {
            var trimmed = StringTools.trim(line);
            if (StringTools.startsWith(trimmed, "-main ")) {
                return StringTools.trim(trimmed.substr(6));
            }
        }
        return null;
    }
}
