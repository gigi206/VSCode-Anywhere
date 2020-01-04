{%- from 'salt/modules/python2/map.jinja' import python2 with context %}


{%- if python2.enabled %}
include:
  - salt/modules/python2/install

  {%- set options = python2.pip.opts.global %}
  {%- do options.update(python2.pip.opts.get('update')) %}

  {%- for pkg, pkg_attr in python2.pip.pkgs.items() %}
    {%- if pkg_attr.get('enabled') %}
      {%- do options.update(pkg_attr.opts.get('update')) %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(pkg) }}:
  pip.installed:
    {%- if pkg_attr.get('version') %}
    # https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pip_state.html#salt.states.pip_state.installed
    - name: {{ pkg }} {{ pkg_attr.get('version') }}
    {%- else %}
    - name: {{ pkg }}
    {%- endif %}
  {%- for opt, opt_attr in options.items() %}
    - {{ opt }}: {{ opt_attr }}
  {%- endfor %}
    - require:
      - sls: salt/modules/python2/install
    {%- endif %}
  {%- endfor %}
{%- endif %}