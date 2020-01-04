{{ salt['vscode_anywhere.get_id'](sls) }}:
  cmd.run:
    - name: reg export HKCU\Environment $env:TMP\VSCode-Anywhere.reg -y
    - shell: powershell