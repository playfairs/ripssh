module ripssh.cli.commands.connect;

import std.stdio : stderr, writeln;
import std.string : startsWith;
import ripssh.transport : TransportException, connectAndReadIdentification;

struct ConnectOptions {
    string host;
    string user;
    ushort port = 22;
}

bool parsePort(string value, out ushort port) {
    if (value.length == 0) {
        return false;
    }

    uint parsed;
    foreach (character; value) {
        if (character < '0' || character > '9') {
            return false;
        }
        auto digit = character - '0';
        if (parsed > (ushort.max - digit) / 10) {
            return false;
        }
        parsed = parsed * 10 + digit;
    }

    if (parsed == 0) {
        return false;
    }
    port = cast(ushort) parsed;
    return true;
}

bool parseDestination(string destination, out string user, out string host) {
    size_t separator = destination.length;
    foreach (index, character; destination) {
        if (character == '@') {
            if (separator != destination.length) {
                return false;
            }
            separator = index;
        }
    }

    if (separator == destination.length) {
        user = "";
        host = destination;
        return host.length > 0;
    }

    user = destination[0 .. separator];
    host = destination[separator + 1 .. $];
    return user.length > 0 && host.length > 0;
}

void printConnectHelp() {
    writeln("Usage: ripssh connect [-p PORT | --port PORT] [USER@]HOST");
    writeln();
    writeln("Options:");
    writeln("  -p, --port PORT  Connect to PORT (default: 22)");
    writeln("  -h, --help       Show this help");
}

int runConnect(string[] arguments) {
    ConnectOptions options;
    string destination;
    bool positionalOnly;

    for (size_t index; index < arguments.length; index++) {
        auto argument = arguments[index];
        if (argument == "-h" || argument == "--help") {
            printConnectHelp();
            return 0;
        }
        if (!positionalOnly && argument == "--") {
            positionalOnly = true;
            continue;
        }
        if (!positionalOnly && (argument == "-p" || argument == "--port")) {
            if (index + 1 == arguments.length) {
                stderr.writeln("ripssh connect: missing value for ", argument);
                printConnectHelp();
                return 2;
            }
            index++;
            if (!parsePort(arguments[index], options.port)) {
                stderr.writeln("ripssh connect: invalid port '", arguments[index], "'");
                return 2;
            }
            continue;
        }
        if (!positionalOnly && argument.startsWith("-")) {
            stderr.writeln("ripssh connect: unknown option '", argument, "'");
            printConnectHelp();
            return 2;
        }
        if (destination.length) {
            stderr.writeln("ripssh connect: expected exactly one destination");
            printConnectHelp();
            return 2;
        }
        destination = argument;
    }

    if (!destination.length) {
        stderr.writeln("ripssh connect: missing destination");
        printConnectHelp();
        return 2;
    }
    if (!parseDestination(destination, options.user, options.host)) {
        stderr.writeln("ripssh connect: invalid destination '", destination, "'");
        return 2;
    }

    string remoteIdentification;
    try {
        remoteIdentification = connectAndReadIdentification(options.host, options.port);
    } catch (TransportException error) {
        stderr.writeln("ripssh connect: ", error.msg);
        return 255;
    }

    auto remoteName = options.user.length
        ? options.user ~ "@" ~ options.host
        : options.host;
    writeln("SSH identification exchange with ", remoteName, ":", options.port, " succeeded.");
    writeln("Remote identification: ", remoteIdentification);
    stderr.writeln(
        "ripssh connect: key exchange, authentication, and interactive sessions are not implemented yet"
    );
    return 2;
}

unittest {
    ushort port;
    assert(parsePort("22", port) && port == 22);
    assert(parsePort("65535", port) && port == 65535);
    assert(!parsePort("0", port));
    assert(!parsePort("65536", port));
    assert(!parsePort("22x", port));
    assert(!parsePort("999999999999999999999999", port));

    string user;
    string host;
    assert(parseDestination("alice@example.com", user, host));
    assert(user == "alice" && host == "example.com");
    assert(parseDestination("example.com", user, host));
    assert(user.length == 0 && host == "example.com");
    assert(!parseDestination("@example.com", user, host));
    assert(!parseDestination("alice@", user, host));
    assert(!parseDestination("alice@host@other", user, host));
}
