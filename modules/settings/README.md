---
description: How to configure a VSCode-Anywhere module
---

# Module settings

All VSCode-Anywhere modules can be configured to override the default installation behavior, add new settings, VSCode plugins, documentation, pakages, etc…

To configure a module, you need to edit the file VSCode-[Anywhere/conf/saltstack/pillar/vscode-anywhere.sls](../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls).

Each module is disabled by default and supports additional global and specific settings.

To enable a module, please read the [module installation](../install.md).

There are 2 types of settings: [global settings](global/) or specific settings.

Glocal settings can be applied to all modules whereas specific settings depend on each module.

Please read the documentation of the [module](https://vscode-anywhere.readthedocs.io/en/dev/modules/index.html#modules) concerned in order to know if it supports **specific settings** like `python3` for example \(`pip` settings in this example\):

```yaml
python3:
    enabled: True
    anaconda: True
    pip:
        pkgs:
            autopep8:
                enabled: True
                version: '1.4.3'
```

After editing the configuration file, don’t forget to apply the new settings. You need to run the [install](../../structure/tools/install.md) file.

Note that [vscode-anywhere.sls](../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file supports [jinja2](https://jinja.palletsprojects.com). See the [jinja Saltsatck documentation](https://docs.saltstack.com/en/latest/topics/jinja/index.html).

Same example with jinja that allows to install **autopep8** **only on Linux**:

```yaml
python3:
    enabled: True
    anaconda: True
{%- if grains['os'] == 'Linux' %}
    pip:
        pkgs:
            autopep8:
                enabled: True
                version: '1.4.3'
{%- endif %}
```

