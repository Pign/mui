package tools.cli;

/**
    Main entry point for the mui CLI.
    Invoked via `haxelib run mui <command> [args...]`
**/
class CLI {
    static function main() {
        var args = Sys.args();

        // haxelib passes the calling directory as the last argument
        var cwd = Sys.getCwd();
        if (args.length > 0) {
            var last = args[args.length - 1];
            if (!StringTools.startsWith(last, "-") && sys.FileSystem.exists(last) && sys.FileSystem.isDirectory(last)) {
                cwd = args.pop();
            }
        }

        if (args.length == 0) {
            printUsage();
            return;
        }

        var command = args[0];
        var commandArgs = args.slice(1);

        switch (command) {
            case "init":
                Init.run(cwd, commandArgs);
            case "build":
                Build.run(cwd, commandArgs);
            case "run":
                Run.run(cwd, commandArgs);
            case "clean":
                clean(cwd);
            case "help" | "--help" | "-h":
                printUsage();
            case "version" | "--version" | "-v":
                Sys.println("mui 0.1.0");
            default:
                Sys.println('Unknown command: $command');
                printUsage();
                Sys.exit(1);
        }
    }

    static function clean(cwd:String) {
        Sys.println("Cleaning build artifacts...");
        var buildDir = '$cwd/build';
        if (sys.FileSystem.exists(buildDir)) {
            removeDirectory(buildDir);
        }
        Sys.println("Done.");
    }

    static function printUsage() {
        Sys.println("
mui — Multi-UI: write once, deploy to macOS/iOS, Windows, Android, and terminal

Usage: mui <command> [options]

Commands:
  init [name]          Scaffold a new mui project
  build <backend>      Build for a specific backend
  run <backend>        Build and run
  clean                Remove build artifacts
  help                 Show this help message
  version              Show version

Backends:
  sui                  macOS / iOS / visionOS (via SwiftUI)
  wui                  Windows (via WinUI 3)
  aui                  Android (via Jetpack Compose)
  cui                  Terminal (TUI)

Examples:
  mui init MyApp
  mui build sui
  mui run cui
  mui build wui --release
");
    }

    static function removeDirectory(path:String) {
        if (sys.FileSystem.isDirectory(path)) {
            for (entry in sys.FileSystem.readDirectory(path)) {
                removeDirectory('$path/$entry');
            }
            sys.FileSystem.deleteDirectory(path);
        } else {
            sys.FileSystem.deleteFile(path);
        }
    }
}
