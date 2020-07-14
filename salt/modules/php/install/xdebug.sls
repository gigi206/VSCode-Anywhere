{%- from 'salt/modules/php/map.jinja' import php with context %}


{%- if php.enabled and salt['grains.get']('kernel') == 'Windows' %}
include:
  - salt/modules/php/install


{{ salt['vscode_anywhere.get_id'](sls) + ':xdebug' }}:
  file.replace:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'persist', 'php', 'cli', 'conf.d', 'xdebug.ini') }}
    - pattern: 'zend_extension=.*'
    - repl: 'zend_extension={{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'php-xdebug', 'current', 'php_xdebug.dll') | json }}'
    - backup: False
    - require:
      - sls: salt/modules/php/install
      - scoop: php-xdebug


{#-
{{ salt['vscode_anywhere.get_id'](sls) + ':xdebug-fix' }}:
  cmd.run: # FIXME: implement scoop.reset instead
    - names:
      - scoop uninstall php-xdebug
      - scoop install php-xdebug
    - require:
      - sls: salt/modules/php/install
      - scoop: php-xdebug
    - unless:
      - IF NOT EXIST "{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'persist', 'php', 'cli', 'conf.d', 'xdebug.ini') }}" exit 1
      #- if (!(Test-Path '{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'persist', 'php', 'cli', 'conf.d', 'xdebug.ini') }}' -PathType Leaf)) { exit 1 }
      #- fun: file.file_exists
      #  path: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'persist', 'php', 'cli', 'conf.d', 'xdebug.ini') }}
      #  mode: f
#}
{%- endif %}