{%- from 'salt/modules/puppet/map.jinja' import puppet with context %}
{%- from 'salt/modules/ruby/map.jinja' import ruby with context %}


{%- if not ruby.enabled %}
{{ salt['vscode_anywhere.get_id'](sls) + ':require:ruby' }}:
  test.configurable_test_state:
    - name: ruby
    - changes: False
    - result: False
    - comment: ruby must be set to enabled for installing puppet
{%- endif %}


{%- if ruby.enabled and puppet.enabled %}
include:
  - salt/modules/ruby/install


  {%- set options = puppet.gem.opts.global %}
  {%- do options.update(puppet.gem.opts.install) %}

  {%- for pkg, pkg_attr in puppet.gem.pkgs.items() %}
    {%- if pkg_attr.get('enabled') %}
      {%- do options.update(pkg_attr.opts.install) %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(pkg) }}:
  gem.installed:
    - name: {{ pkg }}
  {%- for opt, opt_attr in options.items() %}
    - {{ opt }}: {{ opt_attr }}
  {%- endfor %}
    - require:
      - sls: salt/modules/ruby/install
    {%- endif %}
  {%- endfor %}
{%- endif %}