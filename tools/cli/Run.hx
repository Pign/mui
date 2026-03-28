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

        // Build first
        Build.run(cwd, args);

        // Then run
        switch (backend) {
            case "sui":
                var suiArgs = ["run", "sui", "run"];
                for (a in extraArgs) suiArgs.push(a);
                Sys.setCwd(cwd);
                Sys.command("haxelib", suiArgs);

            case "wui":
                var wuiArgs = ["run", "wui", "run"];
                for (a in extraArgs) wuiArgs.push(a);
                Sys.setCwd(cwd);
                Sys.command("haxelib", wuiArgs);

            case "cui":
                Sys.setCwd(cwd);
                // Read -main from build-cui.hxml to find the binary name
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
                Sys.println("Make sure build-cui.hxml has a -main entry.");
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
