# Git

![](https://upload.wikimedia.org/wikipedia/commons/e/e0/Git-logo.svg)

## About

[Git](https://git-scm.com/) is a distributed version-control system for tracking changes in source code during software development. It is designed for coordinating work among programmers, but it can be used to track changes in any set of files.

Not that there is already [native component to manage git](https://code.visualstudio.com/docs/editor/versioncontrol) within VSCode. This module extends the capabilities of git by adding some features.

{% hint style="success" %}
Git is already installed during the VSCode-Anywhere installation process. This module allow you to install only additional VSCode extensions.
{% endhint %}

## Installation

Change `enable` from `False` to `True` in the `git` section \(cf [module installation](../install.md)\).

```yaml
vscode-anywhere:
    git:
        enabled: True
```

{% hint style="info" %}
You can also take a look at the [VSCode-Anywhere git module configuration](https://github.com/gigi206/VSCode-Anywhere/blob/V2/salt/modules/git/defaults.yaml).
{% endhint %}

## Requirements

No requirements \(`git` is installed during the installation process\).

## VSCode

### VSCode extensions



