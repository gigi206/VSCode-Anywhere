---
description: Saltstack minion configuration
---

# conf

## minion / miniond.d

The `VSCode-Anywhere/conf/saltstack/conf/minion` file is the main configuration file. VSCode-Anywhere does not configure anything in this file but in the `VSCode-Anywhere/conf/saltstack/conf/minion.d` directory.

The `VSCode-Anywhere/conf/saltstack/conf/minion.d` directory contains the [the Saltstack minion configuration](https://docs.saltstack.com/en/latest/ref/configuration/minion.html).

The file `VSCode-Anywhere/conf/saltstack/conf/minion.d/VSCode-Anywhere.conf` is managed by VSCode-Anywhere. You don’t have to modify manually this file.

{% hint style="danger" %}
This is not recommended to edit manually the `VSCode-Anywhere/conf/saltstack/conf/minion` or `VSCode-Anywhere/conf/saltstack/conf/minion.d/VSCode-Anywhere.conf` files.

But if you still want to change the minion configuration, you can:

* override settings within the pillar configuration file [pillar](https://vscode-anywhere.readthedocs.io/en/dev/structure/conf/saltstack/pillar/index.html#conf-saltstack-pillar) in the `vscode-Anywhere:saltstack_core` section
* add a file with the `conf` extension in the `VSCode-Anywhere/conf/saltstack/conf/minion.d/minion.d` directory
{% endhint %}

## grains

The `VSCode-Anywhere/conf/saltstack/conf/minion.d/grains` file manage the [Saltstack grains](https://docs.saltstack.com/en/latest/topics/grains/).

{% hint style="danger" %}
This is not recommended to edit manually the `grains` file.
{% endhint %}

