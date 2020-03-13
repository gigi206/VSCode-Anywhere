{%- from 'salt/modules/ruby/map.jinja' import ruby with context %}


include:
  - salt/modules/ruby/install


{%- for pkg, pkg_attr in ruby.brew_gem.items() %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(pkg) }}:
  cmd.run:
    - name: brew gem uninstall {{ pkg }}
    - require:
      - sls: salt/modules/ruby/install
    - onlyif:
      - test -d /home/linuxbrew/.linuxbrew/Cellar/gem-{{ pkg }}
{%- endfor %}