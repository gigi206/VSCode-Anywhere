{%- from 'salt/modules/go/map.jinja' import go with context %}


include:
  - salt/modules/go/install


{%- if go.enabled %}
  {%- for pkg, pkg_attr in go.modules.items() %}
    {%- if pkg_attr.get('enabled') %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(pkg) }}:
  cmd.run:
    {%- if pkg_attr.get('version') %}
    - name: {{ go.go_bin }} get -u {{ pkg }}@{{ pkg_attr.get('version') }}
    {%- else %}
    - name: {{ go.go_bin }} get -u {{ pkg }}
    {%- endif %}
    - require:
      - sls: salt/modules/go/install
      {%- if grains.get('kernel') == 'Windows' %}
    - shell: powershell
    - unless:
      - if (!(Test-Path "{{ salt['environ.get']('GOPATH') | path_join('src', pkg) }}" -PathType Container)) { exit 1 }
    - check_cmd:
      - powershell -Command { if (!(Test-Path "{{ salt['environ.get']('GOPATH') | path_join('src', pkg) }}" -PathType Container)) { exit 1 } }
      {%- else %}
    - unless:
      - test {{ salt['file.directory_exists'](salt['environ.get']('GOPATH') | path_join('src', pkg)) }} = True
      {%- endif %}
    - env:
      - GOROOT: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'go', 'current') }}
      - GOPATH: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'persist', 'go') }}
    {%- endif %}
  {%- endfor %}
{%- endif %}