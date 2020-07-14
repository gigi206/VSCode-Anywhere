# scoop settings

Allow managing [scoop](https://scoop.sh).

{% hint style="warning" %}
**scoop** is only available for Windows.
{% endhint %}

## pkgs

`pkgs` allow installing some scoop packages \(cf [github](https://github.com/lukesampson/scoop)\).

You need to specify the name of the packages to install.

A simple example, in the [vscode-anywhere.sls](../../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file to ask to install the [scoop python 3.8.2 package](https://chocolatey.org/packages/python/3.8.2) in the `python3`module:

```yaml
vscode-anywhere:
    python3:
        enabled: True
        scoop:
            pkgs:
                opts:
                    global: {}
                    install: {}
                    update: {}
                    uninstall: {}
                python:
                    enabled: True
                    opts:
                        global: {}
                        install:
                            version: '3.8.2'
                        update: {}
                        uninstall: {}
```

### enabled

`True` to `enable`, `False` to skip \(default to `False`\).

### opts

`opts` is not mandatory but allows to pass extra args.

Extra args can be arguments described in the [Saltstack scoop states](https://docs.saltstack.com/en/master/ref/states/all/salt.states.chocolatey.html) or can be [global Saltstack arguments](https://docs.saltstack.com/en/latest/ref/states/requisites.html).

#### Global packages settings

* `scoop:pkgs:opts:global`: allow  passing arguments **to all scoop packages** when **installing**, **updating**, or **uninstalling** a package
*  `scoop:pkgs:opts:install`: allow passing arguments **to all scoop packages** when **installing** a package \(cf [pkg\_installed](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/scoop.py) function\)
* `scoop:pkgs:opts:update`: allow passing arguments **to all scoop packages** when **updating** a package \(cf [pkg\_latest](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/scoop.py) function\)
* `scoop:pkgs:opts:uninstall`: allow passing arguments **to all scoop packages** when **uninstalling** a package \(cf [pkg\_removed](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/scoop.py) function\)

#### Specific packages settings

* `scoop:pkgs:<mypkg>:opts:global`: allow passing arguments **to** `<mypkg>` **scoop package** when **installing**, **updating**, or **uninstalling** the package
* `scoop:pkgs:<mypkg>:opts:install`: allow passing arguments **to** `<mypkg>` **scoop packages** when **installing** the package \(cf [pkg\_installed](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/scoop.py) function\)
* `scoop:pkgs:<mypkg>:opts:update`: allow passing arguments **to** `<mypkg>` **scoop packages** when **updating** the package \(cf [pkg\_latest](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/scoop.py) function\)
* `scoop:pkgs:<mypkg>:opts:uninstall`: allow passing arguments **to** `<mypkg>` **scoop packages** when **uninstalling** the package \(cf [pkg\_removed](https://github.com/gigi206/VSCode-Anywhere/blob/V2/_states/scoop.py) function\)

