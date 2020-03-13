{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/misc/map.jinja' import misc with context %}

{{ init(misc, action='install', include=['salt/core/misc/install/chroot']) }}