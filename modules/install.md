---
description: Activate a VSCode-Anywhere module
---

# Module installation

To install a VSCode-Anywhere module, you must edit the file [`VSCode-Anywhere/conf/saltstack/pillar/vscode-anywhere.sls`](../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) in your installation directory and and change the `enabled` key of the module you wish to activate by changing its value from `False` to `True`.

Example for the `python3` module:

```yaml
vscode-anywhere:
    python3:
        enabled: True
```

After that, you must run the [installation script](../structure/tools/install.md).

VSCode-Anywhere uses [Saltstack](https://www.saltstack.com) which will compute all the differences to be applied to your current installation for all the modules you have activated.

