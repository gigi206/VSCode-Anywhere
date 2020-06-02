# PowerShell

![](https://upload.wikimedia.org/wikipedia/commons/a/af/PowerShell_Core_6.0_icon.png)

## About

[PowerShell](https://docs.microsoft.com/en-us/powershell/) is a task automation and configuration management framework from Microsoft, consisting of a command-line shell and associated scripting language.

## Installation

Change `enable` from `False` to `True` in the `powershell` section \(cf [module installation](../install.md)\).

```yaml
vscode-anywhere:
    powershell:
        enabled: True
```

{% hint style="info" %}
You can also take a look at the [VSCode-Anywhere PowersShell module configuration](https://code.visualstudio.com/docs/languages/powershell).
{% endhint %}

## Requirements

No requirements.

## VSCode

### VSCode extensions

#### ms-vscode.PowerShell

This [extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell) provides rich PowerShell language support for Visual Studio Code.

Now you can write and debug PowerShell scripts using the excellent IDE-like interface that Visual Studio Code provides.

### VSCode settings

#### Global settings

```javascript
{
  "dash.languageIdToDocsetMap.powershell": [
    "posh"
  ]
}
```

#### Windows settings

```javascript
{
  "powershell.powerShellDefaultVersion": "Scoop PowerShell",
  "powershell.powerShellAdditionalExePaths": [
    {
      "exePath": "${env:SystemRoot}\\system32\\WindowsPowerShell\\v1.0\\powershell.exe",
      "versionName": "Windows PowerShell"
    },
    {
      "exePath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\pwsh\\current\\pwsh.exe",
      "versionName": "Scoop PowerShell"
    }
  ]
}
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

#### Linux settings

```javascript
{
  "powershell.powerShellDefaultVersion": "Nix PowerShell",
  "powershell.powerShellAdditionalExePaths": [
    {
      "exePath": "/home/myuser/VSCode-Anywhere/apps/vscode-anywhere/home/.nix-profile/bin/pwsh",
      "versionName": "Nix PowerShell"
    }
  ]
}
```

{% hint style="info" %}
Assuming you have installed in the directory `/home/myuser/VSCode-Anywhere`.
{% endhint %}

### VSCode keybindings

No [keybindings](https://code.visualstudio.com/docs/getstarted/keybindings).

## Software <a id="software"></a>

### Windows software <a id="windows-software"></a>

#### scoop

* [pwsh](https://github.com/ScoopInstaller/Main/blob/master/bucket/pwsh.json)

### Linux software <a id="linux-software"></a>

#### nix

* [nixpkgs.powershell](https://nixos.org/nixos/packages.html?attr=powershell&channel=nixpkgs-unstable&query=powershell)

### MacOS software <a id="macos-software"></a>

#### brew <a id="brew-1"></a>

* [​cask/powershell](https://formulae.brew.sh/cask/powershell)
* [cask/pester](https://formulae.brew.sh/cask/pester)

## Documentation <a id="documentation"></a>

* [Powershell](https://github.com/Kapeli/feeds/blob/master/Powershell.xml)

## VSCode-Anywhere

### Environment

No environment.

### Specific settings

No specific settings.

