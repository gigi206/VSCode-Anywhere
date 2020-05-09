# Tutorials

## Replace VSCodium by VSCode

\*\*\*\*[VSCodium](https://vscodium.com) is installed by default. If you prefer use [vscode](https://code.visualstudio.com) instead then set `vscodium` to `False` inside the `vscode_core` section in the file [vscode-anywhere.sls](structure/conf/saltstack/pillar.md#vscode-anywhere-sls):

```yaml
vscode-anywhere:
    vscode_core:
        vscodium: False
```

After that you have just to run the [installation script](structure/tools/install.md) again.  


