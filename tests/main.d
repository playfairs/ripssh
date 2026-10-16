module ripssh_tests;

import ripssh.cli.dispatcher : isKnownCommand;
import ripssh.build_info : projectVersion;

unittest {
    assert(isKnownCommand("connect"));
    assert(isKnownCommand("key"));
    assert(isKnownCommand("agent"));
    assert(isKnownCommand("server"));
    assert(isKnownCommand("copy"));
    assert(isKnownCommand("sftp"));
    assert(!isKnownCommand("unknown"));
    assert(projectVersion.length > 0);
}

int main() {
    return 0;
}
