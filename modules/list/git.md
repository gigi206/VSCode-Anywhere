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

#### Hirse.vscode-ungit

This [extension](https://marketplace.visualstudio.com/items?itemName=Hirse.vscode-ungit) shows [ungit](https://github.com/FredrikNoren/ungit) in Visual Studio Code.

![Ungit](https://raw.githubusercontent.com/Hirse/vscode-ungit/master/screenshots/ungit.png)

#### mhutchie.git-graph

[This extension](https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph) allows you to view a Git Graph of your repository, and easily perform Git actions from the graph.

![git-graph](https://github.com/mhutchie/vscode-git-graph/raw/master/resources/demo.gif)

#### eamodio.gitlens

[GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens) supercharges the Git capabilities built into Visual Studio Code. It helps you to visualize code authorship at a glance via Git blame annotations and code lens, seamlessly navigate and explore Git repositories, gain valuable insights via powerful comparison commands, and so much more.

![Gitlens](https://raw.githubusercontent.com/eamodio/vscode-gitlens/master/images/docs/gitlens-preview.gif)

#### lamartire.git-indicators

[This extensions](https://marketplace.visualstudio.com/items?itemName=lamartire.git-indicators) shows some got indicators

![](https://raw.githubusercontent.com/lamartire/vscode-git-indicators/master/preview/added.png)

### VSCode settings

```javascript
{
    "gitlens.defaultGravatarsStyle": "retro",
    "ungit.showButton": true,
    "ungit.showInActiveColumn": true
}
```

### VSCode keybindings

No [keybindings](https://code.visualstudio.com/docs/getstarted/keybindings).

## Software

### Windows software

No software.

### Linux software

#### brew

* [node](https://formulae.brew.sh/formula/node)  \(required for credentials-helper\)

### MacOS software

#### brew

* [node](https://formulae.brew.sh/formula/node) \(required for credentials-helper\)

## Documentation

No documentation.

## VSCode-Anywhere

### Environment

No environment.

### Specific settings

No specific settings.

