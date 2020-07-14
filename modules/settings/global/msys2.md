# msys2 settings

Allow managing [msys2](https://www.msys2.org).

{% hint style="warning" %}
**msys2** is only available for Windows.
{% endhint %}

## pkgs

`pkgs` allow installing some [msys2 packages](https://packages.msys2.org/updates).

You need to specify the name of the packages to install.

A simple example, in the [vscode-anywhere.sls](../../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file to ask to install the [msys2 python 3.8.2-1 package](https://packages.msys2.org/base/python3) in the `python3`module:

```yaml
vscode-anywhere:
    python3:
        enabled: True
        msys2:
            pkgs:
                opts:
                    global: {}
                    install: {}
                    update: {}
                    uninstall: {}
                python3:
                    enabled: True
                    opts:
                        global: {}
                        install:
                            version: "3.8.2-1"
                        update:
                            version: "3.8.2-1"
                        uninstall: {}
```

{% hint style="warning" %}
This is just an example, if you do that you will have 2 python packages installed. One by [scoop](https://scoop.sh) and another one by msys2.
{% endhint %}

### enabled

`True` to `enable`, `False` to skip \(default to `False`\).

### opts

`opts` is not mandatory but allows to pass extra args.

Extra args can be arguments described in the [Saltstack msys2 states](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/msys2.py) or can be [global Saltstack arguments](https://docs.saltstack.com/en/latest/ref/states/requisites.html).

{% hint style="info" %}
[msys2](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/msys2.py) is not an official Saltstack states but a custom states written for VSCode-Anywhere.
{% endhint %}

#### Global packages settings

* `msys2:pkgs:opts:global`: allow passing arguments **to all msys2 packages** when **installing**, **updating**, or **uninstalling** a package
*  `msys2:pkgs:opts:install`: allow passing arguments **to all msys2 packages** when **installing** a package \(cf [pkg\_installed](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/msys2.py) function\)
* `msys2:pkgs:opts:update`: allow passing arguments **to all msys2 packages** when **updating** a package \(cf [pkg\_latest](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/msys2.py) function\)
* `msys2:pkgs:opts:uninstall`: allow passing arguments **to all msys2 packages** when **uninstalling** a package \(cf [pkg\_removed](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/msys2.py) function\)

#### Specific packages settings

* `msys2:pkgs:<mypkg>:opts:global`: allow passing arguments **to** `<mypkg>` **msys2 package** when **installing**, **updating**, or **uninstalling** the package
*  `msys2:pkgs:<mypkg>:opts:install`: allow to pass arguments **to** `<mypkg>` **msys2 packages** when **installing** the package \(cf [pkg\_installed](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/msys2.py) function\)
* `msys2:pkgs:<mypkg>:opts:update`: allow to pass arguments **to** `<mypkg>` **msys2 packages** when **updating** the package \(cf [pkg\_latest](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/msys2.py) function\)
* `msys2:<mypkg>:opts:uninstall`: allow to pass arguments **to** `<mypkg>` **msys2 packages** when **uninstalling** the package \(cf [pkg\_removed](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/msys2.py) function\)

