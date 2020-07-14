# env settings

Allow adding environment variables in VSCode-Anywhere.

A simple example, in the [vscode-anywhere.sls](../../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file to ask to add some variables in the [env](../../../structure/tools/env.md) file in `python3`module :

```yaml
vscode-anywhere:
    python3:
        enabled: True
        env:
            PATH: /mypath/bin
            PYTHONPATH: /mypythonpath/lib
```

{% hint style="success" %}
`PATH` variable is a specific variable that **appends** in this case`/mypath/bin` to the `PATH` variable. Other variables will be **replaced**. `PYTHONPATH` will be set to `/mypythonpath/lib`.
{% endhint %}

