{%- from 'salt/modules/php/map.jinja' import php with context %}


{%- if php.enabled %}
include:
  - salt/modules/php/install


{%- set options = php.composer.opts.global %}
{%- do options.update(php.composer.opts.get('update')) %}

{{ salt['vscode_anywhere.get_id'](sls) + ':update' }}:
  composer.update:
    - name: {{ salt['file.dirname'](php.composer.json) }}
  {%- for opt, opt_attr in options.items() %}
    - {{ opt }}: {{ opt_attr }}
  {%- endfor %}
    - require:
      - sls: salt/modules/php/install
{%- endif %}