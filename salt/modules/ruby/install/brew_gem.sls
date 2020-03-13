{%- from 'salt/modules/ruby/map.jinja' import ruby with context %}


{%- if ruby.enabled and salt['grains.get']('kernel') != 'Windows' %}
include:
  - salt/modules/ruby/install


{%- for pkg, pkg_attr in ruby.brew_gem.items() %}
  {%- if pkg_attr.get('enabled') %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(pkg) }}:
  cmd.run:
  {%- if pkg_attr.get('version') %}
    - name: brew gem install {{ pkg }} {{ pkg_attr.get('version') }}
  {%- else %}
    - name: brew gem install {{ pkg }}
  {%- endif %}
    - require:
      - sls: salt/modules/ruby/install
    - unless:
      - test -d /home/linuxbrew/.linuxbrew/Cellar/gem-{{ pkg }}
    {%- if pkg_attr.get('version') %}
      - test $(brew gem info solargraph --json | jq -r '.[].installed[0].version') = {{ pkg_attr.get('version') }}
    {%- endif %}
  {%- endif %}
{%- endfor %}

{%- endif %}