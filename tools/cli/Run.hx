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
                // sui CLI handles run (launches the macOS app or simulator)
                var suiArgs = ["run", "sui", "run"];
                for (a in extraArgs) suiArgs.push(a);
                Sys.setCwd(cwd);
                Sys.command("haxelib", suiArgs);

            case "wui":
                // wui CLI handles run (launches the .exe)
                var wuiArgs = ["run", "wui", "run"];
                for (a in extraArgs) wuiArgs.push(a);
                Sys.setCwd(cwd);
                Sys.command("haxelib", wuiArgs);

            case "cui":
                // Find and run the compiled binary
                Sys.setCwd(cwd);
                // Read mui.json or build-cui.hxml to find the binary name
                var binDir = '$cwd/build/cui/';
                if (sys.FileSystem.exists(binDir)) {
                    // The hxcpp output binary is typically named after the main class
                    for (entry in sys.FileSystem.readDirectory(binDir)) {
                        if (!StringTools.endsWith(entry, ".hx") &&
                            !StringTools.endsWith(entry, ".cpp") &&
                            !StringTools.endsWith(entry, ".h") &&
                            !StringTools.endsWith(entry, ".o") &&
                            !sys.FileSystem.isDirectory('$binDir$entry')) {
                            // Likely the executable
                            Sys.println('Running $entry...');
                            Sys.command('$binDir$entry');
                            return;
                        }
                    }
                }
                Sys.println("Error: could not find compiled binary in build/cui/");
                Sys.exit(1);

            default:
                Sys.println('Unknown backend: $backend');
                Sys.exit(1);
        }
    }
}
