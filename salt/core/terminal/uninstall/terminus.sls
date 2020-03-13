{%- from 'salt/core/terminal/map.jinja' import terminal with context %}


{{ salt['vscode_anywhere.get_id'](sls) + ':terminus:config.yaml' }}:
  file.absent:
    - name: {{ salt['file.dirname'](terminal.config_path) }}


{%- if salt['grains.get']('kernel') == 'Windows' %}

{{ salt['vscode_anywhere.get_id'](sls) + ':terminus:shortcut' }}:
  file.absent:
    - name: {{ salt['grains.get']('vscode-anywhere:path') | path_join('Terminal.lnk') }}

{%- else %}

{{ salt['vscode_anywhere.get_id'](sls) + ':zsh:zshrc' }}:
  file.absent:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.zshrc') }}


{{ salt['vscode_anywhere.get_id'](sls) + ':zsh:fast-syntax-highlighting:theme:vscode-anywhere' }}:
  file.absent:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.fsh', 'vscode-anywhere.ini') }}


{{ salt['vscode_anywhere.get_id'](sls) + ':zsh:oh-my-zsh' }}:
  file.absent:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.oh-my-zsh') }}


{#-
{{ salt['vscode_anywhere.get_id'](sls) + ':fonts:powerline' }}:
  file.absent:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'fonts', 'powerline') }}


{{ salt['vscode_anywhere.get_id'](sls) + ':tmux.conf' }}:
  file.absent:
    # - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('linuxbrew', '.linuxbrew', 'etc', 'tmux.conf') }}
    - name: /home/linuxbrew/.linuxbrew/etc/tmux.conf
#}
{%- endif %}