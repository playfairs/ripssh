module ripssh.cli.commands.unavailable;

import std.stdio : stderr;

int reportUnavailable(string command) {
    stderr.writeln("ripssh: command '", command, "' is not implemented");
    return 2;
}
