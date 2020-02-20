{%- from 'salt/modules/javascript/map.jinja' import javascript with context %}


include:
  - salt/modules/javascript/install


{%- set options = javascript.npm.opts.global %}
{%- do options.update(javascript.npm.opts.uninstall) %}

{%- for pkg, pkg_attr in javascript.npm.pkgs.items() %}
  {%- set options_tmp = salt['defaults.deepcopy'](options) %}
  {%- do options_tmp.update(pkg_attr.opts.uninstall) %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(pkg) }}:
  npm.removed:
    - name: {{ pkg }}
  {%- for opt, opt_attr in options_tmp.items() %}
    - {{ opt }}: {{ opt_attr }}
  {%- endfor %}
    - require:
      - sls: salt/modules/javascript/install
{%- endfor %}