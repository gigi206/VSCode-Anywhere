{%- from 'salt/modules/ruby/map.jinja' import ruby with context %}


{%- if ruby.enabled and salt['grains.get']('kernel') != 'Windows' %}
include:
  - salt/modules/ruby/install


{%- for pkg, pkg_attr in ruby.brew_gem.items() %}
  {%- if pkg_attr.get('enabled') and not pkg_attr.get('version') %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(pkg) }}:
  cmd.run:
    - name: brew gem update {{ pkg }}
    - require:
      - sls: salt/modules/ruby/install
    - onlyif:
      - test $(brew gem info {{ pkg }} --json | jq ".[].outdated") = 'true'
  {%- endif %}
{%- endfor %}

{%- endif %}