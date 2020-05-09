# Linux requirements

## Packages

To install VSCode-Anywhere on Linux, you must have installed the mandatory packages: `bash`, `coreutils` and `curl` installed.

The packages `bash`, `tar` and `coreutils` are installed by default on most Linux distributions.

The following commands are used in the installation process and are part of the previous required packages:

```text
$ command -v bash
/usr/bin/bash
$ command -v tar
/usr/bin/tar
$ command -v curl
/usr/bin/curl
$ command -v realpath
/usr/bin/realpath
$ command -v cut
/usr/bin/cut
$ command -v readlink
/usr/bin/readlink
$ command -v test
/usr/bin/test
$ command -v mkdir
/usr/bin/mkdir
$ command -v chmod
/usr/bin/chmod
$ command -v id
/usr/bin/id
$ command -v rm
/usr/bin/rm
$ command -v echo
/usr/bin/echo
```

`realpath`, `cut`, `readlink`, `test`, `mkdir`, `chmod`, `id`, `rm` and `echo` are part of the `coreutils` package.

If you have an unprivileged account and the `curl` binary is not installed on your system, you can [download the static curl binary](https://github.com/gigi206/VSCode-Anywhere/raw/V2/bin/linux/curl-linux-x86_64) .

After that, you must rename `curl-linux-x86_64` to `curl` and put it in your `PATH`.

Example after downloading the curl binary with your favorite browser:

```bash
chmod +x ~/Download/curl-linux-x86_64
mkdir ~/bin
mv ~/Download/curl-linux-x86_64 ~/bin
export PATH=~/bin:$PATH
curl -Lk https://curl.haxx.se/ca/cacert.pem > ~/cacert.pem
export SSL_CERT_FILE=~/cacert.pem
bash <(curl -sL https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/V2/VSCode-Anywhere.sh)
```

{% hint style="info" %}
Assuming that `~/download` is where the file was downloaded.
{% endhint %}

## Namespaces

If you install VSCode-Anywhere with the `linux_user` profile \(by default\), you must to have a kernel that support the user namespaces \(3.8 minimal\).

If the `unshare` binary is installed on your system, you can test with:

```text
$ unshare --user --pid echo YES
YES
```

