# Tutorials

## Replace VSCode by VSCodium

 [VSCode](https://code.visualstudio.com) ****is installed by default. If you prefer use [VSCodium](https://vscodium.com) instead then set `vscodium` to `True` inside the `vscode_core` section in the [vscode-anywhere.sls](structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file:

```yaml
vscode-anywhere:
  vscode_core:
    vscodium: True
```

After that you have just to run the [installation script](structure/tools/install.md) again.

## Set bash or PowerShell as default shell in Windows

The git installer provides the bash binary and it can be used as the default shell. To use bash as the default shell, set the following settings in the `custom` section in the [vscode-anywhere.sls](structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file:

```yaml
vscode-anywhere:
  custom:
    settings:
      terminal.integrated.shell.windows: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'git', 'current', 'bin', 'bash.exe') }}
```

Or you can use the default Windows powershell:

```yaml
vscode-anywhere:
  custom:
    settings:
      terminal.integrated.shell.windows: {{ salt['environ.get']('SystemRoot') | path_join('system32', 'WindowsPowerShell', 'v1.0', 'powershell.exe')' }}
```

Or if [powershell](modules/list/powershell.md#installation) module is set to `enabled`, you can use `pwsh` \(powershell core\) instead:

```yaml
vscode-anywhere:
  custom:
    settings:
      terminal.integrated.shell.windows: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'pwsh', 'current', 'pwsh.exe') }}
```



After that you have just to run the [installation script](structure/tools/install.md) again.

