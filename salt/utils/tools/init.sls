{%- if salt['grains.get']('kernel') == 'Windows' %}
{{ salt['vscode_anywhere.get_id'](sls) + ':install' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('install.ps1') }}
    - source: salt://salt/utils/tools/files/install.ps1
    - template: jinja
    - backup: False


{{ salt['vscode_anywhere.get_id'](sls) + ':update' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('update.ps1') }}
    - source: salt://salt/utils/tools/files/update.ps1
    - template: jinja
    - backup: False


{{ salt['vscode_anywhere.get_id'](sls) + ':vscode' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('vscode.ps1') }}
    - source: salt://salt/utils/tools/files/vscode.ps1
    - template: jinja
    - backup: False


{{ salt['vscode_anywhere.get_id'](sls) + ':zeal' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('zeal.ps1') }}
    - source: salt://salt/utils/tools/files/zeal.ps1
    - template: jinja
    - backup: False


{{ salt['vscode_anywhere.get_id'](sls) + ':vscode-anywhere' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('vscode-anywhere.ps1') }}
    - source: salt://salt/utils/tools/files/vscode-anywhere.ps1
    - template: jinja
    - makedirs: True
    - backup: False


{{ salt['vscode_anywhere.get_id'](sls) + ':link' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('link.ps1') }}
    - source: salt://salt/utils/tools/files/link.ps1
    - template: jinja
    - makedirs: True
    - backup: False


{{ salt['vscode_anywhere.get_id'](sls) + ':terminal' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('terminal.ps1') }}
    - source: salt://salt/utils/tools/files/terminal.ps1
    - template: jinja
    - makedirs: True
    - backup: False

{%- else %}

{{ salt['vscode_anywhere.get_id'](sls) + ':install' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('install.sh') }}
    - source: salt://salt/utils/tools/files/install.sh
    - mode: 755
    - template: jinja
    - backup: False


{{ salt['vscode_anywhere.get_id'](sls) + ':update' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('update.sh') }}
    - source: salt://salt/utils/tools/files/update.sh
    - mode: 755
    - template: jinja
    - backup: False


{{ salt['vscode_anywhere.get_id'](sls) + ':vscode' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('vscode.sh') }}
    - source: salt://salt/utils/tools/files/vscode.sh
    - mode: 755
    - template: jinja
    - backup: False


{{ salt['vscode_anywhere.get_id'](sls) + ':vscode-anywhere' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('vscode-anywhere.sh') }}
    - source: salt://salt/utils/tools/files/vscode-anywhere.sh
    - mode: 755
    - template: jinja
    - makedirs: True
    - backup: False


{{ salt['vscode_anywhere.get_id'](sls) + ':zeal' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('documentation.sh') }}
    - source: salt://salt/utils/tools/files/documentation.sh
    - mode: 755
    - template: jinja
    - makedirs: True
    - backup: False


{{ salt['vscode_anywhere.get_id'](sls) + ':terminal' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('terminal.sh') }}
    - source: salt://salt/utils/tools/files/terminal.sh
    - mode: 755
    - template: jinja
    - makedirs: True
    - backup: False


{{ salt['vscode_anywhere.get_id'](sls) + ':link' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('link.sh') }}
    - source: salt://salt/utils/tools/files/link.sh
    - mode: 755
    - template: jinja
    - makedirs: True
    - backup: False
{%- endif %}