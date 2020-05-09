---
description: Saltstack pillar
---

# pillar

The directory `VSCode-Anywhere/conf/saltstack/pillar` manages the [Saltstack pillar](https://docs.saltstack.com/en/latest/topics/pillar/) files.  


## top.sls

`VSCode-Anywhere/conf/saltstack/pillar/top.sls` is the [Salstack top file](https://docs.saltstack.com/en/latest/ref/states/top.html).

{% hint style="danger" %}
This is not recommended to edit manually this file
{% endhint %}

## saltstack.sls

The file `VSCode-Anywhere/conf/saltstack/pillar/saltstack.sls` is for internal use.

{% hint style="danger" %}
This is not recommended to edit manually this file
{% endhint %}

## vscode-anywhere.sls

`VSCode-Anywhere/conf/saltstack/pillar/vscode-anywhere.sls` is the file where you can interact with VSCode-Anywhere to activate a module. Please read the documentation modules to know how to [activate](../../../modules/install.md) or [configure](../../../modules/settings/) a module.

{% hint style="success" %}
All modules can be overrided by a specific configuration.
{% endhint %}

