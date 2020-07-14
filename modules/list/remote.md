# Remote

![](https://code.visualstudio.com/assets/docs/remote/remote-overview/architecture.png)

## About

The Visual Studio Code Remote Development extension pack allows you to open any folder in a container, on a remote machine \(via SSH\), or in the [Windows Subsystem for Linux](https://docs.microsoft.com/windows/wsl) \(WSL\) and take advantage of VS Code’s full feature set.

This means that VS Code can provide a local-quality development experience — including full IntelliSense \(completions\), debugging, and more — regardless of where your code is located or hosted.

## Installation

Change `enable` from `False` to `True` in the `remote` section \(cf [module installation](../install.md)\).

```yaml
vscode-anywhere:
    remote:
        enabled: True
```

{% hint style="info" %}
You can also take a look at the [VSCode-Anywhere docker module configuration](https://github.com/gigi206/VSCode-Anywhere/blob/V2/salt/modules/docker/defaults.yaml).
{% endhint %}

For more details, please visit the [official documentation](https://code.visualstudio.com/docs/remote/remote-overview).

## Requirements

No requirements.

## VSCode

### VSCode extensions

#### ms-vscode-remote.remote-ssh

This [extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) lets you use any remote machine with an SSH server as your development environment.

Read the [documentation](https://code.visualstudio.com/remote-tutorials/ssh/getting-started), the [tutorial](https://code.visualstudio.com/remote-tutorials/ssh/getting-started), and [tips](https://code.visualstudio.com/docs/remote/troubleshooting#_ssh-tips) for more details.

![](https://microsoft.github.io/vscode-remote-release/images/ssh-readme.gif)

### VSCode settings

#### Windows settings

```javascript
{
    "remote.SSH.path": "C:\\VSCode-Anywhere\\apps\scoop\\apps\\git\\usr\\bin\\ssh.exe"
}
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

#### Linux settings

```javascript
{
    "remote.SSH.path": "/home/linuxbrew/.linuxbrew/bin/ssh"
}
```



### VSCode keybindings

No [keybindings](https://code.visualstudio.com/docs/getstarted/keybindings).

## Software <a id="software"></a>

### Linux software <a id="linux-software"></a>

#### brew <a id="brew"></a>

* ​[openssh](https://formulae.brew.sh/formula/openssh)

## Documentation <a id="documentation"></a>

No documentation.

## VSCode-Anywhere <a id="vscode-anywhere"></a>

### Environment <a id="environment"></a>

No environment.

#### Linux environment

No environment.

#### MacOS environment

No environment.

### Specific settings <a id="specific-settings"></a>

No specific settings

