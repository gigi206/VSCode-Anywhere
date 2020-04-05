# Output actions to console
function Output([string]$msg, [bool]$newline=$true, [string]$fgcolor='Cyan', [bool]$star=$true) {
    if (${star}) { Write-Host "* " -nonewline -ForegroundColor Green }
    if (${newline}) { Write-Host "${msg}" -ForegroundColor ${fgcolor} }
    else { Write-Host -nonewline "${msg}" -ForegroundColor ${fgcolor} }
}

# Output errors to console
function OutputErrror([string]$msg, [bool]$newline=$true, [bool]$exit=$true, [int]$exit_code=1) {
    if (${exit}) { ${message} = "A critical error has occurred: ${msg}" }
    else { ${message} = "An error has occurred (not critical): ${msg}" }

    if (${newline}) { Write-Host "${message}" -ForegroundColor Red }
    else { Write-Host -nonewline "${message}" -ForegroundColor Red }

    if (${exit}) {
        if (!(${env:VSCode_Anywhere_CI})) { Pause }
        exit ${exit_code}
    }
}

function RunCmd([String]$Cmd, [String]$ArgumentList=${null}, [String]$WorkingDirectory=(Get-Location).Path, [Bool]$Admin=${false}) {
    if (${Admin}) { $process = Start-Process -PassThru -Wait -WorkingDirectory "${WorkingDirectory}" -FilePath "${Cmd}" -ArgumentList "${ArgumentList}" -Verb "RunAs" }
    else { $process = Start-Process -PassThru -Wait -NoNewWindow -WorkingDirectory "${WorkingDirectory}" -FilePath "${Cmd}" -ArgumentList "${ArgumentList}" }
    if (${process}.ExitCode -ne 0) { OutputErrror "failed to run command: ${Cmd} ${ArgumentList}" }
}

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
    Output "You must execute this script with the administrator rights"
    RunCmd -Cmd "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Admin ${true}
}
{%- endif %}

Output "Updating VSCode-Anywhere from branch {{ saltenv }}"
Output "Updating saltstack pillar file"
Invoke-WebRequest -Uri https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/{{ saltenv }}/salt/conf/srv/pillar/saltstack.sls -OutFile "{{ salt['grains.get']('vscode-anywhere:saltstack:pillar_path')}}\saltstack.sls"
# $saltCurrentVersion = & ("{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}" + '\bin\python.exe') -c "import salt.version;print(salt.version.__version_info__[0])"
$saltCurrentVersion = & ("{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}" + '\bin\python.exe') -c "import salt.version;print('.'.join(str(v) for v in salt.version.__version_info__[0:2]))"
$saltTargetVersion = (& "${PSScriptRoot}\vscode-anywhere.ps1" pillar.get saltstack:version --out json | ConvertFrom-Json).local
if ($saltCurrentVersion -ne $saltTargetVersion) {
    Output "Updating Saltsatck ${saltCurrentVersion} => ${saltTargetVersion}"
    Invoke-WebRequest -Uri https://repo.saltstack.com/windows/Salt-Minion-${saltTargetVersion}-Py3-AMD64-Setup.exe -OutFile "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:apps:path')) }}\saltstack.exe"
    Remove-Item -Path "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}" -Recurse -Force
    New-Item -Path "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}" -ItemType "directory" | Out-Null
    RunCmd -Cmd 7z.exe -ArgumentList "x `"{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('saltstack.exe') }}`" -y" -WorkingDirectory "{{ salt['grains.get']('vscode-anywhere:saltstack:path') }}"
    Remove-Item "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:apps:path')) | path_join('saltstack.exe') }}"
    Output "Syncing Saltstack to the latest VSCode-Anywhere updates (fork)"
    Set-Location ("{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}" + "\bin\Lib\site-packages\salt-*")
    Rename-Item -Path salt -NewName salt.orig
    RunCmd -Cmd git.exe -ArgumentList "init ."
    RunCmd -Cmd git.exe -ArgumentList "config core.sparsecheckout true"
    Add-Content -Path ".git/info/sparse-checkout" -Value "salt/*"
    Add-Content -Path ".gitignore" -Value "*"
    Add-Content -Path ".gitignore" -Value "!salt"
    RunCmd -Cmd git.exe -ArgumentList "remote add origin https://github.com/gigi206/salt.git"
    if (${env:VSCode_Anywhere_CI}) {
        RunCmd -Cmd git.exe -ArgumentList "pull --quiet --depth=100 origin vsc${saltTargetVersion}"
        RunCmd -Cmd git.exe -ArgumentList "checkout --quiet vsc${saltTargetVersion}"
    }
    else {
        RunCmd -Cmd git.exe -ArgumentList "pull --depth=100 origin vsc${saltTargetVersion}"
        RunCmd -Cmd git.exe -ArgumentList "checkout vsc${saltTargetVersion}"
    }
    RunCmd -Cmd git.exe -ArgumentList "branch -d master"

    # Install requirements
    Output "Install Saltstack requirements"
    if (${env:VSCode_Anywhere_CI}) { RunCmd -Cmd "{{ salt['grains.get']('vscode-anywhere:saltstack:path') | path_join('bin', 'python.exe') }}" -ArgumentList "-m pip --quiet install commentjson" }
    else { RunCmd -Cmd "{{ salt['grains.get']('vscode-anywhere:saltstack:path') | path_join('bin', 'python.exe') }}" -ArgumentList "-m pip install commentjson" }
}
else {
    Output "Syncing Saltstack ${saltCurrentVersion} to the latest VSCode-Anywhere updates (fork)"
    # Set-Location ((Resolve-Path "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}").Path + '\bin\Lib\site-packages\salt-*')
    Set-Location ("{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}" + '\bin\Lib\site-packages\salt-*')
    RunCmd -Cmd git.exe -ArgumentList "reset --hard HEAD"
    if (${env:VSCode_Anywhere_CI}) { RunCmd -Cmd git.exe -ArgumentList "pull --quiet --ff-only origin vsc${saltTargetVersion}" }
    else { RunCmd -Cmd git.exe -ArgumentList "pull --ff-only origin vsc${saltTargetVersion}" }

    # Upgrade required modules
    Output "Update Saltstack requirements"
    if (${env:VSCode_Anywhere_CI}) { RunCmd -Cmd "{{ salt['grains.get']('vscode-anywhere:saltstack:path') | path_join('bin', 'python.exe') }}" -ArgumentList "-m pip --quiet install --upgrade commentjson" }
    else { RunCmd -Cmd "{{ salt['grains.get']('vscode-anywhere:saltstack:path') | path_join('bin', 'python.exe') }}" -ArgumentList "-m pip install --upgrade commentjson" }
}

Output "Updating VSCode-Anywhere"
Set-Location "${PSScriptRoot}"
. "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:tools:env')) }}"
# RunCmd -Cmd ".\vscode-anywhere.ps1" -ArgumentList "--retcode-passthrough --state-verbose=False --force-color state.apply salt/utils/update saltenv={{ saltenv }} sync_mods=all $Args"
& .\vscode-anywhere.ps1 --retcode-passthrough --state-verbose=False --force-color state.apply salt/utils/update saltenv={{ saltenv }} sync_mods=all $Args
$exit = ${LASTEXITCODE}

if (!(${env:VSCode_Anywhere_CI})) { Pause }

exit $exit