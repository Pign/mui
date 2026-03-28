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

        var hxmlFile = 'build-$backend.hxml';
        if (!sys.FileSystem.exists('$cwd/$hxmlFile')) {
            Sys.println('Error: $hxmlFile not found in $cwd');
            Sys.exit(1);
        }

        Sys.setCwd(cwd);

        switch (backend) {
            case "sui":
                // sui CLI handles full pipeline + launch
                Build.ensureBuildHxml(cwd, backend);
                Build.ensureSuiJson(cwd);
                var suiArgs = ["run", "sui", "run"];
                for (a in extraArgs) suiArgs.push(a);
                Sys.exit(Sys.command("haxelib", suiArgs));

            case "wui":
                Build.ensureBuildHxml(cwd, backend);
                var wuiArgs = ["run", "wui", "run"];
                for (a in extraArgs) wuiArgs.push(a);
                Sys.exit(Sys.command("haxelib", wuiArgs));

            case "cui":
                // Build first, then run the binary
                Build.run(cwd, args);
                var mainClass = readMainClass('$cwd/build-cui.hxml');
                if (mainClass != null) {
                    var bin = '$cwd/build/cui/$mainClass';
                    if (sys.FileSystem.exists(bin)) {
                        Sys.println('Running $mainClass...');
                        Sys.exit(Sys.command(bin));
                    }
                }
                Sys.println("Error: could not find compiled binary in build/cui/");
                Sys.exit(1);

            default:
                Sys.println('Unknown backend: $backend');
                Sys.exit(1);
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
