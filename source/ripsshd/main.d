module ripsshd;

import ripssh.cli.standalone : runStandalone;

int main(string[] arguments) {
    return runStandalone("ripsshd");
}
