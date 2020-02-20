{%- from 'salt/modules/ruby/map.jinja' import ruby with context %}


include:
  - salt/modules/ruby/install


{%- set options = ruby.gem.opts.global %}
{%- do options.update(ruby.gem.opts.uninstall) %}

{%- for pkg, pkg_attr in ruby.gem.pkgs.items() | reverse %}
      {%- set options_tmp = salt['defaults.deepcopy'](options) %}
      {%- do options_tmp.update(pkg_attr.opts.uninstall) %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(pkg) }}:
  gem.removed:
    - name: {{ pkg }}
    {%- for opt, opt_attr in options_tmp.items() %}
    - {{ opt }}: {{ opt_attr }}
    {%- endfor %}
    - require:
      - sls: salt/modules/ruby/install
{%- endfor %}