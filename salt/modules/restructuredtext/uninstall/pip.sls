{%- from 'salt/modules/restructuredtext/map.jinja' import restructuredtext with context %}
{%- from 'salt/modules/python3/map.jinja' import python3 with context %}


include:
  - salt/modules/python3/install


{%- set options = restructuredtext.pip.opts.global %}
{%- do options.update(restructuredtext.pip.opts.uninstall) %}

{%- for pkg, pkg_attr in restructuredtext.pip.pkgs.items() %}
  {%- if pkg != 'pip'  %}
    {%- set options_tmp = salt['defaults.deepcopy'](options) %}
    {%- do options_tmp.update(pkg_attr.opts.uninstall) %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(pkg) }}:
  pip.removed:
    - name: {{ pkg }}
    {%- for opt, opt_attr in options_tmp.items() %}
    - {{ opt }}: {{ opt_attr }}
    {%- endfor %}
    - require:
      - sls: salt/modules/python3/install
  {%- endif %}
{%- endfor %}