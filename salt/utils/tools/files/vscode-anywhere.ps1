Set-ExecutionPolicy Bypass -Scope Process -Force
# Set-Location "${PSScriptRoot}"

{%- if salt['grains.get']('vscode-anywhere:profile') == 'windows_admin' %}
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    . "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:tools:env')) }}"
    & "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}\salt-call.bat" --config-dir="${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:config_path')) }}" $Args
    $exit = $?
}
else {
    Write-Host "You must execute this script with the administrator rights"
    $run = Start-Process -NoNewWindow -PassThru -Wait powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    $exit = $run.ExitCode
}
{%- else %}
. "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:tools:env')) }}"
& "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}\salt-call.bat" --config-dir="${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:config_path')) }}" $Args
$exit = $?
{%- endif %}

exit ${exit}