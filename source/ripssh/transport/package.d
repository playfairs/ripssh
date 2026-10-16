module ripssh.transport;

import std.socket;
import std.conv : to;
import std.string : startsWith;
import ripssh.build_info : projectVersion;

class TransportException : Exception {
    this(string message) {
        super(message);
    }
}

string connectAndReadIdentification(string hostname, ushort port) {
    Address[] addresses;
    try {
        addresses = getAddress(hostname, port);
    } catch (SocketException error) {
        throw new TransportException("could not resolve '" ~ hostname ~ "': " ~ error.msg);
    }

    if (addresses.length == 0) {
        throw new TransportException("could not resolve '" ~ hostname ~ "'");
    }

    Socket connectedSocket;
    string lastConnectError;
    foreach (address; addresses) {
        auto socket = new Socket(address.addressFamily, SocketType.STREAM, ProtocolType.TCP);
        try {
            socket.connect(address);
            connectedSocket = socket;
            break;
        } catch (SocketException error) {
            lastConnectError = error.msg;
            socket.close();
        }
    }

    if (connectedSocket is null) {
        throw new TransportException(
            "could not connect to " ~ hostname ~ ":" ~ port.to!string ~
            (lastConnectError.length ? ": " ~ lastConnectError : "")
        );
    }

    scope (exit) connectedSocket.close();

    immutable clientIdentification = "SSH-2.0-RipSSH_" ~ projectVersion ~ "\r\n";
    size_t sent;
    auto identificationBytes = cast(const(void)[]) clientIdentification;
    while (sent < identificationBytes.length) {
        ptrdiff_t written;
        try {
            written = connectedSocket.send(identificationBytes[sent .. $]);
        } catch (SocketException error) {
            throw new TransportException("could not send SSH identification: " ~ error.msg);
        }
        if (written <= 0) {
            throw new TransportException("remote host closed the connection while sending SSH identification");
        }
        sent += cast(size_t) written;
    }

    size_t preambleLines;
    while (preambleLines <= 50) {
        string line;
        while (true) {
            ubyte[1] byteBuffer;
            ptrdiff_t received;
            try {
                received = connectedSocket.receive(byteBuffer[]);
            } catch (SocketException error) {
                throw new TransportException("could not read SSH identification: " ~ error.msg);
            }
            if (received == 0) {
                throw new TransportException("remote host closed the connection before sending an SSH identification");
            }
            if (received < 0) {
                throw new TransportException("failed to read SSH identification");
            }

            char value = cast(char) byteBuffer[0];
            if (value == '\n') {
                break;
            }
            if (line.length >= 254 || value == '\0') {
                throw new TransportException("remote host sent an invalid SSH identification line");
            }
            line ~= value;
        }

        if (line.length && line[$ - 1] == '\r') {
            line = line[0 .. $ - 1];
        }
        if (line.startsWith("SSH-2.0-") || line.startsWith("SSH-1.99-")) {
            return line;
        }
        if (line.startsWith("SSH-")) {
            throw new TransportException("remote host uses an unsupported SSH protocol version: " ~ line);
        }
        if (preambleLines == 50) {
            break;
        }
        preambleLines++;
    }

    throw new TransportException("remote host sent too many lines before its SSH identification");
}
