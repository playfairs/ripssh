module ripssh.cli.help;

import std.stdio : writeln;
import ripssh.build_info : projectVersion;

void printHelp() {
    writeln("RipSSH ", projectVersion);
    writeln();
    writeln("Usage: ripssh <command> [arguments]");
    writeln();
    writeln("Commands:");
    writeln("  connect  Connect to a remote host");
    writeln("  key      Manage keys");
    writeln("  agent    Manage the authentication agent");
    writeln("  server   Run the SSH server");
    writeln("  copy     Copy files to or from a remote host");
    writeln("  sftp     Start an SFTP session");
    writeln();
    writeln("Options:");
    writeln("  -h, --help     Show this help");
    writeln("  -V, --version  Show version information");
}
