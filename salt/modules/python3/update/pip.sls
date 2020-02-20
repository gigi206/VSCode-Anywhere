{%- from 'salt/modules/python3/map.jinja' import python3 with context %}


{%- if python3.enabled %}
include:
  - salt/modules/python3/install


  {%- set options = python3.pip.opts.global %}
  {%- do options.update(python3.pip.opts.get('update')) %}

  {%- for pkg, pkg_attr in python3.pip.pkgs.items() %}
    {%- if pkg_attr.get('enabled') %}
      {%- set options_tmp = salt['defaults.deepcopy'](options) %}
      {%- do options_tmp.update(pkg_attr.opts.get('update')) %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(pkg) }}:
  pip.installed:
    {%- if pkg_attr.get('version') %}
    # https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pip_state.html#salt.states.pip_state.installed
    - name: {{ pkg }} {{ pkg_attr.get('version') }}
    {%- else %}
    - name: {{ pkg }}
    {%- endif %}
    {%- for opt, opt_attr in options_tmp.items() %}
    - {{ opt }}: {{ opt_attr }}
    {%- endfor %}
    - require:
      - sls: salt/modules/python3/install
    {%- endif %}
  {%- endfor %}
{%- endif %}