module ripssh_sftp;

import ripssh.cli.standalone : runStandalone;

int main(string[] arguments) {
    return runStandalone("ripssh-sftp");
}
