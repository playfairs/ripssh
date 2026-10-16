module ripssh.cli.dispatcher;

import std.algorithm.searching : canFind;
import std.stdio : stderr, writeln;
import ripssh.cli.commands.agent : runAgent;
import ripssh.cli.commands.connect : runConnect;
import ripssh.cli.commands.copy : runCopy;
import ripssh.cli.commands.key : runKey;
import ripssh.cli.commands.server : runServer;
import ripssh.cli.commands.sftp : runSftp;
import ripssh.cli.help : printHelp;
import ripssh.build_info : projectVersion;

enum commandNames = ["connect", "key", "agent", "server", "copy", "sftp"];

bool isKnownCommand(string name) {
    return commandNames.canFind(name);
}

int dispatch(string[] arguments) {
    if (arguments.length == 0 || arguments[0] == "-h" || arguments[0] == "--help") {
        printHelp();
        return 0;
    }

    if (arguments[0] == "-V" || arguments[0] == "--version") {
        writeln("ripssh ", projectVersion);
        return 0;
    }

    if (!isKnownCommand(arguments[0])) {
        stderr.writeln("ripssh: unknown command '", arguments[0], "'");
        stderr.writeln("Run 'ripssh --help' to see available commands.");
        return 2;
    }

    auto commandArguments = arguments[1 .. $];
    switch (arguments[0]) {
        case "connect":
            return runConnect(commandArguments);
        case "key":
            return runKey(commandArguments);
        case "agent":
            return runAgent(commandArguments);
        case "server":
            return runServer(commandArguments);
        case "copy":
            return runCopy(commandArguments);
        case "sftp":
            return runSftp(commandArguments);
        default:
            assert(false);
    }
}
