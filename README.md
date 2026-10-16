# RipSSH

A Ripnetwork solution for a modern SSH ecosystem written in D.


The `ripssh connect` command currently opens a TCP connection and exchanges SSH
identification banners. SSH key exchange, authentication, and interactive sessions
are not implemented yet. Key management, agents, file transfer, and server behavior
remain placeholders.

## Development

Enter the Nix development shell and configure/build with Nox:

```sh
nix develop
nox setup build
nox build build
```

The shell provides LDC, Clang, and Nox on branch `dev`. Nox places the built
executables under the selected build directory.

Run the main CLI with Nox:

```sh
nox run ripssh -- --help
nox run ripssh -- --version
```

The other executable targets are `ripssh-keygen`, `ripssh-agent`, `ripssh-add`,
`ripssh-scp`, `ripssh-sftp`, and `ripsshd`. Each is currently an explicit
placeholder. The `ripssh-tests` target provides D unit tests and can be run with
`nox run ripssh-tests`.

The shared modules live under `source/ripssh`; executable-specific entry points
live in their corresponding directories beneath `source`.

---

**RipSSH** is a **Ripnetwork** Project

**Ripnetwork** is an independent software and infrastructure organization.