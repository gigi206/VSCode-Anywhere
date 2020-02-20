{%- from 'salt/modules/ruby/map.jinja' import ruby with context %}


{%- if ruby.enabled %}
include:
  - salt/modules/ruby/install

  {%- set options = ruby.gem.opts.global %}
  {%- do options.update(ruby.gem.opts.install) %}

  {%- for pkg, pkg_attr in ruby.gem.pkgs.items() %}
    {%- if pkg_attr.get('enabled') %}
      {%- set options_tmp = salt['defaults.deepcopy'](options) %}
      {%- do options_tmp.update(pkg_attr.opts.install) %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(pkg) }}:
  gem.installed:
    - name: {{ pkg }}
    {%- for opt, opt_attr in options_tmp.items() %}
    - {{ opt }}: {{ opt_attr }}
    {%- endfor %}
    - require:
      - sls: salt/modules/ruby/install
    {%- endif %}
  {%- endfor %}
{%- endif %}