module ripssh.cli.commands.agent;

import ripssh.cli.commands.unavailable : reportUnavailable;

int runAgent(string[] arguments) {
    return reportUnavailable("agent");
}
