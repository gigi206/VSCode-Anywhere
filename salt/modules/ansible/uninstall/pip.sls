{%- from 'salt/modules/ansible/map.jinja' import ansible with context %}
{%- from 'salt/modules/python3/map.jinja' import python3 with context %}


include:
  - salt/modules/python3/install


{%- set options = ansible.pip.opts.global %}
{%- do options.update(ansible.pip.opts.uninstall) %}

{%- for pkg, pkg_attr in ansible.pip.pkgs.items() %}
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