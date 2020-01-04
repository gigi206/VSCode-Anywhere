{%- from 'salt/modules/go/map.jinja' import go with context %}


{{ salt['vscode_anywhere.get_id'](sls) }}:
  file.absent:
    - name: {{ salt['environ.get']('GOPATH') }}