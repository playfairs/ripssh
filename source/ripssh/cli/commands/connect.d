module ripssh.cli.commands.connect;

import ripssh.cli.commands.unavailable : reportUnavailable;

int runConnect(string[] arguments) {
    return reportUnavailable("connect");
}
