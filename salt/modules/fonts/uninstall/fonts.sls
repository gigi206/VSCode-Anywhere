{%- from 'salt/modules/fonts/map.jinja' import fonts with context %}

{%- for font in fonts.fonts %}
  {%- if grains['kernel'] == 'Windows' %}
    {%- set dest = salt['cmd.run']("((New-Object -ComObject Shell.Application).Namespace(0x14).self.Path + '\{}')".format(font.split('/')[-1]), shell='powershell') %}
  {%- elif grains['kernel'] == 'Linux' %}
    {%- set dest = salt['cmd.run']("echo ~/.local/share/fonts/{}".format(font.split('/')[-1])) %}
  {%- endif %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(font) }}:
  file.absent:
    - name: {{ dest }}
{%- endfor %}