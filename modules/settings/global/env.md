# env settings

Allow to add enironment variables in VSCode-Anywhere.

Simple example, in the [vscode-anywhere.sls](../../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file to ask to the `python3`module to add some variables in the [env](../../../structure/tools/env.md) file:

```yaml
vscode-anywhere:
    python3:
        enabled: True
        env:
            PATH: /mypath/bin
            PYTHONPATH: /mypythonpath/lib
```

{% hint style="success" %}
`PATH` variable is a specific variable that **append** in this case`/mypath/bin` to the `PATH` variable. Other variables will be **replaced**. `PYTHONPATH` will be set to `/mypythonpath/lib`.
{% endhint %}

