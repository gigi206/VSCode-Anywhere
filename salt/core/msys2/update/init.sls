{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/msys2/map.jinja' import msys2 with context %}

{#- {{ init(msys2, action='update', include=['salt/core/msys2/install/hold', 'salt/core/msys2/update/uptodate', 'salt/core/msys2/install/env', 'salt/core/msys2/install/link']) }} #}
{{ init(msys2, action='update', include=['salt/core/msys2/install/hold', 'salt/core/msys2/update/uptodate', 'salt/core/msys2/install/link']) }}