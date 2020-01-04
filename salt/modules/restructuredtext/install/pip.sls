{%- from 'salt/modules/restructuredtext/map.jinja' import restructuredtext with context %}
{%- from 'salt/modules/python3/map.jinja' import python3 with context %}


{%- if python3.enabled and restructuredtext.enabled %}

include:
  - salt/modules/python3/install

  {%- set options = restructuredtext.pip.opts.global %}
  {%- do options.update(restructuredtext.pip.opts.install) %}

  {%- for pkg, pkg_attr in restructuredtext.pip.pkgs.items() %}
    {%- if pkg_attr.get('enabled') %}
      {%- do options.update(pkg_attr.opts.install) %}
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
      - sls: salt/modules/python3/install
    {%- endif %}
  {%- endfor %}
{%- else %}
{{ salt['vscode_anywhere.get_id'](sls) + ':require:python3' }}:
  test.configurable_test_state:
    - name: python3
    - changes: False
    - result: False
    - comment: python3 must be set to enabled for installing restructuredtext
{%- endif %}