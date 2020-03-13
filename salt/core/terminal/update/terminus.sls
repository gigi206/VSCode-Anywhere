{%- from 'salt/core/terminal/map.jinja' import terminal with context %}

{%- if terminal.enabled %}
include:
  - salt/core/terminal/install


{%- if salt['grains.get']('kernel') != 'Windows' %}
{{ salt['vscode_anywhere.get_id'](sls) + ':oh-my-zsh' }}:
  git.latest:
    - name: https://github.com/robbyrussell/oh-my-zsh.git
    - target: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.oh-my-zsh') }}
    - branch: master
    - rev: master
    - force_checkout: True
    - force_fetch: True
    - force_clone: True
    - force_reset: True


{{ salt['vscode_anywhere.get_id'](sls) + ':fast-syntax-highlighting' }}:
  git.latest:
    - name: https://github.com/zdharma/fast-syntax-highlighting.git
    - target: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.oh-my-zsh', 'custom', 'plugins', 'fast-syntax-highlighting') }}
    - branch: master
    - rev: master
    - force_checkout: True
    - force_fetch: True
    - force_clone: True
    - force_reset: True


{{ salt['vscode_anywhere.get_id'](sls) + ':zsh-autosuggestions' }}:
  git.latest:
    - name: https://github.com/zsh-users/zsh-autosuggestions.git
    - target: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.oh-my-zsh', 'custom', 'plugins', 'zsh-autosuggestions') }}
    - branch: master
    - rev: master
    - force_checkout: True
    - force_fetch: True
    - force_clone: True
    - force_reset: True


{#-
{{ salt['vscode_anywhere.get_id'](sls) + ':fonts:powerline' }}:
  git.latest:
    - name: https://github.com/powerline/fonts.git
    - target: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'fonts', 'powerline') }}
    - branch: master
    - rev: master
    - force_checkout: True
    - force_fetch: True
    - force_clone: True
    - force_reset: True


{{ salt['vscode_anywhere.get_id'](sls) + ':fonts:powerline:RobotoMono' }}:
  cmd.run:
    - names:
      - cp {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'fonts', 'powerline', 'RobotoMono', '*ttf') }} {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.local', 'share', 'fonts') }}
      - fc-cache -f {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.local', 'share', 'fonts') }}
    - onchanges:
      - id: {{ salt['vscode_anywhere.get_id'](sls) + ':fonts:powerline' }}
#}
{%- endif %}
{%- endif %}