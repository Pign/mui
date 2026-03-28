package tools.cli;

/**
    Builds a mui project for the specified backend.
    Runs haxe with the backend-specific build file (build-<backend>.hxml).
**/
class Build {
    public static function run(cwd:String, args:Array<String>) {
        if (args.length == 0) {
            Sys.println("Error: specify a backend (sui, wui, or cui)");
            Sys.println("Usage: mui build <sui|wui|cui> [options]");
            Sys.exit(1);
        }

        var backend = args[0];

        var hxmlFile = 'build-$backend.hxml';
        var hxmlPath = '$cwd/$hxmlFile';
        if (!sys.FileSystem.exists(hxmlPath)) {
            Sys.println('Error: $hxmlFile not found in $cwd');
            Sys.println('Run "mui init" to create a project with build files.');
            Sys.exit(1);
        }

        Sys.println('Building for $backend...');
        Sys.setCwd(cwd);
        var code = Sys.command("haxe", [hxmlFile]);
        if (code != 0) Sys.exit(code);
        Sys.println('Build complete: build/$backend/');
    }
}
