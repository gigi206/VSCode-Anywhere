{{ salt['vscode_anywhere.get_id'](sls) }}:
  cmd.run:
    - name: reg import $env:TMP\VSCode-Anywhere.reg
    - shell: powershell
    - order: last