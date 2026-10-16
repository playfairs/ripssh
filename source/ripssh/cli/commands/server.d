module ripssh.cli.commands.server;

import ripssh.cli.commands.unavailable : reportUnavailable;

int runServer(string[] arguments) {
    return reportUnavailable("server");
}
