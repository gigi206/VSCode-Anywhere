{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/c_cpp/map.jinja' import c_cpp with context %}


{{ init(c_cpp, action='install') }}