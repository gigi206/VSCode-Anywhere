{%- from 'salt/core/vscode/map.jinja' import vscode with context %}


{%- if vscode.enabled %}
include:
  - salt/core/vscode/install


{{ salt['vscode_anywhere.get_id'](sls) }}:
  file.managed:
    - name: {{ vscode.locale_path }}
    - contents: |
        {
         "locale": "{{ vscode.locale }}"
        }
    - makedirs: True
    - backup: False
    - require:
      - sls: salt/core/vscode/install
{%- endif %}