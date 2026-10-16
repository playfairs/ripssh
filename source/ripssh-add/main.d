module ripssh_add;

import ripssh.cli.standalone : runStandalone;

int main(string[] arguments) {
    return runStandalone("ripssh-add");
}
