# chocolatey settings

Allow to manage [chocolatey](https://chocolatey.org/).

{% hint style="warning" %}
**chocolatey** is only available for Windows.
{% endhint %}

## pkgs

`pkgs` allow to install some [chocolatey packages](https://chocolatey.org/packages).

You need to specify the name of the packages to install.

Simple example, in the [vscode-anywhere.sls](../../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file to ask to the `python3`module to install the [chocolatey python 3.8.2 package](https://chocolatey.org/packages/python/3.8.2):

```yaml
vscode-anywhere:
    python3:
        enabled: True
        chocolatey:
            pkgs:
                opts:
                    global: {}
                    install: {}
                    update: {}
                    uninstall: {}
                python:
                    enabled: True
                    opts:
                        global:
                            version: '3.8.2'
                        install: {}
                        update: {}
                        uninstall: {}
```

{% hint style="warning" %}
This is just an example, if you do that you will have 2 python packages installed. One by [scoop](https://scoop.sh) and another one by chocolatey.
{% endhint %}

### enabled

`True` to `enable`, `False` to skip \(default to `False`\).

### opts

`opts` is not mandatory but allow to pass extra args.

Extra args can be arguments described in the [saltstack chocolatey states](https://docs.saltstack.com/en/master/ref/states/all/salt.states.chocolatey.html) or can be [global saltstack arguments](https://docs.saltstack.com/en/latest/ref/states/requisites.html).

In the previous example `version`has been specified in the `global` section of the `python` package because `version` can be passed into the [states.chocolatey.installed](https://docs.saltstack.com/en/master/ref/states/all/salt.states.chocolatey.html#salt.states.chocolatey.installed), [states.chocolatey.upgraded](https://docs.saltstack.com/en/master/ref/states/all/salt.states.chocolatey.html#salt.states.chocolatey.upgraded) or [states.chocolatey.uninstalled](https://docs.saltstack.com/en/master/ref/states/all/salt.states.chocolatey.html#salt.states.chocolatey.uninstalled).

#### Global packages settings

* `chocolatey:pkgs:opts:global`: allow to pass arguments **to all chocolatey packages** when **installing**, **updating**, or **uninstalling** a package
*  `chocolatey:pkgs:opts:install`: allow to pass arguments **to all chocolatey packages** when **installing** a package \(cf [states.chocolatey.installed](https://docs.saltstack.com/en/master/ref/states/all/salt.states.chocolatey.html#salt.states.chocolatey.installed)\)
* `chocolatey:pkgs:opts:update`: allow to pass arguments **to all chocolatey packages** when **updating** a package \(cf [states.chocolatey.upgraded](https://docs.saltstack.com/en/master/ref/states/all/salt.states.chocolatey.html#salt.states.chocolatey.upgraded)\)
* `chocolatey:pkgs:opts:uninstall`: allow to pass arguments **to all chocolatey packages** when **uninstalling** a package \(cf [states.chocolatey.uninstalled](https://docs.saltstack.com/en/master/ref/states/all/salt.states.chocolatey.html#salt.states.chocolatey.uninstalled)\)

#### Specific packages settings

* `chocolatey:pkgs:<mypkg>:opts:global`: allow to pass arguments **to** `<mypkg>` **chocolatey package** when **installing**, **updating**, or **uninstalling** the package
*  `chocolatey:pkgs:<mypkg>:opts:install`: allow to pass arguments **to** `<mypkg>` **chocolatey packages** when **installing** the package \(cf [states.chocolatey.installed](https://docs.saltstack.com/en/master/ref/states/all/salt.states.chocolatey.html#salt.states.chocolatey.installed)\)
* `chocolatey:pkgs:<mypkg>:opts:update`: allow to pass arguments **to** `<mypkg>` **chocolatey packages** when **updating** the package \(cf [states.chocolatey.upgraded](https://docs.saltstack.com/en/master/ref/states/all/salt.states.chocolatey.html#salt.states.chocolatey.upgraded)\)
* `chocolatey:pkgs:<mypkg>:opts:uninstall`: allow to pass arguments **to** `<mypkg>` **chocolatey packages** when **uninstalling** the package \(cf [states.chocolatey.uninstalled](https://docs.saltstack.com/en/master/ref/states/all/salt.states.chocolatey.html#salt.states.chocolatey.uninstalled)\)

