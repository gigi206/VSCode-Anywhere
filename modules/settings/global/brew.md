# brew settings

Allow managing [brew](https://brew.sh).

{% hint style="warning" %}
**brew** is only available for Linux and MacOS.
{% endhint %}

## pkgs

`pkgs` allow to install:

* Linux OS:
  * [Linux formulae](https://formulae.brew.sh/formula-linux/) 
* MacOS:
  * [MacOS formulae](https://formulae.brew.sh/formula/)
  * [Casks](https://formulae.brew.sh/cask/)

You need to specify the formulae name to install.

A simple example, in the [vscode-anywhere.sls](../../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file to ask to install the `python3`module the [brew python 3.8 package](https://formulae.brew.sh/formula/python@3.8):

```yaml
vscode-anywhere:
    python3:
        enabled: True
        brew:
            pkgs:
                opts:
                    global: {}
                    install: {}
                    update: {}
                    uninstall: {}
                python@3.8:
                    enabled: True
                    opts:
                        global: {}
                        install: {}
                        update: {}
                        uninstall: {}
```

{% hint style="warning" %}
This is just an example for illustrative purposes.
{% endhint %}

### enabled

`True` to `enable`, `False` to skip \(default to `False`\).

### opts

`opts` is not mandatory but allows to pass extra args.

Extra args can be arguments described in the [Saltstack pkg states](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pkg.html) or can be [global Saltstack arguments](https://docs.saltstack.com/en/latest/ref/states/requisites.html).

In the previous example `version`has been specified in the `install` section of the `python` package because `version` can be passed into the [states.pkg.installed](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pkg.html#salt.states.pkg.installed).

#### Global packages settings

* `brew:pkgs:opts:global`: allow passing arguments **to all brew packages** when **installing**, **updating**, or **uninstalling** a package
*  `brew:pkgs:opts:install`: allow passing arguments **to all brew packages** when **installing** a package \(cf [states.pkg.installed](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pkg.html#salt.states.pkg.installed)\)
* `brew:pkgs:opts:update`: allow passing arguments **to all brew packages** when **updating** a package \(cf [states.pkg.latest](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pkg.html#salt.states.pkg.latest)\)
* `brew:pkgs:opts:uninstall`: allow passing arguments **to all brew packages** when **uninstalling** a package \(cf [states.pkg.removed](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pkg.html#salt.states.pkg.removed)\)

#### Specific packages settings

* `brew:pkgs:<mypkg>:opts:global`: allow passing arguments **to** `<mypkg>` **brew package** when **installing**, **updating**, or **uninstalling** the package
*  `brew:pkgs:<mypkg>:opts:install`: allow to pass arguments **to** `<mypkg>` **brew packages** when **installing** the package \(cf [states.pkg.installed](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pkg.html#salt.states.pkg.installed)\)
* `brew:pkgs:<mypkg>:opts:update`: allow to pass arguments **to** `<mypkg>` **brew packages** when **updating** the package \(cf [states.pkg.latest](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pkg.html#salt.states.pkg.latest)\)
* `brew:pkgs:<mypkg>:opts:uninstall`: allow to pass arguments **to** `<mypkg>` **brew packages** when **uninstalling** the package \(cf [states.pkg.removed](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pkg.html#salt.states.pkg.removed)\)

