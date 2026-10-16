module ripssh_agent;

import ripssh.cli.standalone : runStandalone;

int main(string[] arguments) {
    return runStandalone("ripssh-agent");
}
