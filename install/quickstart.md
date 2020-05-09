# Quickstart

## Windows

Open a powershell console and enter the following command:

{% tabs %}
{% tab title="Powershell" %}
```text
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-WebRequest -Uri https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/V2/VSCode-Anywhere.ps1 -OutFile $env:TMP\VSCode-Anywhere.ps1; & $env:TMP\VSCode-Anywhere.ps1 -Gitenv V2
```
{% endtab %}
{% endtabs %}

Now you can click on `VSCode-Anywhere` in the `C:\VSCode-Anywhere` directory.

For more information, please read the full Windows documentation for more details.

## Linux

Open a terminal and enter the following command:

```bash
bash <(curl -sL https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/V2/VSCode-Anywhere.sh)
```

VSCode-Anywhere will be install in `~/VSCode-Anywhere`.

For more information, please read the full Linux documentation for more details.

## MacOS

In the future...

