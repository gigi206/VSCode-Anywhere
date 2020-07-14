{%- from 'salt/modules/go/map.jinja' import go with context %}

{%- if go.enabled %}
include:
  - salt/modules/go/install


  {%- for pkg, pkg_attr in go.modules.items() %}
    {%- if pkg_attr.get('enabled') %}

{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(pkg) }}:
  cmd.run:
      {%- if pkg_attr.get('version') %}
    - name: {{ go.go_bin }} get {{ pkg }}@{{ pkg_attr.get('version') }}
      {%- else %}
    - name: {{ go.go_bin }} get {{ pkg }}
      {%- endif %}
    - require:
      - sls: salt/modules/go/install
      {%- if grains.get('kernel') == 'Windows' %}
    - shell: powershell
    - unless:
      - IF NOT EXIST "{{ salt['environ.get']('GOPATH') | path_join('src', pkg) }}" exit 1
      #- if (!(Test-Path "{{ salt['environ.get']('GOPATH') | path_join('src', pkg) }}" -PathType Container)) { exit 1 }
      #- fun: file.access
      #  path: {{ salt['environ.get']('GOPATH') | path_join('src', pkg) }}
      #  mode: f
    - check_cmd:
      - IF NOT EXIST "{{ salt['environ.get']('GOPATH') | path_join('src', pkg) }}" exit 1
      #- if (!(Test-Path "{{ salt['environ.get']('GOPATH') | path_join('src', pkg) }}" -PathType Container)) { exit 1 }
      #- fun: file.access
      #  path: {{ salt['environ.get']('GOPATH') | path_join('src', pkg) }}
      #  mode: f
      {%- else %}
    - unless:
      - test {{ salt['file.directory_exists'](salt['environ.get']('GOPATH') | path_join('src', pkg)) }} = True
      {%- endif %}
    - env:
      - GOROOT: {{ go.env.GOROOT }}
      - GOPATH: {{ go.env.GOPATH }}
    {%- endif %}
  {%- endfor %}
{%- endif %}