{%- from 'salt/modules/fonts/map.jinja' import fonts with context %}


{%- if fonts.enabled %}
  {%- if grains['kernel'] == 'Windows' %}
    # Namespace 0x14 is C:\Windows\Fonts and 0x1c is C:\Users\<user>\AppData\Local
    {#-
    {%- set fonts_target = salt['cmd.run']('(New-Object -ComObject Shell.Application).Namespace(0x14).self.Path', shell='powershell') %}
    #}
    {%- set fonts_target = salt['cmd.run']('(New-Object -ComObject Shell.Application).Namespace(0x1c).self.Path', shell='powershell') | path_join('Microsoft', 'Windows', 'Fonts') %}
  {%- else %}
    # {%- set fonts_target = salt['user.info'](salt['grains.get']('username'))['home'] | path_join('.local', 'share', 'fonts') %}
    {%- set fonts_target = salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.local', 'share', 'fonts') %}
  {%- endif %}

  {%- for font, font_attr in fonts.fonts.items() %}
    {%- if font_attr.get('provider') == 'git' %}

{{ salt['vscode_anywhere.get_id'](sls) + ':clone:{}'.format(font) }}:
  git.cloned:
    - name: {{ font_attr['url'] }}
    - target: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'fonts', font) }}
    - branch: master

    {%- endif %}
    {% for file in font_attr.get('files') %}
      {%- set font_filename = file.split('/')[-1] %}
      {%- if grains['kernel'] == 'Windows' %}

{{ salt['vscode_anywhere.get_id'](sls) + ':install:{}:{}'.format(font, font_filename) }}:
  cmd.run:
    # CopyHere 2nd arg: https://docs.microsoft.com/en-us/windows/win32/shell/folder-copyhere (0x10 = 16)
    # 0x14 (C:\Windows\Fonts) is specified but in fact fonts are installed in 0x1c + "Microsoft\Windows\Fonts"
    - name: (New-Object -ComObject Shell.Application).Namespace(0x14).CopyHere("{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'fonts', font, file) }}", 0x10)
    - shell: powershell
    - unless:
      - IF NOT EXIST "{{ fonts_target | path_join(font_filename) }}" exit 1
      #- if (!(Test-Path "{{ fonts_target | path_join(font_filename) }}" -PathType Leaf)) { exit 1 }
      #- powershell -NonInteractive -NoProfile "if (!(Test-Path '{{ fonts_target | path_join(font_filename) }}' -PathType Leaf)) { exit 1 }" || exit 1
      #- fun: file.access
      #  path: {{ fonts_target | path_join(font_filename) }}
      #  mode: f

      {%- else %}

{{ salt['vscode_anywhere.get_id'](sls) + ':install:{}:{}'.format(font, font_filename) }}:
  file.managed:
    - name: {{ fonts_target | path_join(font_filename) }}
    - source: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'fonts', font, file) }}
    - skip_verify: True
    - backup: False
    - makedirs: True

      {%- endif %}
    {%- endfor %}
  {%- endfor %}
{%- endif %}