# C\#

![](https://upload.wikimedia.org/wikipedia/commons/8/82/C_Sharp_logo.png)

## About

[C\#](https://docs.microsoft.com/en-us/dotnet/csharp/index) is a general-purpose, multi-paradigm programming language encompassing strong typing, lexically scoped, imperative, declarative, functional, generic, object-oriented \(class-based\), and component-oriented programming disciplines.

## Installation

Change `enable` from `False` to `True` in the `csharp` section \(cf [module installation](../install.md)\).

```yaml
vscode-anywhere:
    csharp:
        enabled: True
```

{% hint style="info" %}
You can also take a look at the [VSCode-Anywhere csharp module configuration](https://github.com/gigi206/VSCode-Anywhere/blob/V2/salt/modules/csharp/defaults.yaml).
{% endhint %}

{% embed url="https://youtu.be/a6WPeTG1QEk" caption="Start a new C\# project" %}

{% hint style="info" %}
You don’t need to install anything, all is already include in VSCode-Anywhere. This video gives just an example how to start a new project.
{% endhint %}

For more details read the [official documentation](https://code.visualstudio.com/docs/languages/csharp).

## Requirements

No requirements.

## VSCode

### VSCode extensions

#### ms-vscode.csharp

This [extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp) provides the following features inside VS Code:

* Lightweight development tools for [.NET Core](https://dotnet.github.io/).
* Great C\# editing support, including Syntax Highlighting, IntelliSense, Go to Definition, Find All References, etc.
* Debugging support for .NET Core \(CoreCLR\)
* The C\# extension is powered by [OmniSharp](https://github.com/OmniSharp/omnisharp-roslyn).

![IntelliSense](https://code.visualstudio.com/assets/docs/languages/csharp/intellisense.png)

Following your OS, please read \(note that all requirements are already installed by VSCode-Anywhere\):

* [Windows](https://channel9.msdn.com/Blogs/dotnet/Get-started-VSCode-Csharp-NET-Core-Windows)
* [Linux](https://channel9.msdn.com/Blogs/dotnet/Get-started-with-VS-Code-Csharp-dotnet-Core-Ubuntu)
* [MacOS](https://channel9.msdn.com/Blogs/dotnet/Get-started-VSCode-NET-Core-Mac)

{% hint style="success" %}
The first time you open a `cs` file, this extension will download its prerequisites.
{% endhint %}

#### wghats.vscode-nxunit-test-adapter

This [extension](https://marketplace.visualstudio.com/items?itemName=wghats.vscode-nxunit-test-adapter) allow to run your Nunit or Xunit test for Desktop .NET Framework or Mono.

### VSCode settings

#### Windows settings

```javascript
{
    "nxunitExplorer.nunit": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\nunit-console\\current\\nunit3-console.exe"
}
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

#### Linux settings

```javascript
{
    "nxunitExplorer.nunit": "/home/myuser/VSCode-Anywhere/apps/vscode-anywhere/home/.nix-profile/bin/nunit3-console"
}
```

{% hint style="info" %}
Assuming you have installed in the directory `/home/myuser/VSCode-Anywhere`.
{% endhint %}

### VSCode keybindings

No [keybindings](https://code.visualstudio.com/docs/getstarted/keybindings).

## Software

### Windows software

#### scoop

* [dotnet-sdk](https://github.com/ScoopInstaller/Main/blob/master/bucket/dotnet-sdk.json)
* [scriptcs](https://github.com/ScoopInstaller/Main/blob/master/bucket/scriptcs.json)
* [nunit-console](https://github.com/ScoopInstaller/Main/blob/master/bucket/nunit-console.json)

### Linux software

#### nix

* [nixpkgs.dotnetPackages.NUnitConsole](https://nixos.org/nixos/packages.html?attr=dotnetPackages.NUnitConsole&channel=nixpkgs-unstable&query=NUnitConsole)
* [nixpkgs.dotnet-sdk\_3](https://nixos.org/nixos/packages.html?attr=dotnet-sdk_3&channel=nixpkgs-unstable&query=dotnet-sdk)

### MacOS software

#### brew

* [scriptcs](https://formulae.brew.sh/formula/scriptcs)

#### nix

* [nixpkgs.dotnetPackages.NUnitConsole](https://nixos.org/nixos/packages.html?attr=dotnetPackages.NUnitConsole&channel=nixpkgs-unstable&query=NUnitConsole)
* [nixpkgs.dotnet-sdk\_3](https://nixos.org/nixos/packages.html?attr=dotnet-sdk_3&channel=nixpkgs-unstable&query=dotnet-sdk)

## Documentation

* [NET\_Framework](https://github.com/Kapeli/feeds/blob/master/NET_Framework.xml)

## VSCode-Anywhere

### Environment

#### Window environment

```yaml
DOTNET_ROOT: C:\VSCode-Anywhere\apps\scoop\apps\dotnet-sdk\current
MSBuildSDKsPath: C:\VSCode-Anywhere\apps\scoop\apps\dotnet-sdk\current\sdk\<version>\Sdks
```

{% hint style="info" %}
`<version>` is the version of the `dontnet-sdk` package.
{% endhint %}

### Specific settings

No specific settings.

