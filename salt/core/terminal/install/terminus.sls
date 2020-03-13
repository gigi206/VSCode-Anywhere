{%- from 'salt/core/terminal/map.jinja' import terminal with context %}


{%- if terminal.enabled %}
include:
  # - salt/utils/sync
  - salt/core/terminal/install


{%- if salt['grains.get']('kernel') == 'Linux' %}
{{ salt['vscode_anywhere.get_id'](sls) + ':formula' }}:
  file.managed:
    - name: /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/homebrew/homebrew-core/Formula/terminus.rb
    - source: salt://salt/core/terminal/files/terminus.rb
    - backup: False
    - require_in:
      - pkg: terminus
{%- endif %}


{{ salt['vscode_anywhere.get_id'](sls) + ':terminus:config.yaml' }}:
  file.managed:
    - name: {{ terminal.config_path }}
    - source: salt://salt/core/terminal/templates/terminus.yaml
    - template: jinja
    - makedirs: True
    - backup: False


{%- if salt['grains.get']('kernel') != 'Windows' %}
{{ salt['vscode_anywhere.get_id'](sls) + ':zsh:zshrc' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.zshrc') }}
    - source: salt://salt/core/terminal/files/zshrc
    - makedirs: True
    - mode: 644
    - backup: False


{{ salt['vscode_anywhere.get_id'](sls) + ':zsh:oh-my-zsh' }}:
  git.cloned:
    - name: https://github.com/robbyrussell/oh-my-zsh.git
    - target: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.oh-my-zsh') }}
    - branch: master


{{ salt['vscode_anywhere.get_id'](sls) + ':zsh:vscode-anywhere.zsh-theme' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.oh-my-zsh', 'custom', 'themes', 'vscode-anywhere.zsh-theme') }}
    - source: salt://salt/core/terminal/files/vscode-anywhere.zsh-theme
    - mode: 644
    - backup: False
    - require:
      - id: {{ salt['vscode_anywhere.get_id'](sls) + ':zsh:oh-my-zsh' }}


{{ salt['vscode_anywhere.get_id'](sls) + ':zsh:custom:vscode-anywhere' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.oh-my-zsh', 'custom', 'vscode-anywhere.zsh') }}
    - source: salt://salt/core/terminal/files/vscode-anywhere.zsh
    - mode: 644
    - backup: False
    - require:
      - id: {{ salt['vscode_anywhere.get_id'](sls) + ':zsh:oh-my-zsh' }}


{{ salt['vscode_anywhere.get_id'](sls) + ':zsh:fast-syntax-highlighting' }}:
  git.cloned:
    - name: https://github.com/zdharma/fast-syntax-highlighting.git
    - target: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.oh-my-zsh', 'custom', 'plugins', 'fast-syntax-highlighting') }}
    - branch: master
    - require:
      - id: {{ salt['vscode_anywhere.get_id'](sls) + ':zsh:oh-my-zsh' }}


{{ salt['vscode_anywhere.get_id'](sls) + 'zsh:zsh-autosuggestions' }}:
  git.cloned:
    - name: https://github.com/zsh-users/zsh-autosuggestions.git
    - target: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.oh-my-zsh', 'custom', 'plugins', 'zsh-autosuggestions') }}
    - branch: master
    - require:
      - id: {{ salt['vscode_anywhere.get_id'](sls) + ':zsh:oh-my-zsh' }}


{{ salt['vscode_anywhere.get_id'](sls) + ':zsh:fast-syntax-highlighting:theme:vscode-anywhere' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.fsh', 'vscode-anywhere.ini') }}
    - source: salt://salt/core/terminal/files/vscode-anywhere.ini
    - makedirs: True
    - mode: 644
    - backup: False
    - require:
      - id: {{ salt['vscode_anywhere.get_id'](sls) + ':zsh:fast-syntax-highlighting' }}


{{ salt['vscode_anywhere.get_id'](sls) + ':zsh:fast-syntax-highlighting:theme:vscode-anywhere:apply' }}:
  cmd.wait:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.nix-profile', 'bin', 'zsh') }} -c ". ~/.zshrc && fast-theme HOME:vscode-anywhere"
    - env:
      - HOME: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home') }}
    - watch:
      - file: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.fsh', 'vscode-anywhere.ini') }}
    - require:
      - nix: nixpkgs.zsh


{#-
{{ salt['vscode_anywhere.get_id'](sls) + ':fonts:powerline' }}:
  git.cloned:
    - name: https://github.com/powerline/fonts.git
    - target: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'fonts', 'powerline') }}
    - branch: master


{{ salt['vscode_anywhere.get_id'](sls) + ':fonts:powerline:RobotoMono' }}:
  cmd.run:
    - names:
      - mkdir -p {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.local', 'share', 'fonts') }}
      - cp {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'fonts', 'powerline', 'RobotoMono', '*ttf') }} {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.local', 'share', 'fonts') }}
      - fc-cache -f {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.local', 'share', 'fonts') }}
    - onchanges:
      - id: {{ salt['vscode_anywhere.get_id'](sls) + ':fonts:powerline' }}


{{ salt['vscode_anywhere.get_id'](sls) + ':tmux.conf' }}:
  file.managed:
    # - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('linuxbrew', '.linuxbrew', 'etc', 'tmux.conf') }}
    - name: /homelinuxbrew/.linuxbrew/etc/tmux.conf
    - source: salt://salt/core/terminal/templates/tmux.conf
    - mode: 644
    - backup: False
#}
{%- endif %}
{%- endif %}