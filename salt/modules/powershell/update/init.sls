{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/powershell/map.jinja' import powershell with context %}


{{ init(powershell, action='update') }}