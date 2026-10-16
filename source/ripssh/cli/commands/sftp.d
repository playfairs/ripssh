module ripssh.cli.commands.sftp;

import ripssh.cli.commands.unavailable : reportUnavailable;

int runSftp(string[] arguments) {
    return reportUnavailable("sftp");
}
