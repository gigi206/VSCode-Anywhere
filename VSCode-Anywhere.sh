#!/usr/bin/env bash
set -o pipefail

##############
#   Params   #
##############

# Define parameters for VSCode-Anywhere
function Params {
    # Execute getopt on the arguments passed to this program, identified by the special character ${@}
    eval set -- $(getopt -n "${0}" -o he:d:v:p:s: -l 'help,gitenv:,installdir:,saltversion:,profile:,saltopts' -- "${@}")

    # Now goes through all the options with a case and using shift to analyse 1 argument at a time
    # ${1} identifies the first argument, and when we use shift we discard the first argument, so ${2} becomes ${1} and goes again through the case
    while true
    do
        case "${1}" in
            -h|--help)
                Usage
            ;;

            -e|--gitenv)
                [ -n "${2}" ] && Gitenv="${2}"
                shift 2
            ;;

            -d|--installdir)
                [ -n "${2}" ] && InstallDir="${2}"
                shift 2
            ;;

            -v|--saltversion)
                [ -n "${2}" ] && SaltVersion="${2}"
                shift 2
            ;;

            -p|--profile)
                [ -n "${2}" ] && Profile="${2}"
                shift 2
            ;;

            -s|--saltopts)
                [ -n "${2}" ] && SaltOpts="${2}"
                shift 2
            ;;

            --)
                shift
                break
            ;;
        esac
    done
}

############
#   FUNC   #
############

# Help function
function Usage {
    echo "usage :"
    echo "    -h | --help        : print this help"
    echo "    -e | --gitenv      : git branch (default: V2)"
    echo "    -d | --installdir  : installation directory (default: ~/VSCode-Anywhere)"
    echo "    -v | --saltversion : saltstack version to use"
    echo "    -p | --profile     : VSCode-Anywhere profile to use (default: linux_user)"
    echo "    -s | --saltopts    : Salt options"
    exit 0
}

# Check requirements
function CheckCommand {
    cmd="${1}"
    msg="${2}"
    if command -v ${1} &>/dev/null
    then
        echo -e "\033[1;32m[✔]\033[0m ${1}"
    else
        echo -e "\033[1;31m[✘]\033[0m ${1}"
        OutputErrror "${msg}"
    fi
}

function Init {
    Header "VSCode-Anywhere"
    Output "Environment          : ${Gitenv}"
    Output "Saltstack version    : ${SaltVersion}"
    Output "Installation profile : ${Profile}"
    Output "Installation dir     : ${InstallDir}"

    [ -e "${InstallDir}" ] && OutputErrror "Installation directory ${InstallDir} already exists !"

    if [ "${Profile}" = "linux_admin" ]
    then
        if [ "$(id -u)" -gt 0 ]
        then
            echo "${Profile} means that you need to execute this script with the root privileges"
            sudo $0
            exit
        fi
    fi

    # Check requirements
    Output "Check requirements"

    # linux_admin profile is not confined with the namespaces
    if [ "${Profile}" = "linux_user" -o "${Profile}" = "linux_portable" ]
    then
        if command -v unshare &>/dev/null
        then
            if unshare --user --pid echo &>/dev/null
            then
                echo -e "\033[1;32m[✔]\033[0m Linux namespace"
            else
                echo -e "\033[1;31m[✘]\033[0m ${1}"
                echo "Your OS seems not managed the Linux namespaces"
                echo "Linux namespace is mandatory for the installation with the profile ${Profile}"
                echo "Try to install with the linux_admin profile (need privileges)"
                exit 1
            fi
        else
            echo -e "\033[1;33m[❗]\033[0m unable to determine Linux namespaces support because unshare command is not found (skip)"
        fi
    fi

    CheckCommand "bash" "bash binary is mandatory"
    CheckCommand "command" "bash package is mandatory"
    CheckCommand "tar" "tar binary is mandatory"
    for cmd in realpath readlink cut test mkdir chmod id rm echo
    do
        CheckCommand "$cmd" "coreutils package is mandatory"
    done
    CheckCommand "curl" "curl binary is mandatory. Please read https://vscode-anywhere.readthedocs.io/en/dev/installation/Linux/index.html#packages for the workaround."

    Cmd "mkdir -p '${VSCBin}'"
    Cmd "curl -L https://github.com/gigi206/VSCode-Anywhere/raw/${Gitenv}/bin/linux/vscode-anywhere-chroot-linux-x86_64 -o '${VSCChroot}'"
    Cmd "chmod +x '${VSCChroot}'"
}

# Output header
function Header {
    message="${*}"
    echo -e "\033[1;32m"
    echo "/============================================================="
    echo "|"
    echo "| ${message}"
    echo "|"
    echo "\\============================================================="
    echo -e "\033[0m"
}

# Output actions to console
function Output {
    message="${1}"
    echo -en "\\n\033[1;32m* \033[1;36m"
    eval echo '${message}'
    echo -e "\033[0m"
}

# Output errors to console
function OutputErrror {
    message="${1}"
    echo -e "\033[1;31m"
    eval echo -e '\\nError: ${message}\\n'
    echo -e "\033[0m"
    exit 1
}

# Run shell Command
function Cmd {
    echo -e "\\n\033[1;33m>>> ${@} <<< (Cmd)\033[0m"
    eval ${@}

    if [ ${?} -ne 0 ]
    then
        OutputErrror "A critical error has occurred !"
    fi
}

# Run local cmd with a Junest binary (no chroot)
function JunestLocalCmd {
    echo -e "\\n\033[1;33m>>> ${@} <<< (Cmd local Junest)\033[0m"
    eval "${JunestAppPathChroot}/usr/lib/ld-linux-x86-64.so*" --library-path "${JunestAppPathChroot}/usr/lib" "${JunestAppPathChroot}/usr/bin/"${@}

    if [ ${?} -ne 0 ]
    then
        OutputErrror "A critical error has occurred !"
    fi
}

# Run command inside Junest with Proot or Namespace
function JunestCmd {
    cmd="${1}"
    type="${2}"

    echo -e "\\n\\n\033[1;33m>>> ${cmd} <<< (${type} JunestCmd)\033[0m"

    if [ "$type" = 'proot' ]
    then
        chroot_type='p'
    else
        chroot_type='n'
    fi

    JUNEST_HOME="${JunestAppPathChroot}" "${JunestBin}" ${chroot_type} -b "-b ${InstallDir}:${InstallDir}" /bin/bash -l << EOF
${cmd}
EOF

    if [ ${?} -ne 0 ]
    then
        OutputErrror "A critical error has occurred !"
    fi
}

# Run command inside Nixpkgs
function NsCmd {
    echo -e "\\n\\n\033[1;33m>>> ${@} <<< (NsCmd)\033[0m"

    ${VSCChroot} ${NixAppPath} ${BrewAppPath} ${SHELL=bash} -l << EOF
export NIXPKGS_ALLOW_UNFREE=1
export NIX_INSTALLER_NO_MODIFY_PROFILE=1
export USER="${VSCUser}"
export HOME="${VSCHome}"
export XDG_CONFIG_HOME="${NixConfig}"
export NIX_PAGER=''
export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar"
export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew"
export HOMEBREW_NO_ENV_FILTERING=1
# export HOMEBREW_DEVELOPER=1
# export HOMEBREW_GIT=$(command -v git)
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin${PATH+:$PATH}"
export MANPATH="/home/linuxbrew/.linuxbrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info${INFOPATH+:$INFOPATH}"
test -f "${VSCHome}/.nix-profile/etc/profile.d/nix.sh" && source "${VSCHome}/.nix-profile/etc/profile.d/nix.sh"
${@}
EOF

    ret_code=${?}

    if [ ${ret_code} -ne 0 ]
    then
        OutputErrror "A critical error has occurred !"
    fi
}

# Install Junest for chroot
function InstallJunest {
    Header "Junest"
    Output "Installing Junest"

    # Create Junest directory
    Cmd "mkdir -p '${JunestAppPath}'"

    Output "Downloading Junest binaries"
    # Cmd "cd '${JunestAppPath}' && wget -qO - https://api.github.com/repos/fsquillace/junest/tarball | tar xz && mv fsquillace-junest-* '${JunestAppPathInstall}'"
    Cmd "cd '${JunestAppPath}' && curl -Lo - https://api.github.com/repos/fsquillace/junest/tarball | tar xz && mv fsquillace-junest-* '${JunestAppPathInstall}'"

    # Create chroot junest directory
    Cmd "mkdir -p '${JunestAppPathChroot}'"

    Output "Downloading ${JunestAppName} chroot"
    # Cmd "wget --progress=bar:force -O - https://s3-eu-west-1.amazonaws.com/junest-repo/junest/junest-x86_64.tar.gz | tar xz -C '${JunestAppPathChroot}'"
    Cmd "curl -Lo - https://s3-eu-west-1.amazonaws.com/junest-repo/junest/junest-x86_64.tar.gz | tar xz -C '${JunestAppPathChroot}'"

    Output "Updating ${JunestAppName} chroot packages"

    update="pacman -Sy --noconfirm --needed --overwrite='*' archlinux-keyring sed; pacman --init; pacman-key --populate archlinux;yes y | LC_ALL=C pacman -Syu; kill -9 $((${$} - 1)) 2>/dev/null"
    # JUNEST_HOME="${JunestAppPathChroot}" "${JunestBin}" n /bin/bash -l -- 2>/dev/null << EOF
    JUNEST_HOME="${JunestAppPathChroot}" "${JunestBin}" n /bin/bash -l << EOF
${update}
EOF

    # FIXME: Reinstall junest bin from github for be to be able to git pull
    #JunestCmd "git clone https://github.com/fsquillace/junest.git '${JunestExternalPath}${JunestAppPath_install}_tmp' --depth 1" 'namespace'
    #Cmd "rm -fr '${JunestAppPath_install}' && mv '${JunestAppPath_install}_tmp' '${JunestAppPath_install}'"
}

# Install a package inside chroot
function InstallJunestPkg {
    Output "Installing Junest packages: ${*}"
    JunestCmd "pacman -Qk ${*} 2>/dev/null || pacman -Syu --noconfirm --needed --overwrite='*' ${*}" 'namespace'
}

# Install a Nix package
function InstallNixPkg {
    Output "Installing Nix packages: ${*}"
    NsCmd "nix-env -iA ${*}"
}

# Install a Brew package
function InstallBrewPkg {
    Output "Installing Brew packages: ${*}"
    NsCmd "brew install ${*}"
}

# Install HomeBrew
function InstallHomebrew {
    Header "Homebrew"
    Output "Installing Linux Homebrew"

    # NsCmd 'bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" < /dev/null'
    NsCmd "mkdir -p /home/linuxbrew/.linuxbrew/bin"
    NsCmd "git clone --depth 1 https://github.com/Homebrew/brew.git /home/linuxbrew/.linuxbrew/Homebrew"
    NsCmd "ln -s /home/linuxbrew/.linuxbrew/Homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin"
}

function InstallNix {
    Header "Nix"
    Output "Installing Nix (Nixpkgs)"
    Cmd "mkdir -m 755 -p '${BrewAppPath}' '${NixAppPath}' '${NixConfig}' '${VSCHome}' '${NixProfiles}'"
    NsCmd "bash <(curl -L https://nixos.org/nix/install) --no-daemon"
}

# Install Saltstack
function InstallSalt {
    Header "Saltstack"

    # Output "Install requirements"
    # NsCmd "brew install jq"

    Output "Cloning Saltstack"
    Cmd "mkdir -p '${SaltstackDir}'"
    NsCmd "git clone -b vsc${SaltVersion} --depth 100 https://github.com/gigi206/salt.git '${SaltstackSrcDir}'"

    Output "Configuring Saltstack"
    Cmd "mkdir -p '${SaltstackConfDirMinion}' '${SaltstackPillarDir}' '${SaltstackRootsDir}'"
    Cmd "curl -L https://raw.githubusercontent.com/gigi206/salt/vsc${SaltVersion}/conf/minion -o '${SaltstackConfDir}/minion'"

    # Download Saltstack configuration
    Cmd "curl -L https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/${Gitenv}/salt/conf/conf/minion.d/VSCode-Anywhere.conf -o '${SaltstackConfDirMinion}/VSCode-Anywhere.conf'"
    # Cmd "curl -s https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/${Gitenv}/salt/conf/conf/minion.d/VSCode-Anywhere-offline.conf -o '${SaltstackConfDirMinion}/VSCode-Anywhere-offline.conf'"
    Cmd "curl -L https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/${Gitenv}/salt/conf/srv/pillar/top.sls -o '${SaltstackPillarDir}/top.sls'"
    Cmd "curl -L https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/${Gitenv}/salt/conf/srv/pillar/vscode-anywhere.sls -o '${SaltstackPillarDir}/vscode-anywhere.sls'"
    Cmd "curl -L https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/${Gitenv}/salt/conf/srv/pillar/saltstack.sls -o '${SaltstackPillarDir}/saltstack.sls'"
    Cmd "echo 'root_dir: ${SaltstackDir}' >> '${SaltstackConfDirMinion}/VSCode-Anywhere.conf'"

    # Download Salt nix profile
    Cmd "curl -L https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/${Gitenv}/salt/conf/nix/profiles/salt.nix -o '${NixProfiles}/salt.nix'"

    # Test Saltstack working properly
    NsCmd "nix-shell '${NixProfiles}/salt.nix' --run \"salt-call --config-dir='${SaltstackConfDir}' --file-root='${SaltstackRootsDir}' --pillar-root='${SaltstackPillarDir}' --cachedir='${SaltstackDir}/var/cache/salt/minion' --log-file='${SaltstackDir}/var/log/salt/minion' --id='VSCode-Anywhere' test.ping\""
    if [ "$?" -ne 0 ]
    then
        OutputErrror "Saltstack does not seem to be correctly installed"
    fi
}

# Install VSCode-Anywhere
function InstallVSCodeAnywhere {
    Header "VSCode-Anywhere"
    Output "Installing Satlstack grains"
    # Set Saltstack grains
    Output "Installing grains => vscode-anywhere:profile"
    NsCmd "nix-shell '${NixProfiles}/salt.nix' --run \"salt-call --config-dir='${SaltstackConfDir}' --file-root='${SaltstackRootsDir}' --pillar-root='${SaltstackPillarDir}' --cachedir='${SaltstackDir}/var/cache/salt/minion' --log-file='${SaltstackDir}/var/log/salt/minion' --id='VSCode-Anywhere' grains.set 'vscode-anywhere:profile' '${Profile}'\""
    Output "Installing grains => vscode-anywhere:path"
    NsCmd "nix-shell '${NixProfiles}/salt.nix' --run \"salt-call --config-dir='${SaltstackConfDir}' --file-root='${SaltstackRootsDir}' --pillar-root='${SaltstackPillarDir}' --cachedir='${SaltstackDir}/var/cache/salt/minion' --log-file='${SaltstackDir}/var/log/salt/minion' --id='VSCode-Anywhere' grains.set 'vscode-anywhere:path' '${InstallDir}'\""
    Output "Installing grains => vscode-anywhere:apps:path"
    NsCmd "nix-shell '${NixProfiles}/salt.nix' --run \"salt-call --config-dir='${SaltstackConfDir}' --file-root='${SaltstackRootsDir}' --pillar-root='${SaltstackPillarDir}' --cachedir='${SaltstackDir}/var/cache/salt/minion' --log-file='${SaltstackDir}/var/log/salt/minion' --id='VSCode-Anywhere' grains.set 'vscode-anywhere:apps:path' '${Apps}'\""
    Output "Installing grains => vscode-anywhere:tools:path"
    NsCmd "nix-shell '${NixProfiles}/salt.nix' --run \"salt-call --config-dir='${SaltstackConfDir}' --file-root='${SaltstackRootsDir}' --pillar-root='${SaltstackPillarDir}' --cachedir='${SaltstackDir}/var/cache/salt/minion' --log-file='${SaltstackDir}/var/log/salt/minion' --id='VSCode-Anywhere' grains.set 'vscode-anywhere:tools:path' '${InstallDir}/tools'\""
    Output "Installing grains => vscode-anywhere:tools:env"
    NsCmd "nix-shell '${NixProfiles}/salt.nix' --run \"salt-call --config-dir='${SaltstackConfDir}' --file-root='${SaltstackRootsDir}' --pillar-root='${SaltstackPillarDir}' --cachedir='${SaltstackDir}/var/cache/salt/minion' --log-file='${SaltstackDir}/var/log/salt/minion' --id='VSCode-Anywhere' grains.set 'vscode-anywhere:tools:env' '${InstallDir}/tools/env.sh'\""
    Output "Installing grains => vscode-anywhere:config:path"
    NsCmd "nix-shell '${NixProfiles}/salt.nix' --run \"salt-call --config-dir='${SaltstackConfDir}' --file-root='${SaltstackRootsDir}' --pillar-root='${SaltstackPillarDir}' --cachedir='${SaltstackDir}/var/cache/salt/minion' --log-file='${SaltstackDir}/var/log/salt/minion' --id='VSCode-Anywhere' grains.set 'vscode-anywhere:config:path' '${ConfDir}'\""
    Output "Installing grains => vscode-anywhere:saltstack:path"
    NsCmd "nix-shell '${NixProfiles}/salt.nix' --run \"salt-call --config-dir='${SaltstackConfDir}' --file-root='${SaltstackRootsDir}' --pillar-root='${SaltstackPillarDir}' --cachedir='${SaltstackDir}/var/cache/salt/minion' --log-file='${SaltstackDir}/var/log/salt/minion' --id='VSCode-Anywhere' grains.set 'vscode-anywhere:saltstack:path' '${SaltstackDir}'\""
    Output "Installing grains => vscode-anywhere:saltstack:config_path"
    NsCmd "nix-shell '${NixProfiles}/salt.nix' --run \"salt-call --config-dir='${SaltstackConfDir}' --file-root='${SaltstackRootsDir}' --pillar-root='${SaltstackPillarDir}' --cachedir='${SaltstackDir}/var/cache/salt/minion' --log-file='${SaltstackDir}/var/log/salt/minion' --id='VSCode-Anywhere' grains.set 'vscode-anywhere:saltstack:config_path' '${SaltstackConfDir}'\""
    Output "Installing grains => vscode-anywhere:saltstack:minion_path"
    NsCmd "nix-shell '${NixProfiles}/salt.nix' --run \"salt-call --config-dir='${SaltstackConfDir}' --file-root='${SaltstackRootsDir}' --pillar-root='${SaltstackPillarDir}' --cachedir='${SaltstackDir}/var/cache/salt/minion' --log-file='${SaltstackDir}/var/log/salt/minion' --id='VSCode-Anywhere' grains.set 'vscode-anywhere:saltstack:minion_path' '${SaltstackConfDirMinion}'\""
    Output "Installing grains => vscode-anywhere:saltstack:roots_path"
    NsCmd "nix-shell '${NixProfiles}/salt.nix' --run \"salt-call --config-dir='${SaltstackConfDir}' --file-root='${SaltstackRootsDir}' --pillar-root='${SaltstackPillarDir}' --cachedir='${SaltstackDir}/var/cache/salt/minion' --log-file='${SaltstackDir}/var/log/salt/minion' --id='VSCode-Anywhere' grains.set 'vscode-anywhere:saltstack:roots_path' '${SaltstackRootsDir}'\""
    Output "Installing grains => vscode-anywhere:saltstack:pillar_path"
    NsCmd "nix-shell '${NixProfiles}/salt.nix' --run \"salt-call --config-dir='${SaltstackConfDir}' --file-root='${SaltstackRootsDir}' --pillar-root='${SaltstackPillarDir}' --cachedir='${SaltstackDir}/var/cache/salt/minion' --log-file='${SaltstackDir}/var/log/salt/minion' --id='VSCode-Anywhere' grains.set 'vscode-anywhere:saltstack:pillar_path' '${SaltstackPillarDir}'\""

    Output "Installing VSCode-Anywhere"
    NsCmd "nix-shell '${NixProfiles}/salt.nix' --run \"salt-call --config-dir='${SaltstackConfDir}' --file-root='${SaltstackRootsDir}' --pillar-root='${SaltstackPillarDir}' --cachedir='${SaltstackDir}/var/cache/salt/minion' --log-file='${SaltstackDir}/var/log/salt/minion' --id='VSCode-Anywhere' --state-verbose=False state.apply saltenv=${Gitenv} sync_mods=all ${SaltOpts}\""
}

############
#   VARS   #
############

# Parse arguments
Params "${@}"

# Config URL
if [ "${TRAVIS_TAG}" ]
then
    Gitenv="${TRAVIS_TAG}"
elif [ "${TRAVIS_BRANCH}" ]
then
    Gitenv="${TRAVIS_BRANCH}"
fi

[ -z "$Gitenv" ] && Gitenv="V2"
[ -z "$InstallDir" ] && InstallDir=~/VSCode-Anywhere || InstallDir=$(realpath $InstallDir)
[ -z "$SaltVersion" ] && SaltVersion="3001"
[ -z "$Profile" ] && Profile="linux_user"

# VSCode
Apps="${InstallDir}/apps"
SaltstackDir="${Apps}/saltstack"
ConfDir="${InstallDir}/conf"

# Saltstack
SaltstackDir="${Apps}/saltstack"
SaltstackSrcDir="${SaltstackDir}/src"
SaltstackConfDir="${ConfDir}/saltstack/conf"
SaltstackConfDirMinion="${SaltstackConfDir}/minion.d"
SaltstackPillarDir="${ConfDir}/saltstack/pillar"
SaltstackRootsDir="${ConfDir}/saltstack/states"

# Junest
JunestAppPath="${Apps}/junest"
JunestAppPathInstall="${JunestAppPath}/install"
JunestAppPathChroot="${JunestAppPath}/chroot"
JunestBin="${JunestAppPathInstall}/bin/junest"
# Proot
# export PROOT_NO_SECCOMP=1

# Homebrew
BrewAppPath="${Apps}/linuxbrew"

# Nixpkgs
NixpkgsAppPath="${Apps}/nixpkgs"
NixAppPath="${NixpkgsAppPath}/nix"
# NixHome="${NixpkgsAppPath}/home"
NixConfig="${NixpkgsAppPath}/conf"
NixProfiles="${NixpkgsAppPath}/profiles"

# vscode-anywhere-chroot
VSCAppPath="${Apps}/vscode-anywhere"
VSCHome="${VSCAppPath}/home" # Needed by NIX to avoid ~/.nix-defexpr and ~/.nix-profile
VSCBin="${VSCAppPath}/bin"
VSCChroot="${VSCBin}/vscode-anywhere-chroot"
VSCUser="VSCode-Anywhere" # Needed to avoid /nix/var/nix/profiles/per-user/<USER>/channels

############
#   CODE   #
############

# Init
# if [ "${Profile}" = "linux_user" -o "${Profile}" = "linux_admin" ]
# then
#     InstallHomebrew
# elif [ "${Profile}" = "linux_portable" ]
# then
#     InstallJunest
#     InstallJunestPkg "git"
# fi
# InstallSalt

Init
# InstallJunest
# InstallJunestPkg "git"
InstallNix
InstallNixPkg nixpkgs.gitMinimal nixpkgs.curl nixpkgs.patchelf # FIXME: Workaround => nixpkgs.patchelf (see https://discourse.brew.sh/t/2-installations-on-2-linux-distributions-2-different-behaviors/7259)
InstallHomebrew
NsCmd 'ln -s "$(command -v patchelf)" /home/linuxbrew/.linuxbrew/bin/patchelf' # FIXME: Workaround (see https://discourse.brew.sh/t/2-installations-on-2-linux-distributions-2-different-behaviors/7259)
NsCmd "brew install git; exit 0" # FIXME: Workaround (see https://discourse.brew.sh/t/2-installations-on-2-linux-distributions-2-different-behaviors/7259)
NsCmd "brew link --overwrite patchelf" # FIXME: Workaround (see https://discourse.brew.sh/t/2-installations-on-2-linux-distributions-2-different-behaviors/7259)
InstallSalt
InstallVSCodeAnywhere
