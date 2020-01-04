{%- from 'salt/modules/fonts/map.jinja' import fonts with context %}

{%- if fonts.enabled %}
  {%- for font in fonts.fonts %}
    {%- set dest = salt['grains.get']('vscode-anywhere:apps:path') | path_join('download', 'fonts', font.split('/')[-1]) %}

    {%- if grains['kernel'] == 'Windows' %}
      {%- set target1 = salt['cmd.run']('(New-Object -ComObject Shell.Application).Namespace(0x1c).self.Path + "\Microsoft\Windows\Fonts\{}"'.format(font.split('/')[-1]), shell='powershell') %}
      {%- set target2 = salt['cmd.run']("((New-Object -ComObject Shell.Application).Namespace(0x14).self.Path + '\{}')".format(font.split('/')[-1]), shell='powershell') %}
    {%- else %}
      {%- set target1 = salt['cmd.run']("echo ~/.local/share/fonts/{}".format(font.split('/')[-1])) %}
    {%- endif %}

{%- if not salt['pillar.get']('vscode-anywhere:offline') %}
{{ salt['vscode_anywhere.get_id'](sls) + ':download:{}'.format(font.split('/')[-1]) }}:
  file.managed:
    - name: {{ dest }}
    - source: {{ font }}
    - skip_verify: True
    - backup: False
    - makedirs: True
    - onlyif:
    {%- if grains['kernel'] == 'Windows' %}
      - powershell -Command { if ((Test-Path {{ target1 }} -PathType Leaf) -or (Test-Path {{ target2 }} -PathType Leaf)) {exit 1} }
    {%- else %}
      - ! test -f "{{ target1 }}"
    {%- endif %}
{%- endif %}


{{ salt['vscode_anywhere.get_id'](sls) + ':install:{}'.format(font.split('/')[-1]) }}:
  cmd.run:
  {%- if grains['kernel'] == 'Windows' %}
    - name: (New-Object -ComObject Shell.Application).Namespace(0x14).CopyHere("{{ dest }}", 0x10)
  {%- else %}
    - name: cp {{ dest }} {{ target1 }}
  {%- endif %}
    - shell: powershell
    - onlyif:
    {%- if grains['kernel'] == 'Windows' %}
      - powershell -Command { if ((Test-Path {{ target1 }} -PathType Leaf) -or (Test-Path {{ target2 }} -PathType Leaf)) {exit 1} }
    {%- else %}
      - ! test -f "{{ target1 }}"
    {%- endif %}
  {%- endfor %}
{%- endif %}