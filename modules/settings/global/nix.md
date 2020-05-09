# nix settings

Allow to manage [nix](https://nixos.org).

{% hint style="warning" %}
**nix** is only available for Linux and MacOS.
{% endhint %}

## pkgs

`pkgs` allow to install some [nix packages](https://nixos.org/nixos/packages.html?channel=nixpkgs-unstable&query=) \(see [website](https://nixos.org/nixpkgs/)\).

You need to specify the name of the packages to install.

2 ways to install nix packages:

* by name, equivalent to:

```text
nix-env -i python3
```

```yaml
vscode-anywhere:
    python3:
        enabled: True
        nix:
          pkgs:
            python3:
              enabled: True
```

* by attribute \(recommended\), equivalent to:

```text
nix-env -iA nixpkgs.python3
```

```yaml
vscode-anywhere:
    python3:
        enabled: True
        nix:
          pkgs:
            python3:
              enabled: True
              attr: nixpkgs.python3Full
```

{% hint style="info" %}
`python3` _\(line 6\)_ is the real name of the package once installed. To retrieve the package name:

```text
nix-instantiate --eval -E '(import <nixpkgs> {}).python3Full.pname'
"python3"
```

Sometimes `pname` doesn't exist. In this case you can use name and remove the version:

```text
nix-instantiate --eval -E '(import <nixpkgs> {}).dotnetPackages.NUnitConsole.pname'
error: attribute 'pname' missing, at (string):1:1
nix-instantiate --eval -E '(import <nixpkgs> {}).dotnetPackages.NUnitConsole.name'
"NUnit.Console-3.0.1"
```
{% endhint %}

### enabled

`True` to `enable`, `False` to skip \(default to `False`\).

### attr

`attr` is not mandatory but allow to specify specific attribute like `python3Full`.

### opts

`opts` is not mandatory but allow to pass extra args.

Extra args can be arguments described in the [saltstack nix states](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/nix.py) or can be [global saltstack arguments](https://docs.saltstack.com/en/latest/ref/states/requisites.html).

{% hint style="info" %}
[nix](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/nix.py) is not an official saltstack states but a custom states written for VSCode-Anywhere.
{% endhint %}

#### channel

It use the `-I` option of `nix-env` \(`man nix-env`\):

```text
   -I path
       Add a path to the Nix expression search path. This option may be given multiple times. See the NIX_PATH environment variable for information on the semantics of the Nix
       search path. Paths added through -I take precedence over NIX_PATH.
```

Example:

```yaml
vscode-anywhere:
    python3:
        enabled: True
        nix:
          pkgs:
            opts:
              install: {}
              update: {}
              uninstall: {}
            python3:
              enabled: True
              attr: nixpkgs.python3Full
              install:
                channel: nixpkgs=https://github.com/NixOS/nixpkgs/archive/master.tar.gz
              update:
                channel: nixpkgs=https://github.com/NixOS/nixpkgs/archive/master.tar.gz
              uninstall: {}
```

This is equivalent to:

```text
nix-env -iA python3Full -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/master.tar.gz
```

#### Global packages settings

* `nix:pkgs:opts:global`: allow to pass arguments **to all nix packages** when **installing**, **updating**, or **uninstalling** a package
* `nix:pkgs:opts:install`: allow to pass arguments **to all nix packages** when **installing** a package  \(cf [pkg\_installed](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/nix.py) function\)
* `nix:pkgs:opts:update`: allow to pass arguments **to all nix packages** when **updating** a package \(cf [pkg\_latest](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/nix.py) function\)
* `nix:pkgs:opts:uninstall`: allow to pass arguments **to all nix packages** when **uninstalling** a package \(cf [pkg\_removed](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/nix.py) function\)

#### Specific packages settings

* `nix:pkgs:<mypkg>:opts:global`: allow to pass arguments **to** `<mypkg>` **nix package** when **installing**, **updating**, or **uninstalling** the package
* `nix:pkgs:<mypkg>:opts:install`: allow to pass arguments **to** `<mypkg>` **nix packages** when **installing** the package \(cf [pkg\_installed](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/nix.py) function\)
* `nix:pkgs:<mypkg>:opts:update`: allow to pass arguments **to** `<mypkg>` **nix packages** when **updating** the package \(cf [pkg\_latest](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/nix.py) function\)
* `nix:pkgs:<mypkg>:opts:uninstall`: allow to pass arguments **to** `<mypkg>` **nix packages** when **uninstalling** the package \(cf [pkg\_removed](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/nix.py) function\)

