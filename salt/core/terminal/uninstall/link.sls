{{ salt['vscode_anywhere.get_id'](sls) + ':icon' }}:
  file.absent:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'icons', 'terminal.png') }}


{{ salt['vscode_anywhere.get_id'](sls) + ':shortcut:user' }}:
  file.absent:
    - name: {{ salt['user.info'](salt['grains.get']('username'))['home'] | path_join('.local', 'share','applications', 'Terminal.desktop') }}


{{ salt['vscode_anywhere.get_id'](sls) + ':shortcut' }}:
  file.absent:
    - name: {{ salt['grains.get']('vscode-anywhere:path') | path_join('Terminal.desktop') }}
    # - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'shortcuts', 'Terminal.desktop') }}