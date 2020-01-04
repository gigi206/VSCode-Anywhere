{%- from 'salt/modules/ruby/map.jinja' import ruby with context %}


include:
  - salt/core/scoop/install
  - salt/core/msys2/install
  - salt/modules/ruby/install


{%- if ruby.enabled and salt['grains.get']('kernel') == 'Windows' %}
{{ salt['vscode_anywhere.get_id'](sls) }}:
  cmd.run:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'ruby', 'current', 'bin','ridk.ps1') }} install 3
    - shell: powershell
    - hide_output: True
    - onchanges:
      - scoop: ruby
      - scoop: msys2
    - require:
      - sls: salt/core/scoop/install
      - sls: salt/core/msys2/install
      - sls: salt/modules/ruby/install
{%- endif %}