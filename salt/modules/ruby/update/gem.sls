{%- from 'salt/modules/ruby/map.jinja' import ruby with context %}


{%- if ruby.enabled %}
include:
  - salt/modules/ruby/install


  {%- set updates = salt['gem.list_upgrades'](gem_bin=ruby.gem.opts.global.gem_bin) %}
  {%- set options = ruby.gem.opts.global %}
  {%- do options.update(ruby.gem.opts.get('update')) %}

  {%- for pkg, pkg_attr in ruby.gem.pkgs.items() %}
    {%- if pkg_attr.get('enabled' and pkg in updates) %}
      {%- set options_tmp = salt['defaults.deepcopy'](options) %}
      {%- do options_tmp.update(pkg_attr.opts.get('update')) %}
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