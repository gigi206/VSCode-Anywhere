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
{%- endif %}