{%- from 'salt/core/vscode/map.jinja' import vscode with context %}


{{ salt['vscode_anywhere.get_id'](sls) }}:
  file.absent:
    - name: {{ vscode.locale_path }}