Write-Host ""                                                         -ForegroundColor Green
Write-Host "/=======================================================" -ForegroundColor Green
Write-Host "|"                                                        -ForegroundColor Green
Write-Host "| Update in progress, please wait, it could take a while" -ForegroundColor Green
Write-Host "|"                                                        -ForegroundColor Green
Write-Host "\=======================================================" -ForegroundColor Green
Write-Host ""

Set-ExecutionPolicy Bypass -Scope Process -Force
Set-Location "${PSScriptRoot}"

{%- if salt['grains.get']('vscode-anywhere:profile') == 'windows_admin' %}
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host "You must execute this script with the administrator rights"
    $run = Start-Process -NoNewWindow -PassThru -Wait powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    $exit = $run.ExitCode
}
{%- endif %}

# Set-Location ((Resolve-Path "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}").Path + '\bin')
# Set-Location ("{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}" + '\bin')
Write-Host "* Updating saltstack pillar file" -ForegroundColor Cyan
Invoke-WebRequest -Uri https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/{{ saltenv }}/salt/conf/srv/pillar/saltstack.sls -OutFile "{{ salt['grains.get']('vscode-anywhere:saltstack:pillar_path')}}\saltstack.sls"
$saltCurrentVersion = & ("{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}" + '\bin\python.exe') -c "import salt.version;print('.'.join(str(v) for v in salt.version.__version_info__[0:2]))"
$saltTargetVersion = (& "${PSScriptRoot}\vscode-anywhere.ps1" pillar.get saltstack:version --out json | ConvertFrom-Json).local
if ($saltCurrentVersion -ne $saltTargetVersion) {
    Write-Host "* Update Saltsatck ${saltCurrentVersion} => ${saltTargetVersion}" -ForegroundColor Cyan
    Invoke-WebRequest -Uri https://repo.saltstack.com/windows/Salt-Minion-${saltTargetVersion}.0-Py3-AMD64-Setup.exe -OutFile "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:apps:path')) }}\saltstack.exe"
    Remove-Item -Path "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}" -Recurse -Force
    Start-Process -Wait -NoNewWindow -WorkingDirectory "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:apps:path')) }}" -FilePath "7z.exe" -ArgumentList "x `"{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:apps:path')) }}\saltstack.exe`" -y"
    Write-Host "* Syncing Saltstack to the latest VSCode-Anywhere updates (fork)" -ForegroundColor Cyan
    # Set-Location ((Resolve-Path "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}").Path + '\bin\Lib\site-packages')
    Set-Location ("{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}" + '\bin\Lib\site-packages')
    Rename-Item -Path salt -NewName salt.orig
    & git init .
    & git config core.sparsecheckout true
    Add-Content -Path ".git/info/sparse-checkout" -Value "salt/*"
    Add-Content -Path ".gitignore" -Value "*"
    Add-Content -Path ".gitignore" -Value "!salt"
    & git remote add origin https://github.com/gigi206/salt.git
    & git pull --depth=1 origin vsc${saltTargetVersion}
    & git checkout vsc${saltTargetVersion}
    & git branch -d master
}
else {
    Write-Host "* Syncing Saltstack ${saltCurrentVersion} to the latest VSCode-Anywhere updates (fork)" -ForegroundColor Cyan
    # Set-Location ((Resolve-Path "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}").Path + '\bin\Lib\site-packages')
    Set-Location ("{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}" + '\bin\Lib\site-packages')
    git reset --hard HEAD
    if (${env:VSCode_Anywhere_CI}) { git pull --quiet --ff-only }
    else { git pull --ff-only }
}

Write-Host "* Updating VSCode-Anywhere" -ForegroundColor Cyan
Set-Location "${PSScriptRoot}"
. "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:tools:env')) }}"
& .\vscode-anywhere.ps1 --retcode-passthrough --state-verbose=False state.apply salt/utils/update saltenv={{ saltenv }} sync_mods=all
$exit = $?


if (!(${env:VSCode_Anywhere_CI})) { Pause }
exit $exit