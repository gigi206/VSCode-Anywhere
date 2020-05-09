# zeal settings

Allow to manage [Zeal](https://zealdocs.org) docsets \(documentation\).

## docksets

Docsets allow to install:

* **Windows / Linux**: [Zeal](https://zealdocs.org/) docsets
* **MacOS**: [Dash](https://kapeli.com/dash) docsets

You can view all docsets at:

* [https://github.com/Kapeli/feeds](https://github.com/Kapeli/feeds)
* [https://github.com/Kapeli/Dash-User-Contributions/tree/master/docsets](https://github.com/Kapeli/Dash-User-Contributions/tree/master/docsets)

Simple example, in the [vscode-anywhere.sls](../../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file to ask to the `python3`module to install the Zeal docsets:

* [Python\_3](https://github.com/Kapeli/feeds/blob/master/Python_3.xml)
* [PEPs](https://github.com/Kapeli/Dash-User-Contributions/tree/master/docsets/PEPs)

```yaml
vscode-anywhere:
    python3:
        enabled: True
        zeal:
            docsets:
                Python_3:
                    enabled: True
                PEPs:
                    enabled: True
```

### enabled

`True` to `enable`, `False` to skip \(default to `False`\).

