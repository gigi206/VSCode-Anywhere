{%- from 'salt/core/brew/map.jinja' import brew with context %}

{%- if brew.enabled and salt['grains.get']('kernel') != 'Windows' %}
{{ salt['vscode_anywhere.get_id'](sls) + ':env.sls' }}:
  file.append:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:env') }}
    - makedirs: True
    - text:
      - test -f /home/linuxbrew/.linuxbrew/bin/brew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
{%- endif %}