Set-ExecutionPolicy Bypass -Scope Process -Force
Set-Location "${PSScriptRoot}"

. "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:tools:env')) }}"
& "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:apps:path')) }}\scoop\apps\zeal\current\zeal.exe" $Args