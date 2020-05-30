# Tutorials

## Replace VSCode by VSCodium

 [VSCode](https://code.visualstudio.com) ****is installed by default. If you prefer use [VSCodium](https://vscodium.com) instead then set `vscodium` to `True` inside the `vscode_core` section in the [vscode-anywhere.sls](structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file:

```yaml
vscode-anywhere:
    vscode_core:
        vscodium: True
```

After that you have just to run the [installation script](structure/tools/install.md) again.

