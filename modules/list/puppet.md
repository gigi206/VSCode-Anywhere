# Puppet

![](https://upload.wikimedia.org/wikipedia/commons/b/be/Puppet_Logo.svg)

## About

[Puppet](https://puppet.com/) is an open-core software configuration management tool.

## Installation

Change `enable` from `False` to `True` in the `puppet` section \(cf [module installation](../install.md)\).

```yaml
vscode-anywhere:
    puppet:
        enabled: True
```

{% hint style="info" %}
You can also take a look at the [VSCode-Anywhere puppet module configuration](https://github.com/gigi206/VSCode-Anywhere/blob/V2/salt/modules/perl/defaults.yaml).
{% endhint %}

## Requirements

The [puppet.puppet-vscode](https://marketplace.visualstudio.com/items?itemName=puppet.puppet-vscode) extension required to have [pdk](https://puppet.com/docs/pdk/1.x/pdk.html) \(Puppet Development Kit\) installed.

{% hint style="warning" %}
**pdk** will be installed only with the `windows_admin` profile or with MacOS.
{% endhint %}

## VSCode

### VSCode extensions

#### puppet.puppet-vscode

Official [Puppet VSCode extension](https://marketplace.visualstudio.com/items?itemName=puppet.puppet-vscode). Provides full Puppet DSL intellisense, syntax highlighting, Puppet command support, Puppet node graphs, and much more.

### VSCode settings

No [settings](https://code.visualstudio.com/docs/getstarted/settings).

### VSCode keybindings

No [keybindings](https://code.visualstudio.com/docs/getstarted/keybindings).

## Software

### Windows software

#### chocolatey

* [pdk](https://chocolatey.org/packages/pdk) \(only installed by the `windows_admin` profile\)

### Documentation

* [Puppet](https://github.com/Kapeli/feeds/blob/master/Puppet.xml)

### VSCode-Anywhere

### Environment <a id="environment"></a>

No environment.

### Specific settings <a id="specific-settings"></a>

No specific settings.

