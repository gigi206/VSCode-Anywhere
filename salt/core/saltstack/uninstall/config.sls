
{%- from 'salt/core/saltstack/map.jinja' import saltstack with context %}


{{ salt['vscode_anywhere.get_id'](sls) }}:
  file.absent:
    - name: {{ saltstack.config_path }}