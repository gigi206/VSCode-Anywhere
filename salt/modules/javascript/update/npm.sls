{%- from 'salt/modules/javascript/map.jinja' import javascript with context %}


{%- if javascript.enabled %}
include:
  - salt/modules/javascript/install


  {%- set options = javascript.npm.opts.global %}
  {%- do options.update(javascript.npm.opts.get('update')) %}

  {%- for pkg, pkg_attr in javascript.npm.pkgs.items() %}
    {%- if pkg_attr.get('enabled') %}
      {%- do options.update(pkg_attr.opts.get('update')) %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(pkg) }}:
  npm.installed:
    {%- if pkg_attr.get('version') %}
    - name: {{ pkg }}@{{ pkg_attr.get('version') }}
    {%- else %}
    - name: {{ pkg }}@{{ salt['cmd.run']('{} -g show {} version'.format(javascript.npm_bin, pkg)) }}
    {%- endif %}
  {%- for opt, opt_attr in options.items() %}
    - {{ opt }}: {{ opt_attr }}
  {%- endfor %}
    - require:
      - sls: salt/modules/javascript/install
    {%- endif %}
  {%- endfor %}
{%- endif %}