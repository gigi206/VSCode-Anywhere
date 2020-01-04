{%- from 'salt/modules/python2/map.jinja' import python2 with context %}


include:
  - salt/modules/python2/install


{%- set options = python2.pip.opts.global %}
{%- do options.update(python2.pip.opts.uninstall) %}

{%- for pkg, pkg_attr in python2.pip.pkgs.items() %}
  {%- if pkg != 'pip'  %}
    {%- do options.update(pkg_attr.opts.uninstall) %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(pkg) }}:
  pip.removed:
    - name: {{ pkg }}
    {%- for opt, opt_attr in options.items() %}
    - {{ opt }}: {{ opt_attr }}
    {%- endfor %}
    - require:
      - sls: salt/modules/python2/install
  {%- endif %}
{%- endfor %}