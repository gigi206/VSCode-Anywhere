{%- from 'salt/modules/php/map.jinja' import php with context %}


{%- if php.enabled %}
include:
  - salt/modules/php/install


  {%- set options = php.pecl.opts.global %}
  {%- do options.update(php.pecl.opts.install) %}

  {%- for ext, ext_attr in php.pecl.pkgs.items() %}
    {%- if ext_attr.get('enabled') %}
      {%- set options_tmp = salt['defaults.deepcopy'](options) %}
      {%- do options_tmp.update(ext_attr.opts.install) %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(ext) }}:
  pecl.installed:
    # https://docs.saltstack.com/en/master/ref/states/all/salt.states.pecl.html
    - name: {{ ext }}
    {%- if ext_attr.get('version') %}
    - force: True
    {%- endif %}
    {%- for opt, opt_attr in options_tmp.items() %}
    - {{ opt }}: {{ opt_attr }}
    {%- endfor %}
    - require:
      - sls: salt/modules/php/install
    {%- endif %}
  {%- endfor %}

{%- endif %}