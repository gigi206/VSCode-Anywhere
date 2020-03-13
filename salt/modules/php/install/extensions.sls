{%- from 'salt/modules/php/map.jinja' import php with context %}


{%- if php.enabled %}
include:
  - salt/modules/php/install


{%- for extension in php.extensions %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(extension) }}:
  file.managed:
    - name: {{ php.extension_dir | path_join('{}.ini'.format(extension)) }}
    - contents: |
        [PHP]
        extension={{ extension }}
    - require:
      - sls: salt/modules/php/install
{%- endfor %}

{%- endif %}