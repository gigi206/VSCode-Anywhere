{%- from 'salt/core/saltstack/map.jinja' import saltstack with context %}

{%- if saltstack.enabled %}
{{ salt['vscode_anywhere.get_id'](sls) }}:
  file.managed:
    - name: {{ saltstack.config_path }}
    - template: jinja
    - backup: False
    - contents: |
        {{ saltstack.config | yaml(False) | indent(8) }}
{%- endif %}
