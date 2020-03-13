# vscode-anywhere-chroot

This code is a fork of the
[nix-user-chroot](https://github.com/nix-community/nix-user-chroot)
repository to implement the brew mountpoint in addition to the nix mountpoint.

## Check if your kernel supports user namespaces for unprivileged users

```console
$ unshare --user --pid echo YES
YES
```

The output should be <code>YES</code>.
If the command is absent, an alternative is to check the kernel compile options:

```console
$ zgrep CONFIG_USER_NS /proc/config.gz
CONFIG_USER_NS=y
```

On some systems, like Debian or Ubuntu, the kernel configuration is in a different place, so instead use:

```console
$ grep CONFIG_USER_NS /boot/config-$(uname -r)
CONFIG_USER_NS=y
```

On debian-based system this feature might be disabled by default.
However they provide a [sysctl switch](https://superuser.com/a/1122977)
to enable it at runtime.

On RedHat / CentOS 7.4 user namespaces are disabled by default, but can be
enabled by:

1. Adding `namespace.unpriv_enable=1` to the kernel boot parameters via `grubby`
2. `echo "user.max_user_namespaces=15076" >> /etc/sysctl.conf` to increase the
number of allowed namespaces above the default 0.

For more details, see the
[RedHat Documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html-single/getting_started_with_containers/index#user_namespaces_options)

## Download static binaries

Download [vscode-anywhere-chroot](https://github.com/gigi206/VSCode-Anywhere/releases/download/master/vscode-anywhere-chroot-linux-x86_64).

## Build from source

```console
$ nix-shell -p cargo rustup cacert git --pure
$ git clone --depth 1 https://github.com/gigi206/VSCode-Anywhere
$ cd vscode-anywhere-chroot
$ cargo build --release
```

Or build directly with nix:

```console
$ git clone --depth 1 https://github.com/gigi206/VSCode-Anywhere
$ cd vscode-anywhere-chroot
$ nix-build -A vscode_anywhere_chroot
$ ls result/bin/vscode-anywhere-chroot
result/bin/vscode-anywhere-chroot
```

If you use rustup, you can also build a statically linked version:

```console
$ nix-shell -p cargo rustup cacert git --pure
$ git clone --depth 1 https://github.com/gigi206/VSCode-Anywhere
$ cd vscode-anywhere-chroot
$ rustup install stable
$ rustup default stable
$ rustup target add x86_64-unknown-linux-musl
$ cargo build --release --target=x86_64-unknown-linux-musl
```

## Installation

This will download and extract latest nix binary tarball from the chroot:

```console
$ mkdir -m 0755 ~/.nix ~/linuxbrew
$ vscode-anywhere-chroot ~/.nix ~/linuxbrew bash -c "curl https://nixos.org/nix/install | bash"
$ vscode-anywhere-chroot ~/.nix ~/linuxbrew bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

The installation described here will not work on NixOS this way, because you
start with an empty nix store and miss therefore tools like bash and coreutils.
You won't need `vscode-anywhere-chroot` on NixOS anyway since you can get similar
functionality using `nix run --store ~/.nix nixpkgs.bash nixpkgs.coreutils`:

## Usage

After installation you can always get into the nix user chroot using:

```console
$ vscode-anywhere-chroot ~/.nix ~/linuxbrew ${SHELL=bash} -l
```

You are in a user chroot where `/` is owned by your user, hence also `/nix` and
`/home/linuxbrew` are owned by your user. Everything else is bind mounted from
the real root. The real root is under `/vscode-anywhere`.

If you cant hide the real root under `/vscode-anywhere`, you can use
[vscode-anywhere-chroot2](https://github.com/gigi206/VSCode-Anywhere/releases/download/master/vscode-anywhere-chroot2-linux-x86_64)
instead provided by [this code](vscode-anywhere-chroot/src/main2.rs).

The nix config is not in `/etc/nix` but in `/nix/etc/nix`, so that you can
modify it. This is done with the `NIX_CONF_DIR`, which you can override at any
time.

### Add a setuid version

Since not all linux distributions allow user namespaces by default, we will need
packages for those that install setuid binaries to achieve the same.
