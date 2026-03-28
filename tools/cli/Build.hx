package tools.cli;

/**
    Builds a mui project for the specified backend.
    Delegates to the backend's CLI if available, otherwise runs haxe directly.
**/
class Build {
    public static function run(cwd:String, args:Array<String>) {
        if (args.length == 0) {
            Sys.println("Error: specify a backend (sui, wui, or cui)");
            Sys.println("Usage: mui build <sui|wui|cui> [options]");
            Sys.exit(1);
        }

        var backend = args[0];
        var extraArgs = args.slice(1);

        // Check for build-<backend>.hxml
        var hxmlPath = '$cwd/build-$backend.hxml';
        if (!sys.FileSystem.exists(hxmlPath)) {
            Sys.println('Error: $hxmlPath not found');
            Sys.println('Run "mui init" to create a project with build files.');
            Sys.exit(1);
        }

        Sys.println('Building for $backend...');

        // Forward extra args (--release, --verbose, etc.) to the backend CLI
        switch (backend) {
            case "sui":
                // Delegate to sui CLI for full Swift/Xcode pipeline
                var suiArgs = ["run", "sui", "build"];
                for (a in extraArgs) suiArgs.push(a);
                Sys.setCwd(cwd);
                var code = Sys.command("haxelib", suiArgs);
                if (code != 0) Sys.exit(code);

            case "wui":
                // Delegate to wui CLI for full WinUI/MSBuild pipeline
                var wuiArgs = ["run", "wui", "build"];
                for (a in extraArgs) wuiArgs.push(a);
                Sys.setCwd(cwd);
                var code = Sys.command("haxelib", wuiArgs);
                if (code != 0) Sys.exit(code);

            case "cui":
                // cui compiles directly with haxe — no special pipeline
                Sys.setCwd(cwd);
                var code = Sys.command("haxe", ['build-$backend.hxml']);
                if (code != 0) Sys.exit(code);
                Sys.println("Build complete: build/cui/");

            default:
                Sys.println('Unknown backend: $backend');
                Sys.println("Available backends: sui, wui, cui");
                Sys.exit(1);
        }
    }
}
