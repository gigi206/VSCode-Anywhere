# Tutorials

## Replace VSCode by VSCodium

 [VSCode](https://code.visualstudio.com) ****is installed by default. If you prefer to use [VSCodium](https://vscodium.com) instead then set`vscodium`to`True`inside the`vscode_core`section in the [vscode-anywhere.sls](../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file:

```yaml
vscode-anywhere:
  vscode_core:
    vscodium: True
```

After that, you have just to run the [installation script](../structure/tools/install.md) again.

## Set bash or PowerShell as default shell in Windows

The git installer provides the bash binary and it can be used as the default shell. To use bash as the default shell, set the following settings in the`custom`section in the [vscode-anywhere.sls](../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file:

```yaml
vscode-anywhere:
  custom:
    settings:
      terminal.integrated.shell.windows: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'git', 'current', 'bin', 'bash.exe') }}
```

Or you can use the default Windows PowerShell:

```yaml
vscode-anywhere:
  custom:
    settings:
      terminal.integrated.shell.windows: {{ salt['environ.get']('SystemRoot') | path_join('system32', 'WindowsPowerShell', 'v1.0', 'powershell.exe')' }}
```

Or if [powershell](../modules/list/powershell.md#installation) module is set to `enabled`, you can use `pwsh` \(PowerShell core\) instead:

```yaml
vscode-anywhere:
  custom:
    settings:
      terminal.integrated.shell.windows: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'pwsh', 'current', 'pwsh.exe') }}
```

After that, you have just to run the [installation script](../structure/tools/install.md) again.

## Change the default theme

All following examples must be set in in the [vscode-anywhere.sls](../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file and after editing this file you have to run the [installation script](../structure/tools/install.md).

### Preconfigured theme

If the [vscode](../modules/list/vscode.md#installation) module is `enabled`, the default theme is set to [One Dark Pro](../modules/list/vscode.md#zhuangtongfa-material-theme).

In this case, you must override the the `workbench.colorTheme` settings.

If you prefer to change to another dark theme like [Better Solarized Dark](../modules/list/vscode.md#ginfuru-ginfuru-better-solarized-dark-theme):

```yaml
vscode-anywhere:
  vscode:
    settings:
      "workbench.colorTheme": "Better Solarized Dark"
```

The [vscode](../modules/list/vscode.md#installation) module also installs light theme: [Ysgrifennwr](../modules/list/vscode.md#xaver-theme-ysgrifennwr) and [Better Solarized Light](../modules/list/vscode.md#ginfuru-ginfuru-better-solarized-dark-theme).

If want to change to [Ysgrifennwr](../modules/list/vscode.md#xaver-theme-ysgrifennwr) theme:

```yaml
vscode-anywhere:
  vscode:
    settings:
      "workbench.colorTheme": "Ysgrifennwr"
```

Or if you prefer [Better Solarized Light](../modules/list/vscode.md#ginfuru-ginfuru-better-solarized-dark-theme):

```yaml
vscode-anywhere:
  vscode:
    settings:
      "workbench.colorTheme": "Better Solarized Light"
```

### Custom theme

If the [vscode](../modules/list/vscode.md#installation) module **is** `enabled`, in this case, you must configure your own theme in the **vscode** section to override the settings:

```yaml
vscode-anywhere:
  vscode:
    settings:
      "workbench.colorTheme": "myCustomTheme"
```

If the [vscode](../modules/list/vscode.md#installation) module **is not** `enabled`, in this case, you can configure your own theme in the **custom** section:

```yaml
vscode-anywhere:
  custom:
    settings:
      "workbench.colorTheme": "myCustomTheme"
```

{% hint style="info" %}
Change `myCustomTheme` by the theme to use.
{% endhint %}

For more information, please [read the documentation](https://code.visualstudio.com/docs/getstarted/themes#_selecting-the-color-theme).

## Change the default icon theme

All following examples must be set in in the [vscode-anywhere.sls](../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file and after editing this file you have to run the [installation script](../structure/tools/install.md).

### Preconfigured icon theme

If the [vscode](../modules/list/vscode.md#installation) module is `enabled`, the default icon theme is set to [vscode-icons](../modules/list/vscode.md#vscode-icons-team-vscode-icons).

### Custom icon theme

If the [vscode](../modules/list/vscode.md#installation) module **is** `enabled`, in this case, you must configure your own icon theme in the **vscode** section to override the settings:

```yaml
vscode-anywhere:
  vscode:
    settings:
      "workbench.iconTheme": "myCustomIconTheme"
```

If the [vscode](../modules/list/vscode.md#installation) module **is not** `enabled`, in this case, you can configure your own icon theme in the **custom** section:

```yaml
vscode-anywhere:
  custom:
    settings:
      "workbench.iconTheme": "myCustomIconTheme"
```

{% hint style="info" %}
Change `myCustomIconTheme` by the icon theme to use.
{% endhint %}

For more information, please [read the documentation](https://code.visualstudio.com/docs/getstarted/themes#_file-icon-themes).

