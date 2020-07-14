# Docker

![](https://www.docker.com/sites/default/files/d8/2019-07/Moby-logo.png)

## About

[Docker](https://www.docker.com/) is a set of platform as a service \(PaaS\) products that use OS-level virtualization to deliver software in packages called containers.

## Installation

Change `enable` from `False` to `True` in the `docker` section \(cf [module installation](../install.md)\).

```yaml
vscode-anywhere:
    docker:
        enabled: True
```

{% hint style="info" %}
You can also take a look at the [VSCode-Anywhere docker module configuration](https://github.com/gigi206/VSCode-Anywhere/blob/V2/salt/modules/docker/defaults.yaml).
{% endhint %}

For more details, please visit the [official documentation](https://code.visualstudio.com/docs/azure/docker).

## Requirements

### Privileges

#### Windows privileges

VSCode-Anywhere will install [Docker](https://www.docker.com) only if you have the `windows_admin` [profile](../../install/advanced/windows-installation.md#profiles) set because it requires administrator rights.

Note that without this profile, you will not be able to use all the features of the [ms-azuretools.vscode-docker](https://vscode-anywhere.readthedocs.io/en/dev/modules/docker.html#ms-azuretools-vscode-docker) extension.

In addition to the `windows_admin` profile, Docker requires **Windows 10 64-bit: Pro, Enterprise, or Education \(Build 15063 or later\)** and [Hyper-V](https://docs.microsoft.com/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v) and Containers Windows features must be enabled.

Also BIOS-level hardware virtualization support must be enabled in the BIOS settings.

{% hint style="info" %}
If you haven’t set the`windows_admin`profile, you can manually install Docker. Please take a look at the [documentation](https://docs.docker.com/docker-for-windows/install/).
{% endhint %}

## VSCode

### VSCode extensions

#### ms-azuretools.vscode-docker

This [extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) makes it easy to build, manage and deploy containerized applications from Visual Studio Code.

![Docker management](https://github.com/microsoft/vscode-docker/raw/master/resources/readme/docker-view-context-menu.gif)

![docker-compose](https://github.com/microsoft/vscode-docker/raw/master/resources/readme/dockercomposesearch.png)

![Dockerfile](https://github.com/microsoft/vscode-docker/raw/master/resources/readme/dockerfile-intellisense.png)

{% embed url="https://youtu.be/vQxSOL9kE-s" caption="Docker extension for VSCode" %}

### VSCode settings

```javascript
{
    "dash.languageIdToDocsetMap.dockerfile": [
        "docker"
    ]
}
```

### VSCode keybindings

No [keybindings](https://code.visualstudio.com/docs/getstarted/keybindings).

## Software

### Windows software

#### chocolatey

* [docker-desktop](https://chocolatey.org/packages/docker-desktop) \(only if the [profile](../../install/advanced/windows-installation.md#profiles) is set to `windows_admin`\) 

{% hint style="info" %}
To work, the extension must have `docker-desktop` running.
{% endhint %}

### Linux software

#### nix

* [nixpkgs.docker](https://nixos.org/nixos/packages.html?attr=docker&channel=nixpkgs-unstable)
* [nixpkgs.docker-compose](https://nixos.org/nixos/packages.html?attr=docker-compose&channel=nixpkgs-unstable)

{% hint style="info" %}
To work, the extension must have started `dockerd`. To start Docker, you need `sudo` privileges:

```text
sudo /home/myuser/VSCode-Anywhere/apps/vscode-anywhere/home/.nix-profile/bin/dockerd
```

Assuming you have installed in the directory `/home/myuser/VSCode-Anywhere`.
{% endhint %}

### MacOS software

#### brew

* [cask/docker](https://formulae.brew.sh/cask/docker)
* [cask/virtualbox](https://formulae.brew.sh/cask/virtualbox)
* [docker-compose](https://formulae.brew.sh/formula/docker-compose)

{% hint style="info" %}
To work, the extension must have `docker-desktop` running.
{% endhint %}

## Documentation

* [Docker](https://github.com/Kapeli/feeds/blob/master/Docker.xml)

## VSCode-Anywhere

### Environment

No environment.

### Specific settings

No specific settings.

