module ripssh_scp;

import ripssh.cli.standalone : runStandalone;

int main(string[] arguments) {
    return runStandalone("ripssh-scp");
}
