{{ salt['vscode_anywhere.get_id'](sls) + ':install' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('install.ps1') }}
    - source: salt://salt/utils/tools/files/install.ps1
    - template: jinja
    - backup: False


{{ salt['vscode_anywhere.get_id'](sls) + ':update' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('update.ps1') }}
    - source: salt://salt/utils/tools/files/update.ps1
    - template: jinja
    - backup: False


{{ salt['vscode_anywhere.get_id'](sls) + ':vscode' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('vscode.ps1') }}
    - source: salt://salt/utils/tools/files/vscode.ps1
    - template: jinja
    - backup: False


{{ salt['vscode_anywhere.get_id'](sls) + ':vscode-anywhere' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('vscode-anywhere.ps1') }}
    - source: salt://salt/utils/tools/files/vscode-anywhere.ps1
    - template: jinja
    - makedirs: True
    - backup: False


{{ salt['vscode_anywhere.get_id'](sls) + ':link' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('link.ps1') }}
    - source: salt://salt/utils/tools/files/link.ps1
    - template: jinja
    - makedirs: True
    - backup: False


{{ salt['vscode_anywhere.get_id'](sls) + ':terminal' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('terminal.ps1') }}
    - source: salt://salt/utils/tools/files/terminal.ps1
    - template: jinja
    - makedirs: True
    - backup: False