{%- from 'salt/modules/fonts/map.jinja' import fonts with context %}


{%- if grains['kernel'] == 'Windows' %}
  # Namespace 0x14 is C:\Windows\Fonts and 0x1c is C:\Users\<user>\AppData\Local
  {#-
  {%- set fonts_target = salt['cmd.run']('(New-Object -ComObject Shell.Application).Namespace(0x14).self.Path', shell='powershell') %}
  #}
  {%- set fonts_target = salt['cmd.run']('(New-Object -ComObject Shell.Application).Namespace(0x1c).self.Path', shell='powershell') | path_join('Microsoft', 'Windows', 'Fonts') %}
{%- else %}
  {%- set fonts_target = salt['user.info'](salt['grains.get']('username'))['home'] | path_join('.local', 'share', 'fonts') %}
{%- endif %}

{%- for font, font_attr in fonts.fonts.items() %}

{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(font) }}:
  file.absent:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'fonts', font) }}

  {% for file in font_attr.get('files') %}
    {%- set font_filename = file.split('/')[-1] %}

{{ salt['vscode_anywhere.get_id'](sls) + ':install:{}:{}'.format(font, font_filename) }}:
  file.absent:
    - name: {{ fonts_target | path_join(font_filename) }}

  {%- endfor %}
{%- endfor %}