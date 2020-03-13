{%- from 'salt/core/brew/map.jinja' import brew with context %}


{%- if brew.enabled and salt['grains.get']('kernel') != 'Windows' %}
{{ salt['vscode_anywhere.get_id'](sls) + ':/home/linuxbrew/.linuxbrew/bin' }}:
  file.directory:
    - name: /home/linuxbrew/.linuxbrew/bin
    - makedirs: True
    - dir_mode: 755


{{ salt['vscode_anywhere.get_id'](sls) + ':git:clone' }}:
  git.cloned:
    - name: https://github.com/Homebrew/brew.git
    - target: /home/linuxbrew/.linuxbrew/Homebrew
    - branch: master


{{ salt['vscode_anywhere.get_id'](sls) + ':/home/linuxbrew/.linuxbrew/bin/brew' }}:
  file.symlink:
    - name: /home/linuxbrew/.linuxbrew/bin/brew
    - target: /home/linuxbrew/.linuxbrew/Homebrew/bin/brew
    - force: True
    - makedirs: True
    - mode: 755
{%- endif %}