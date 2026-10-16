module ripssh_keygen;

import ripssh.cli.standalone : runStandalone;

int main(string[] arguments) {
    return runStandalone("ripssh-keygen");
}
