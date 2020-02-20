{%- from 'salt/modules/javascript/map.jinja' import javascript with context %}


{%- if javascript.enabled %}
include:
  - salt/modules/javascript/install


# Needed by the windows_portable profile
{{ salt['vscode_anywhere.get_id'](sls) + ':prefix' }}:
  file.replace:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'nodejs', 'current', 'node_modules', 'npm', 'npmrc') }}
    - pattern: 'prefix=.*'
    - repl: 'prefix={{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'persist', 'nodejs', 'bin') | json | replace('"', '') }}'
    - backup: False
    - require:
      - sls: salt/modules/javascript/install


# Needed by the windows_portable profile
{{ salt['vscode_anywhere.get_id'](sls) + ':cache' }}:
  file.replace:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'nodejs', 'current', 'node_modules', 'npm', 'npmrc') }}
    - pattern: 'cache=.*'
    - repl: 'cache={{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'persist', 'nodejs', 'cache') | json | replace('"', '') }}'
    - backup: False
    - require:
      - sls: salt/modules/javascript/install


  {%- set options = javascript.npm.opts.global %}
  {%- do options.update(javascript.npm.opts.install) %}

  {%- for pkg, pkg_attr in javascript.npm.pkgs.items() %}
    {%- if pkg_attr.get('enabled') %}
      {%- set options_tmp = salt['defaults.deepcopy'](options) %}
      {%- do options_tmp.update(pkg_attr.opts.install) %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(pkg) }}:
  npm.installed:
    {%- if pkg_attr.get('version') %}
    - name: {{ pkg }}@{{ pkg_attr.get('version') }}
    {%- else %}
    - name: {{ pkg }}
    {%- endif %}
    {%- for opt, opt_attr in options_tmp.items() %}
    - {{ opt }}: {{ opt_attr }}
    {%- endfor %}
    - require:
      - sls: salt/modules/javascript/install
    {%- endif %}
  {%- endfor %}
{%- endif %}