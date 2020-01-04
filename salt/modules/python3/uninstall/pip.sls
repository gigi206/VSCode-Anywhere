{%- from 'salt/modules/python3/map.jinja' import python3 with context %}


include:
  - salt/modules/python3/install


{%- set options = python3.pip.opts.global %}
{%- do options.update(python3.pip.opts.uninstall) %}

{%- for pkg, pkg_attr in python3.pip.pkgs.items() %}
  {%- if pkg != 'pip'  %}
    {%- do options.update(pkg_attr.opts.uninstall) %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(pkg) }}:
  pip.removed:
    - name: {{ pkg }}
    {%- for opt, opt_attr in options.items() %}
    - {{ opt }}: {{ opt_attr }}
    {%- endfor %}
    - require:
      - sls: salt/modules/python3/install
  {%- endif %}
{%- endfor %}