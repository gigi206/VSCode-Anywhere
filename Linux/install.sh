#!/usr/bin/env bash
############
#   INFO   #
############
#
# Author : Ghislain LE MEUR
# URL    : https://github.com/gigi206/VSCode-Anywhere

set -o pipefail

##############
#   Params   #
##############

# Define parameters for VSCode-Anywhere
function Params {
    # Execute getopt on the arguments passed to this program, identified by the special character ${@}
    eval set -- $(getopt -n "${0}" -o hufldp:c:a: --long 'help,update,fonts,link,path:,conf:,user_conf:' -- "${@}")

    # Now goes through all the options with a case and using shift to analyse 1 argument at a time
    # ${1} identifies the first argument, and when we use shift we discard the first argument, so $2 becomes ${1} and goes again through the case
    while true
    do
        case "${1}" in
            -h|--help)
                usage
                shift
            ;;

            -u|--update)
                update=1
                shift
            ;;

            -f|--fonts)
                fonts=1
                shift
            ;;

            -l|--link)
                link=1
                shift
            ;;

            -d|--delete)
                delete=1
                shift
            ;;

            -p|--path)
                [ -n "${2}" ] && path="${2}"
                shift 2
            ;;

            -c|--conf)
                [ -n "${2}" ] && conf="${2}"
                shift 2
            ;;

            -a|--user_conf)
                [ -n "${2}" ] && user_conf="${2}"
                shift 2
            ;;

            --)
                shift
                break
            ;;

            *)
                usage
            ;;
        esac
    done
}

############
#   FUNC   #
############

# Help function
function usage {
    echo "${ProgramName} usage :"
    echo "    -h | --help   : print this help"
    echo "    -c | --config : configuration file path"
    echo "    -p | --path   : installation directory path"
    echo "    -u | --update : update all components to the latest version"
    echo "    -f | --fonts  : reinstall fonts (if you change computer for example)"
    echo "    -l | --link   : needed if you change computer or change the install diirectory"
    echo "    -d | --delete : delete chroot directory"
    exit 0
}

# Output header
function InstallAppHeader {
    message="${*}"

    tput setaf 2
    echo                                                                   2>&1 | tee -a "${Log}"
    echo "/============================================================="  2>&1 | tee -a "${Log}"
    echo "|"                                                               2>&1 | tee -a "${Log}"
    echo "| ${message}"                                                    2>&1 | tee -a "${Log}"
    echo "|"                                                               2>&1 | tee -a "${Log}"
    echo "\\=============================================================" 2>&1 | tee -a "${Log}"
    tput sgr0
}

# Output actions to console
function Output {
    message="${1}"

    echo -en "\\n$(tput setaf 2)* $(tput setaf 6)"
    eval echo '${message}' 2>&1 | tee -a "${Log}"
    tput sgr0
}

# Output errors to console
function OutputErrror {
    message="${1}"
    exit="${2}"

    tput setaf 1
    tput bold
    >&2 echo -e "\\nError : ${message}\\n"
    echo -e "\\nError : ${message}\\n" >> "${Log}"
    tput sgr0
    Finish "${exit:-1}"
}

# Run shell Command
function Cmd {
    cmd="${1}"
    exit="${2}"

    echo -e "\\n\\n>>> ${cmd} (Cmd) <<<" &>> "${Log}"

    eval ${cmd} 2>&1 | tee -a "${Log}"

    ret_code="${?}"

    if [ ${ret_code} -ne 0 ]
    then
        if [ "${exit}" ]
        then
            OutputErrror "A critical error has occurred !" "${exit:-1}"
        else
            tput setaf 1
            tput bold
            >&2 echo -e "\\nError : an error has occurred (not critical)\\n"
            echo -e "\\nError : an error has occurred (not critical)\\n" >> "${Log}"
            tput sgr0
        fi
    fi
}

# Run Junest command
function JunestCmd {
    cmd="${1}"
    type="${2}"
    exit="${3}"

    echo -e "\\n\\n>>> ${cmd} (JunestCmd) <<<" &>> "${Log}"
if [ "$type" = 'proot' ]
then
    chroot_type='-f'
else
    chroot_type='-u'
fi

    HOME="${Home_chroot}" JUNEST_HOME="${JunestAppPath_chroot}" "${JunestAppPath_bin}" ${chroot_type} -p "-b ${JunestAppPath_home}:${Home_chroot} -b /:/${JunestExternalPath}" /bin/bash -l << EOF 2>&1 | tee -a "${Log}"
${cmd}
EOF

    ret_code=${?}

    if [ ${ret_code} -ne 0 ]
    then
        if [ "${exit}" ]
        then
            OutputErrror "A critical error has occurred !" "${exit:-1}"
        else
            tput setaf 1
            tput bold
            echo -e "\\nError : an error has occurred (not critical)\\n" 2>&1 | tee -a "${Log}"
            tput sgr0
        fi
    fi
}

# First function called
function Init {
    for bin in wget tput tar realpath
    do
        # Check if $bin is installed
        [ -f "$(command -v ${bin})" ] &>/dev/null || OutputErrror "${bin} is mandatory !"
    done

    [ -f "${ProgramConfig}" ] || OutputErrror "configuration file ${ProgramConfig} doesn't exist ! Use option --conf to specify a valid config file path"

    [ -f "${ProgramConfigUser}" ] || OutputErrror "configuration file ${ProgramConfigUser} doesn't exist ! Use option --user_conf to specify a valid config file path"

    # Rename previous log file to logfile.old
    [ -f "${Log}" ] && Cmd "mv '${Log}' '${Log}.old'"

    # Create FontsDir / ToolsDir / ConfDir / Logdir
    mkdir -p "${LogDir}" # Don't merge this line with the bottom line (we need log dir before use Cmd function)
    Cmd "mkdir -p '${FontsDir}' '${ToolsDir}' '${ConfDir}'" 1

    # Copy install and config files to $ToolsDir
    if [ $(realpath $(dirname "${0}")) != "${ToolsDir}" ]
    then
        Cmd "cp -f '${0}' ${ToolsDir}/install.sh" 1
        Cmd "cp -f '${ProgramConfig}' '${ConfDir}/${ProgramName}.conf'" 1
        Cmd "cp -f '${ProgramConfigUser}' '${ConfDir}/User.conf'" 1
    fi

    # Configure proxy
    if [ -f "${JunestAppPath_bin}" ]
    then
        [ "$(GetConfig '.base.proxy.password')" != 'null' ] && proxy=":$(GetConfig '.base.proxy.password')"
        [ "$(GetConfig '.base.proxy.login')" != 'null' ] && proxy="$(GetConfig '.base.proxy.login')${proxy}@"
        [ "$(GetConfig '.base.proxy.url')" != 'null' ] && proxy="$(GetConfig '.base.proxy.url' | cut -d':' -f1)://${proxy}$(GetConfig '.base.proxy.url' | cut -d'/' -f3-)" && export http_proxy="${proxy}" && export https_proxy="${proxy}"
    fi
}

# Return current config in json format
function GetConfig {
    config="${1}"
    # Merge the 2 config files
    JunestCmd "jq -rs '.[0] * .[1]' '${JunestExternalPath}${ProgramConfig}' '${JunestExternalPath}${ProgramConfigUser}' | jq -r '${config}'" 'namespace' 1
}

# Install Junest for chroot
function InstallJunest {
    InstallAppHeader "Installing ${JunestAppName}"

    # Skip install if VSCode is already installed
    if [ -d "${JunestAppPath_install}" ] && [ -d "${JunestAppPath_chroot}" ]
    then
        Output "${JunestAppName} already installed (skipped). If you want to reinstall delete ${JunestAppPath_install} directory"
        return
    fi

    # Create Junest directory
    Cmd "mkdir -p '${JunestAppPath_home}'" 1

    # Install Junest
    Cmd "rm -fr '${JunestAppPath_install}'" 1

    Output "Downloading ${JunestAppName} binaries"
    Cmd "cd '${JunestAppPath}' && wget -q http://api.github.com/repos/fsquillace/junest/tarball -O - | tar xz && mv fsquillace-junest-* '${JunestAppPath_install}'" 1

    # Create chroot junest directory
    Cmd "mkdir -p '${JunestAppPath_chroot}'" 1

    # Init Junest
    Output "Installing ${JunestAppName} chroot"
    JunestCmd '' 'namespace'

    # Upgrade chroot packages (kill parent for avoid hang after pacman upgrade !)
    Output "Updating ${JunestAppName} chroot packages"
    update='pacman -Sy --noconfirm --needed --force archlinux-keyring; pacman --init; pacman-key --populate archlinux;yes y | LC_ALL=C pacman -Syu; kill -9 $((${$} - 1)) 2>/dev/null'
    JUNEST_HOME="${JunestAppPath_chroot}" "${JunestAppPath_bin}" -u /bin/bash -l -- 2>/dev/null << EOF
${update}
EOF

    # Generation locale (buggy with Proot)
    JunestCmd 'sed -i "s@^#\(${LANG}.*\)@\1@g" /etc/locale.gen' 'namespace'
    JunestCmd 'locale-gen' 'namespace'
    # Workaround with Proot
    #Cmd "I18NPATH='${JunestAppPath_chroot}/usr/share/i18n' localedef -i $(echo ${LANG} | cut -d '.' -f 1) -c -f $(echo ${LANG} | cut -d '.' -f 2) -A '${JunestAppPath_chroot}/usr/share/locale/locale.alias' --prefix='${JunestAppPath_chroot}' '${LANG}'"

    # Install requirements
    InstallJunestPkg git curl wget tar jq unzip adwaita-icon-theme

    # Reinstall junest bin from github for be to be able to git pull
    JunestCmd "git clone https://github.com/fsquillace/junest.git '${JunestExternalPath}${JunestAppPath_install}_tmp' --depth 1" 'namespace' 1
    Cmd "rm -fr '${JunestAppPath_install}' && mv '${JunestAppPath_install}_tmp' '${JunestAppPath_install}'" 1
}

# Install a package inside chroot
function InstallJunestPkg {
    Output "Install Junest packages : ${*}"
    JunestCmd "pacman -Qk ${*} 2>/dev/null || pacman -Sy --noconfirm --needed --force ${*}" 'namespace' 1
}

# Test Internet connection
function TestInternet {
    ping -c2 google.com -i 0.2 &>/dev/null || OutputErrror "your computer is not connected to Internet"
}

# Install last VSCode application
function InstallVSCode {
    InstallAppHeader "Installing ${VSCAppName}"

    # Skip install if VSCode is already installed
    if [ -f "${VSCAppPath_install}/code" ]
    then
        Output "${VSCAppName} already installed (skipped). If you want to reinstall delete ${VSCAppPath_install} directory"
        return
    fi

    # Install dependancies
    InstallJunestPkg gtk3 nss libxkbfile libxtst libxss gconf alsa-lib gsfonts git

    # Define last tag version for download VSCode
    VSCTag=$(JunestCmd "git ls-remote --tags https://github.com/Microsoft/vscode.git | egrep 'refs/tags/[0-9]+\\.[0-9]+\\.[0-9]+$' | sort -t '/' -k 3 -V | tail -1 | cut -f3 -d '/'" 'namespace' 1)
    VSCUrl="https://vscode-update.azurewebsites.net/${VSCTag}/linux-x64/stable"

    # Create install directories
    Output "Create ${VSCAppPath_extensions} and ${VSCAppPath_user_data} directories"
    Cmd "mkdir -p '${VSCAppPath_extensions}' '${VSCAppPath_user_data}'" 1

    Output "Installing ${VSCAppName} ${VSCTag}"

    # Download latest VSCode zip file
    JunestCmd "cd '${JunestExternalPath}${VSCAppPath}' && rm -fr VSCode-linux-x64 '${JunestExternalPath}${VSCAppPath_install}' && curl -L '${VSCUrl}' > '${VSCAppName}.tar.gz' && tar --no-same-owner -xzf '${VSCAppName}.tar.gz' && mv VSCode-linux-x64 '${JunestExternalPath}${VSCAppPath_install}' && rm '${VSCAppName}.tar.gz'" 'namespace' 1

    # Create User directory
    JunestCmd "mkdir -p '${VSCAppPath_user_data}/User'" 'namespace' 1

    # Install language pack
    case $(echo ${LANG} | cut -d '.' -f 1) in
        en_*)
        ;;
        fr_*)
            InstallVSCPkg MS-CEINTL.vscode-language-pack-fr
            JunestCmd "echo '{ \"locale\": \"fr\" }' > '${VSCAppPath_user_data}/User/locale.json'" 'namespace'
        ;;
        es_*)
            InstallVSCPkg ms-ceintl.vscode-language-pack-es
            JunestCmd "echo '{ \"locale\": \"es\" }' > '${VSCAppPath_user_data}/User/locale.json'" 'namespace'
        ;;
        de_*)
            InstallVSCPkg ms-ceintl.vscode-language-pack-de
            JunestCmd "echo '{ \"locale\": \"de\" }' > '${VSCAppPath_user_data}/User/locale.json'" 'namespace'
        ;;
        it_*)
            InstallVSCPkg ms-ceintl.vscode-language-pack-it
            JunestCmd "echo '{ \"locale\": \"it\" }' > '${VSCAppPath_user_data}/User/locale.json'" 'namespace'
        ;;
        ja_*)
            InstallVSCPkg ms-ceintl.vscode-language-pack-ja
            JunestCmd "echo '{ \"locale\": \"ja\" }' > '${VSCAppPath_user_data}/User/locale.json'" 'namespace'
        ;;
        pt_BR)
            InstallVSCPkg ms-ceintl.vscode-language-pack-pt-br
            JunestCmd "echo '{ \"locale\": \"pt-br\" }' > '${VSCAppPath_user_data}/User/locale.json'" 'namespace'
        ;;
        ru_*)
            InstallVSCPkg ms-ceintl.vscode-language-pack-ru
            JunestCmd "echo '{ \"locale\": \"ru\" }' > '${VSCAppPath_user_data}/User/locale.json'" 'namespace'
        ;;
        tr_*)
            InstallVSCPkg ms-ceintl.vscode-language-pack-tr
            JunestCmd "echo '{ \"locale\": \"tr\" }' > '${VSCAppPath_user_data}/User/locale.json'" 'namespace'
        ;;
        hu_*)
            InstallVSCPkg ms-ceintl.vscode-language-pack-hu
            JunestCmd "echo '{ \"locale\": \"hu\" }' > '${VSCAppPath_user_data}/User/locale.json'" 'namespace'
        ;;
        ko_*)
            InstallVSCPkg ms-ceintl.vscode-language-pack-ko
            JunestCmd "echo '{ \"locale\": \"ko\" }' > '${VSCAppPath_user_data}/User/locale.json'" 'namespace'
        ;;
        bg_*)
            InstallVSCPkg ms-ceintl.vscode-language-pack-bg
            JunestCmd "echo '{ \"locale\": \"bg\" }' > '${VSCAppPath_user_data}/User/locale.json'" 'namespace'
        ;;
        zh_CN)
            InstallVSCPkg ms-ceintl.vscode-language-pack-zh-hans
            JunestCmd "echo '{ \"locale\": \"zh-cn\" }' > '${VSCAppPath_user_data}/User/locale.json'" 'namespace'
        ;;
        zh_TW)
            InstallVSCPkg ms-ceintl.vscode-language-pack-zh-hant
            JunestCmd "echo '{ \"locale\": \"zh-tw\" }' > '${VSCAppPath_user_data}/User/locale.json'" 'namespace'
        ;;
        *)
            Output "No language pack found for $LANG"
    esac
}

# Install Zeal if enabled
function InstallZeal {
    InstallAppHeader "Installing ${ZealAppName}"

    if [ "$(GetConfig '.base.zeal_enabled')" = 'true' ]
    then
        Output "Installing ${ZealAppName}"
        InstallJunestPkg zeal libcanberra libxml2
        InstallVSCPkg 'deerawan.vscode-dash'
    fi
}

# Install VSCode plugins
function InstallVSCPkg {
    pkgs="${*}"

    for pkg in ${pkgs}
    do
        Output "Installing VSCode extension : ${pkg}"
        JunestCmd "'${JunestExternalPath}${VSCAppPath_install}/bin/code' --user-data-dir '${JunestExternalPath}${VSCAppPath_user_data}' --extensions-dir '${JunestExternalPath}${VSCAppPath_extensions}' --install-extension '${pkg}'" 'proot'
    done
}

# Install docsets for Zeal
function InstallZealPkg {
    # Install docsets only if Zeal is enabled
    if [ "$(GetConfig '.base.zeal_enabled')" = 'true' ]
    then
        [ -d "${ZealAppPath_docsets}" ] || Cmd "mkdir -p '${ZealAppPath_docsets}'" 1

        pkgs="${*}"

        for pkg in ${pkgs}
        do
            # Skip install if Zeal is already installed
            if [ -d "${ZealAppPath_docsets}/${pkg}.docset" ]
            then
                Output "Zeal docsets ${pkg} is already installed (skipped)"
                continue
            fi

            Output "Installing Zeal docset ${pkg}"

            # Request zeal api
            pkg_api=$(JunestCmd "curl -s http://api.zealdocs.org/v1/docsets | jq -r \".[] | select (.name==\\\"${pkg}\\\")\"" 'namespace')

            if [ "${pkg_api}" ]
            then
                pkg_url=$(JunestCmd "curl -Ls https://raw.githubusercontent.com/Kapeli/feeds/master/${pkg}.xml | xmllint --format --xpath 'string(/entry/url)' - 2>/dev/null" 'namespace')

                # Download docset
                JunestCmd "rm -fr ${JunestExternalPath}${ZealAppPath}/tmp && mkdir -p ${JunestExternalPath}${ZealAppPath}/tmp" 'namespace' 1
                [ "${pkg_url}" ] && JunestCmd "curl -L '${pkg_url}' | tar xz --no-same-owner -C '${JunestExternalPath}${ZealAppPath}/tmp' && mv ${JunestExternalPath}${ZealAppPath}/tmp/* ${JunestExternalPath}${ZealAppPath_docsets}/${pkg}.docset && rm -fr ${JunestExternalPath}${ZealAppPath}/tmp" 'namespace'

                # Generate icons
                JunestCmd "echo '${pkg_api}' | jq -r '.icon' | base64 -d > '${JunestExternalPath}${ZealAppPath_docsets}/${pkg}.docset/icon.png'" 'namespace'
                JunestCmd "echo '${pkg_api}' | jq -r '.icon2x' | base64 -d > '${JunestExternalPath}${ZealAppPath_docsets}/${pkg}.docset/icon@2x.png'" 'namespace'

                # Generate meta.json file
                JunestCmd "echo '${pkg_api}' | jq -r 'del(.sourceId, .versions, .icon, .icon2x, .id) + {\"version\": .versions[0]}' > '${JunestExternalPath}${ZealAppPath_docsets}/${pkg}.docset/meta.json'" 'namespace'
            else
                # Request zeal api
                pkg_api=$(JunestCmd "curl -s http://london.kapeli.com/feeds/zzz/user_contributed/build/index.json | jq -r '.docsets.${pkg}'" 'namespace')

                [ "${pkg_api}" = 'null' ] && echo "${pkg} not found !" && continue

                pkg_url="http://sanfrancisco.kapeli.com/feeds/zzz/user_contributed/build/${pkg}/${pkg}.tgz"

                # Download docset
                JunestCmd "rm -fr ${JunestExternalPath}${ZealAppPath}/tmp && mkdir -p ${JunestExternalPath}${ZealAppPath}/tmp" 'namespace'
                [ "${pkg_url}" ] && JunestCmd "curl -L '${pkg_url}' | tar xz --no-same-owner -C '${JunestExternalPath}${ZealAppPath}/tmp' && mv ${JunestExternalPath}${ZealAppPath}/tmp/* ${JunestExternalPath}${ZealAppPath_docsets}/${pkg}.docset && rm -fr ${JunestExternalPath}${ZealAppPath}/tmp" 'namespace'

                # Generate icons
                JunestCmd "echo '${pkg_api}' | jq -r '.icon' | base64 -d > '${JunestExternalPath}${ZealAppPath_docsets}/${pkg}.docset/icon.png'" 'namespace'
                JunestCmd "echo '${pkg_api}' | jq -r '.\"icon@2x\"' | base64 -d > '${JunestExternalPath}${ZealAppPath_docsets}/${pkg}.docset/icon@2x.png'" 'namespace'

                # Generate meta.json file
                JunestCmd "echo '${pkg_api}' | jq -r 'del(.author, .archive, .icon, .\"icon@2x\", .aliases, .specific_versions) | .title = .name | .name=\"${pkg}\"' > '${JunestExternalPath}${ZealAppPath_docsets}/${pkg}.docset/meta.json'" 'namespace'
            fi
        done
    fi
}

# Set settings inside VSCode
function SetVSCSettings {
    settings="$(eval echo ${*//\"/\\\"})"

    # Define VSCode settings file
    settings_path="${VSCAppPath_user_data}/User/settings.json"

    # Create settings file if doesn't exist
    [ -f "${settings_path}" ] || JunestCmd "echo {} > '${JunestExternalPath}${settings_path}'" 'namespace' 1

    # Apply config to current settings
    Output "Set VSCode settings : ${settings}"
    full_settings=$(JunestCmd "cat '${JunestExternalPath}${settings_path}' | jq -r '. + ${settings}'" 'namespace' 1)
    [ -n "${full_settings}" ] && JunestCmd "echo '${full_settings}' > '${JunestExternalPath}${settings_path}'" 'namespace' 1
}

# Set keyboard settings inside VSCode
function SetVSCKeyboard {
    settings="$(eval echo ${*//\"/\\\"})"

    # Define VSCode keyboard key bindings file
    keybindings_path="${VSCAppPath_user_data}/User/keybindings.json"

    # Create keyboard key bindings file if doesn't exist
    [ -f "${keybindings_path}" ] || JunestCmd "echo [] > '${JunestExternalPath}${keybindings_path}'" 'namespace' 1

    # Apply config to current settings
    Output "Set VSCode keyboard : ${settings}"
    full_settings=$(JunestCmd "cat '${JunestExternalPath}${keybindings_path}' | jq -r '. + ${settings} | unique'" 'namespace' 1)
    [ -n "${full_settings}" ] && JunestCmd "echo '${full_settings}' > '${JunestExternalPath}${keybindings_path}'" 'namespace' 1
}

# Install all references from config file
function InstallConfig {
    # For all settings extensions from config file
    for item in $(GetConfig '.extensions | keys_unsorted[]')
    do
        if [ $(GetConfig ".extensions.\"${item}\".enabled") = 'true' ]
        then
            InstallAppHeader "Installing ${item} in progress"

            # Call Cmd function if cmd_pre is defined
            [ $(GetConfig ".extensions.\"${item}\".cmd_pre | length") -gt 0 ] && GetConfig ".extensions.\"${item}\".cmd_pre[]" | while read -r cmd
            do
                Output "RUN command : ${cmd}"
                Cmd "${cmd}"
            done

            # Call JunestCmd function if junest_cmd_pre is defined
            [ $(GetConfig ".extensions.\"${item}\".junest_cmd_pre | length") -gt 0 ] && GetConfig ".extensions.\"${item}\".junest_cmd_pre[]" | while read -r cmd
            do
                Output "RUN Junest command : ${cmd}"
                JunestCmd "${cmd}" 'proot'
            done

            # Call InstallJunestPkg function if junest_pkg is defined
            [ $(GetConfig ".extensions.\"${item}\".junest_pkg | length") -gt 0 ] && InstallJunestPkg $(GetConfig ".extensions.\"${item}\".junest_pkg | join(\" \")")

            # Call InstallVSCPkg function if vsc_pkg is defined
            [ $(GetConfig ".extensions.\"${item}\".vsc_pkg | length") -gt 0 ] && InstallVSCPkg $(GetConfig ".extensions.\"${item}\".vsc_pkg | join(\" \")")

            # Call SetVSCSettings function if vsc_settings is defined
            [ $(GetConfig ".extensions.\"${item}\".vsc_settings | length") -gt 0 ] && SetVSCSettings $(GetConfig ".extensions.\"${item}\".vsc_settings")

            # Call SetVSCKeyboard function if vsc_keyboard is defined
            [ $(GetConfig ".extensions.\"${item}\".vsc_keyboard | length") -gt 0 ] && SetVSCKeyboard $(GetConfig ".extensions.\"${item}\".vsc_keyboard")

            # Call InstallZealPkg function if zeal_pkg is defined
            [ $(GetConfig ".extensions.\"${item}\".zeal_pkg | length") -gt 0 ] && InstallZealPkg $(GetConfig ".extensions.\"${item}\".zeal_pkg | join(\" \")")

            # Call Cmd function if cmd_post is defined
            [ $(GetConfig ".extensions.\"${item}\".cmd_post | length") -gt 0 ] && GetConfig ".extensions.\"${item}\".cmd_post[]" | while read -r cmd
            do
                Output "RUN command : ${cmd}"
                Cmd "${cmd}"
            done

            # Call JunestCmd function if junest_cmd_post is defined
            [ $(GetConfig ".extensions.\"${item}\".junest_cmd_post | length") -gt 0 ] && GetConfig ".extensions.\"${item}\".junest_cmd_post[]" | while read -r cmd
            do
                Output "RUN Junest command : ${cmd}"
                JunestCmd "${cmd}" 'proot'
            done
        fi
    done
}

# Create start script for run VScode
function MakeScriptVSC {
    # Define location
    ScriptFile="${ToolsDir}/${ProgramName}.sh"

    Output "Make VSC script file ${ScriptFile}"

    # Remove it if exists
    Cmd "rm -f '${ScriptFile}'" 1

    # Write code to script
    Cmd "echo '#!/usr/bin/env bash' >> '${ScriptFile}'" 1

    # Generate env
    for env in $(GetConfig "[.extensions[] | select(.enabled == true) | .vsc_env | select(.!= null) | keys_unsorted[]] | unique[]")
    do
        if [ "${env}" = 'PATH' ]
        then
            myenv=$(eval echo export ${env}=\\\"$(Cmd "GetConfig '.extensions[] | select(.enabled == true) | .vsc_env | select(. != null) | .PATH | select(. != null)' | tr '\\n' ':' | xargs" 1)\\\")
        elif [ "${env}" = 'LD_LIBRARY_PATH' ]
        then
            myenv=$(eval echo export ${env}=\\\"$(Cmd "GetConfig '.extensions[] | select(.enabled == true) | .vsc_env | select(. != null) | .LD_LIBRARY_PATH | select(. != null)' | tr '\\n' ':' | xargs" 1)\\\")
        else
            myenv=$(eval echo export ${env}=\\\"$(GetConfig "[.extensions[] | select(.enabled == true) | .vsc_env | select(. != null) | .${env} | select(. != null)][-1]")\\\")
        fi
        Cmd "echo '${myenv}' >> '${ScriptFile}'" 1
    done

    # Create shortcut
    echo "[Desktop Entry]
Name=${ProgramName}
Comment=Run ${ProgramName}
Exec='${ScriptFile}'
Icon=${VSCAppPath_install}/resources/app/resources/linux/code.png
Terminal=false
Type=Application
Categories=Utility;Application;
" > ${InstallDir}/${ProgramName}.desktop

    Cmd "chmod +x '${ScriptFile}' '${InstallDir}/${ProgramName}.desktop'" 1

    Cmd "echo 'unset FPATH' >> '${ScriptFile}'" 1
    Cmd "echo 'export JUNEST_HOME=\"${JunestAppPath_chroot}\"' >> '${ScriptFile}'" 1
    Cmd "echo 'export HOME=\"${Home_chroot}\"' >> '${ScriptFile}'" 1
    local VSCAppPath_install=$(echo ${JunestExternalPath}$(echo ${VSCAppPath_install} | sed "s@${InstallDir}\(.*\)@\1@g"))
    local VSCAppPath_user_data=$(echo ${JunestExternalPath}$(echo ${VSCAppPath_user_data} | sed "s@${InstallDir}\(.*\)@\1@g"))
    local VSCAppPath_extensions=$(echo ${JunestExternalPath}$(echo ${VSCAppPath_extensions} | sed "s@${InstallDir}\(.*\)@\1@g"))
    Cmd "echo '\"${JunestAppPath_bin}\" -u -p \"-b ${Home_real}:${Home_real} -b ${JunestAppPath_home}:${Home_chroot} -b ${ZealAppPath_docsets}:${Home_chroot}/.local/share/Zeal/Zeal/docsets -b ${InstallDir}:${JunestExternalPath}\" -- mkdir -p /run/user/$(id -u) \&\& \"${VSCAppPath_install}/bin/code\" --user-data-dir \"${VSCAppPath_user_data}\" --extensions-dir \"${VSCAppPath_extensions}\" \"\${@}\"' >> '${ScriptFile}'" 1
}

# Create start script for run Junest console
function MakeScriptJunest {
    # Define location
    ScriptFile="${ToolsDir}/${JunestAppName}.sh"

    Output "Make ${JunestAppName} script file ${ScriptFile}"

    # Remove it if exists
    Cmd "rm -f '${ScriptFile}'" 1

    # Write code to script
    Cmd "echo '#!/usr/bin/env bash' >> '${ScriptFile}'" 1

    # Generate env
    for env in $(GetConfig "[.extensions[] | select(.enabled == true) | .junest_env | select(.!= null) | keys_unsorted[]] | unique[]")
    do
        if [ "${env}" = 'PATH' ]
        then
            myenv=$(eval echo export ${env}=\\\"$(Cmd "GetConfig '.extensions[] | select(.enabled == true) | .junest_env | select(. != null) | .PATH | select(. != null)' | tr '\\n' ':' | xargs" 1)\\\")
        elif [ "${env}" = 'LD_LIBRARY_PATH' ]
        then
            myenv=$(eval echo export ${env}=\\\"$(Cmd "GetConfig '.extensions[] | select(.enabled == true) | .junest_env | select(. != null) | .LD_LIBRARY_PATH | select(. != null)' | tr '\\n' ':' | xargs" 1)\\\")
        else
            myenv=$(eval echo export ${env}=\\\"$(GetConfig "[.extensions[] | select(.enabled == true) | .junest_env | select(. != null) | .${env} | select(. != null)][-1]")\\\")
        fi
        Cmd "echo '${myenv}' >> '${ScriptFile}'" 1
    done

    # Create shortcut
    echo "[Desktop Entry]
Name=Terminal
Comment=Run ${JunestAppName} console
Exec='${ScriptFile}'
Icon=${JunestAppPath_chroot}/usr/share/icons/Adwaita/512x512/apps/utilities-terminal.png
Terminal=true
Type=Application
Categories=Utility;Application;
" > "${InstallDir}/Terminal.desktop"

    Cmd "chmod +x '${ScriptFile}' '${InstallDir}/Terminal.desktop'" 1

    # Relink HOME directory
    Cmd "rm -f \"${JunestAppPath_user_home}\" && ln -fs \"${Home_real}\" \"${JunestAppPath_user_home}\"" 1

    # Bookmark real HOME directory
    Cmd "echo 'file://${Home_real} HOME' > \"${JunestAppPath_home}/.gtk-bookmarks\""
    Cmd "echo 'file://${JunestExternalPath} VSCode-Anywhere' >> \"${JunestAppPath_home}/.gtk-bookmarks\""

    # Define terminal settings
    junest_terminal_opts="$(eval echo $(GetConfig '.base.junest_terminal_opts'))"

    # Write script for run terminal
    Cmd "echo 'export JUNEST_HOME=\"${JunestAppPath_chroot}\"' >> '${ScriptFile}'" 1
    Cmd "echo 'export HOME=\"${Home_chroot}\"' >> '${ScriptFile}'" 1
    Cmd "echo '\"${JunestAppPath_bin}\" -u -p \"-b ${Home_real}:${Home_real} -b ${JunestAppPath_home}:${Home_chroot} -b ${ZealAppPath_docsets}:${Home_chroot}/.local/share/Zeal/Zeal/docsets -b ${InstallDir}:${JunestExternalPath}\" ${junest_terminal_opts}' >> '${ScriptFile}'" 1
}

# Create script for Zeal
function MakeScriptZeal {
    if [ "$(GetConfig '.base.zeal_enabled')" = 'true' ]
    then
        Output "Make install script file ${InstallDir}/Documentation"

        # Define location
        ScriptFile="${ToolsDir}/${ZealAppName}.sh"

        # Remove it if exists
        Cmd "rm -f '${ScriptFile}'" 1

        # Write code to script
        Cmd "echo '#!/usr/bin/env bash' >> '${ScriptFile}'" 1

        # Generate env
        for env in $(GetConfig "[.extensions[] | select(.enabled == true) | .vsc_env | select(.!= null) | keys_unsorted[]] | unique[]")
        do
            if [ "${env}" = 'PATH' ]
            then
                myenv=$(eval echo export ${env}=\\\"$(Cmd "GetConfig '.extensions[] | select(.enabled == true) | .vsc_env | select(. != null) | .PATH | select(. != null)' | tr '\\n' ':' | xargs" 1)\\\")
            elif [ "${env}" = 'LD_LIBRARY_PATH' ]
            then
                myenv=$(eval echo export ${env}=\\\"$(Cmd "GetConfig '.extensions[] | select(.enabled == true) | .vsc_env | select(. != null) | .LD_LIBRARY_PATH | select(. != null)' | tr '\\n' ':' | xargs" 1)\\\")
            else
                myenv=$(eval echo export ${env}=\\\"$(GetConfig "[.extensions[] | select(.enabled == true) | .vsc_env | select(. != null) | .${env} | select(. != null)][-1]")\\\")
            fi
            Cmd "echo '${myenv}' >> '${ScriptFile}'" 1
        done

        # Create shortcut
        echo "[Desktop Entry]
Name=Documentation
Comment=Run ${ZealAppName}
Exec='${ScriptFile}'
Icon=${JunestAppPath_chroot}/usr/share/icons/hicolor/128x128/apps/zeal.png
Terminal=false
Type=Application
Categories=Utility;Application;
" > "${InstallDir}/Documentation.desktop"

        Cmd "chmod +x '${ScriptFile}' '${InstallDir}/Documentation.desktop'" 1

        # Write script for run Zeal
        Cmd "echo 'export JUNEST_HOME=\"${JunestAppPath_chroot}\"' >> '${ScriptFile}'" 1
        Cmd "echo 'export HOME=\"${Home_chroot}\"' >> '${ScriptFile}'" 1
        Cmd "echo '\"${JunestAppPath_bin}\" -u -p \"-b ${Home_real}:${Home_real} -b ${JunestAppPath_home}:${Home_chroot} -b ${ZealAppPath_docsets}:${Home_chroot}/.local/share/Zeal/Zeal/docsets -b ${InstallDir}:${JunestExternalPath}\" ${ZealAppName,,}' >> '${ScriptFile}'" 1
    fi
}

# Create script for new install
function MakeScriptInstall {
    Output "Make install script file ${ToolsDir}/Install"

    # Create shortcut
    echo "[Desktop Entry]
    Name=Install
    Comment=Install new section in ${ProgramName} like Python, Ruby, PHP...
    Exec='${ToolsDir}/install.sh'
    Icon=${JunestAppPath_chroot}/usr/share/icons/Adwaita/256x256/actions/system-run.png
    Terminal=true
    Type=Application
    Categories=Utility;Application;
    " > "${ToolsDir}/Install.desktop"

    Cmd "chmod +x '${ToolsDir}/Install.desktop'" 1
}

# Create script for updates
function MakeScriptUpdate {
    Output "Make install script file ${ToolsDir}/Update"

    # Create shortcut
    echo "[Desktop Entry]
    Name=Update
    Comment=Update all components with the last version
    Exec='${ToolsDir}/install.sh' --update
    Icon=${JunestAppPath_chroot}/usr/share/icons/Adwaita/256x256/apps/system-software-update.png
    Terminal=true
    Type=Application
    Categories=Utility;Application;
    " > "${ToolsDir}/Update.desktop"

    Cmd "chmod +x '${ToolsDir}/Update.desktop'" 1
}

# Install fonts
function MakeScriptInstallFonts {
    Output "Make install font script file ${ToolsDir}/InstallFonts"

    # Create shortcut
    echo "[Desktop Entry]
    Name=InstallFonts
    Comment=Reinstall fonts needed by ${ProgramName}
    Exec='${ToolsDir}/install.sh' --fonts
    Icon=${JunestAppPath_chroot}/usr/share/icons/Adwaita/256x256/apps/preferences-desktop-font.png
    Terminal=true
    Type=Application
    Categories=Utility;Application;
    " > "${ToolsDir}/InstallFonts.desktop"

    Cmd "chmod +x '${ToolsDir}/InstallFonts.desktop'" 1
}

# Link shortcuts to new path
function MakeScriptLink {
    # Define location
    ScriptFile="${ToolsDir}/Link.sh"

    Output "Make link script file ${ScriptFile}"

    # Remove it if exists
    Cmd "rm -f ${ScriptFile}" 1

    # For all settings extensions from config file
        # For all settings extensions from config file
    for item in $(GetConfig '.extensions | keys_unsorted[]')
    do
        if [ $(GetConfig ".extensions.\"${item}\".enabled") = 'true' ]
        then
            InstallAppHeader "Link ${item} in progress"

            # Call SetVSCSettings function if vsc_settings is defined
            [ $(GetConfig ".extensions.\"${item}\".vsc_settings | length") -gt 0 ] && SetVSCSettings $(GetConfig ".extensions.\"${item}\".vsc_settings")
        fi
    done

    # Write code to script
    Cmd "echo 'cd \"\$(dirname \${0})\"' >> '${ScriptFile}'" 1
    Cmd "echo 'cd ..' >> '${ScriptFile}'" 1
    Cmd "echo './$(basename $ToolsDir)/install.sh --link' >> '${ScriptFile}'" 1
    Cmd "chmod +x '${ScriptFile}'" 1
}

# Create scripts
function MakeScripts {
    InstallAppHeader "Make Tools scripts..."
    MakeScriptVSC
    MakeScriptJunest
    MakeScriptZeal
    MakeScriptInstall
    MakeScriptUpdate
    MakeScriptInstallFonts
    MakeScriptLink
}


# Update to the last config
function UpdateVSCodeAnywhere {
    if [ "${VSCodeAnywhereUpdate:-0}" -eq 1 ]
    then
        # Make sure all is already installed before updating
        InstallConfig

        Cmd "cp -a ${ToolsDir}/install-update.sh ${ToolsDir}/install.sh"
    else
        InstallAppHeader "Updating ${ProgramName}"

        # Backup current config file
        Output "Backup current configuration file ${ProgramConfig} to ${ProgramConfig}.bak"
        Cmd "cp -a '${ProgramConfig}' '${ProgramConfig}.bak'" 1

        # Download the last config file for update
        Output "Updating ${ProgramConfig} to the last version from ${ProgramConfigUrl}"
        Cmd "wget -q '${ProgramConfigUrl}' -O '${ProgramConfig}'" 1

        # Backup current script
        Output "Backup current script file ${ToolsDir}/install.sh to ${ToolsDir}/install.sh.bak"
        Cmd "cp -a '${ToolsDir}/install.sh' '${ToolsDir}/install.sh.bak'" 1

        # Download the last install script file for update
        Output "Updating ${ToolsDir}/install.sh to the last version from ${ProgramConfigUrl}"
        Cmd "wget -q '${InstallScriptUrl}' -O '${ToolsDir}/install-update.sh'" 1
        Cmd "chmod +x '${ToolsDir}/'*.sh" 1

        Cmd "VSCodeAnywhereUpdate=1 ${ToolsDir}/install-update.sh -u" 1
        exit
    fi
}

# Update Junest
function UpdateJunest {
    InstallAppHeader "Updating ${JunestAppName}"

    # Update junest source code
    Output "Update ${JunestAppName} source code"
    JunestCmd "cd '${JunestExternalPath}$JunestAppPath_install' && git pull origin master" 'namespace' 1

    # Update chroot packages
    Output "Update ${JunestAppName} chroot"
    JunestCmd 'yes y | LC_ALL=C pacman -Syu' 'namespace' 1
}

# Update VSCode
function UpdateVSCode {
    InstallAppHeader "Updating ${VSCAppName}"

    # Update VSCode
    if [ -f "${VSCAppPath_install}/resources/app/package.json" ]
    then
        VSCPkg=$(JunestCmd "cat ${JunestExternalPath}${VSCAppPath_install}/resources/app/package.json | jq -r '.version'" 'namespace' 1)
    else
        VSCPkg='Unknown'
    fi

    # Define last tag version for download VSCode
    VSCTag=$(JunestCmd "git ls-remote --tags https://github.com/Microsoft/vscode.git | egrep 'refs/tags/[0-9]+\\.[0-9]+\\.[0-9]+$' | sort -t '/' -k 3 -V | tail -1 | cut -f3 -d '/'" 'namespace' 1)
    VSCUrl="https://vscode-update.azurewebsites.net/${VSCTag}/linux-x64/stable"

    if [ "${VSCPkg}" != "${VSCTag}" ]
    then
        Output "Updating ${VSCAppName} from version ${VSCPkg} to ${VSCTag}"

        # Download latest VSCode zip file
        JunestCmd "cd '${JunestExternalPath}${VSCAppPath}' && curl -L '${VSCUrl}' > '${VSCAppName}.tar.gz' && tar --no-same-owner -xzf '${VSCAppName}.tar.gz' && rm -fr VSCode-linux-x64 '${JunestExternalPath}${VSCAppPath_install}' && mv VSCode-linux-x64 '${JunestExternalPath}${VSCAppPath_install}' && rm '${VSCAppName}.tar.gz'" 'namespace' 1
    else
        Output "VSCode is already to the latest version ${VSCPkg}"
    fi
}

# Update Zeal docsets
function UpdateZealPkg {
    pkgs="${*}"

    # Update docsets only if Zeal is enabled
    if [ "$(GetConfig '.base.zeal_enabled')" = 'true' ]
    then
        for pkg in ${pkgs}
        do
            # Request zeal api
            pkg_api=$(JunestCmd "curl -Ls http://api.zealdocs.org/v1/docsets | jq -r \".[] | select (.name==\\\"${pkg}\\\")\"" 'namespace')

            if [ "${pkg_api}" ]
            then
                pkg_url=$(JunestCmd "curl -Ls https://raw.githubusercontent.com/Kapeli/feeds/master/${pkg}.xml | xmllint --format --xpath 'string(/entry/url)' - 2>/dev/null" 'namespace')

                # Last version of the docset
                if [ $(JunestCmd "echo '${pkg_api}' | jq -r \".versions[0]\"" 'namespace') != 'null' ]
                then
                    version_api=$(JunestCmd "echo '${pkg_api}' | jq -r \".versions[0] + \\\"-\\\" + .revision\"" 'namespace')
                else
                    version_api=$(JunestCmd "echo '${pkg_api}' | jq -r \".revision\"" 'namespace')
                fi

                # Current version of the docset
                if [ $(JunestCmd "cat '${JunestExternalPath}${ZealAppPath_docsets}/${pkg}.docset/meta.json' | jq -r \".version\"" 'namespace') != 'null' ]
                then
                    version_installed=$(JunestCmd "cat '${JunestExternalPath}${ZealAppPath_docsets}/${pkg}.docset/meta.json' | jq -r \".version + \\\"-\\\" + .revision\"" 'namespace')
                else
                    version_installed=$(JunestCmd "cat '${JunestExternalPath}${ZealAppPath_docsets}/${pkg}.docset/meta.json' | jq -r \".revision\"" 'namespace')
                fi

                if [ "${version_api}" != "${version_installed}" ]
                then
                    Output "Updating Zeal docset ${pkg} from version ${version_installed} to ${version_api}"

                    # Delete previous version
                    Cmd "rm -fr ${ZealAppPath_docsets}/${pkg}.docset" 1

                    # Download docset
                    JunestCmd "rm -fr ${JunestExternalPath}${ZealAppPath}/tmp && mkdir -p ${ZealAppPath}/tmp" 'namespace' 1
                    [ "${pkg_url}" ] && JunestCmd "curl -L '${pkg_url}' | tar xz --no-same-owner -C '${JunestExternalPath}${ZealAppPath}/tmp' && mv ${JunestExternalPath}${ZealAppPath}/tmp/* ${JunestExternalPath}${ZealAppPath_docsets}/${pkg}.docset && rm -fr ${JunestExternalPath}${ZealAppPath}/tmp" 'namespace'

                    # Generate icons
                    JunestCmd "echo '${pkg_api}' | jq -r '.icon' | base64 -d > '${JunestExternalPath}${ZealAppPath_docsets}/${pkg}.docset/icon.png'" 'namespace'
                    JunestCmd "echo '${pkg_api}' | jq -r '.icon2x' | base64 -d > '${JunestExternalPath}${ZealAppPath_docsets}/${pkg}.docset/icon@2x.png'" 'namespace'

                    # Generate meta.json file
                    JunestCmd "echo '${pkg_api}' | jq -r 'del(.sourceId, .versions, .icon, .icon2x, .id) + {\"version\": .versions[0]}' > '${JunestExternalPath}${ZealAppPath_docsets}/${pkg}.docset/meta.json'" 'namespace'
                else
                    Output "Zeal docset ${pkg} is already to the last version ${version_installed}"
                fi
            else
                # Request zeal api
                pkg_api=$(JunestCmd "curl -s http://london.kapeli.com/feeds/zzz/user_contributed/build/index.json | jq -r '.docsets.${pkg}'" 'namespace')

                [ "${pkg_api}" = 'null' ] && echo "${pkg} not found !" && continue

                pkg_url="http://sanfrancisco.kapeli.com/feeds/zzz/user_contributed/build/${pkg}/${pkg}.tgz"


                version_api=$(JunestCmd "echo '${pkg_api}' | jq -r \".version\"" 'namespace')
                version_installed=$(JunestCmd "cat '${JunestExternalPath}${ZealAppPath_docsets}/${pkg}.docset/meta.json' | jq -r \".version\"" 'namespace')

                if [ "${version_api}" != "${version_installed}" ]
                then
                    Output "Updating Zeal docset ${pkg} from version ${version_installed} to ${version_api}"

                    # Delete previous version
                    Cmd "rm -fr ${ZealAppPath_docsets}/${pkg}.docset" 1

                    # Download docset
                    JunestCmd "rm -fr ${JunestExternalPath}${ZealAppPath}/tmp && mkdir -p ${JunestExternalPath}${ZealAppPath}/tmp" 'namespace'
                    [ "${pkg_url}" ] && JunestCmd "curl -L '${pkg_url}' | tar xz --no-same-owner -C '${JunestExternalPath}${ZealAppPath}/tmp' && mv ${JunestExternalPath}${ZealAppPath}/tmp/* ${JunestExternalPath}${ZealAppPath_docsets}/${pkg}.docset && rm -fr ${JunestExternalPath}${ZealAppPath}/tmp" 'namespace'

                    # Generate icons
                    JunestCmd "echo '${pkg_api}' | jq -r '.icon' | base64 -d > '${JunestExternalPath}${ZealAppPath_docsets}/${pkg}.docset/icon.png'" 'namespace'
                    JunestCmd "echo '${pkg_api}' | jq -r '.\"icon@2x\"' | base64 -d > '${JunestExternalPath}${ZealAppPath_docsets}/${pkg}.docset/icon@2x.png'" 'namespace'

                    # Generate meta.json file
                    JunestCmd "echo '${pkg_api}' | jq -r 'del(.author, .archive, .icon, .\"icon@2x\", .aliases) | .title = .name | .name=\"${pkg}\"' > '${JunestExternalPath}${ZealAppPath_docsets}/${pkg}.docset/meta.json'" 'namespace'
                else
                    Output "Zeal docset ${pkg} is already to the last version ${version_installed}"
                fi
            fi
        done
    fi
}

# Update VSCode and Third-Party
function Update {
    UpdateVSCodeAnywhere
    UpdateJunest
    UpdateVSCode

    # For all settings extensions from config file
    for item in $(GetConfig '.extensions | keys_unsorted[]')
    do
        if [ $(GetConfig ".extensions.\"${item}\".enabled") = 'true' ]
        then
            InstallAppHeader "Updating ${item}"

            # Call Cmd function if cmd_update is defined
            [ $(GetConfig ".extensions.\"${item}\".cmd_update | length") -gt 0 ] && GetConfig ".extensions.\"${item}\".cmd_update[]" | while read -r cmd
            do
                Output "RUN command : ${cmd}"
                Cmd "${cmd}"
            done

            # Call JunestCmd function if junest_cmd_update is defined
            [ $(GetConfig ".extensions.\"${item}\".junest_cmd_update | length") -gt 0 ] && GetConfig ".extensions.\"${item}\".junest_cmd_update[]" | while read -r cmd
            do
                Output "RUN Junest command : ${cmd}"
                JunestCmd "${cmd}" 'proot'
            done

            # Call InstallZealPkg function if zeal_pkg is defined
            [ $(GetConfig ".extensions.\"${item}\".zeal_pkg | length") -gt 0 ] && UpdateZealPkg $(GetConfig ".extensions.\"${item}\".zeal_pkg | join(\" \")")
        fi
    done
}

# Install all ttf files present in ${fonts}Dir
function InstallFonts {
    InstallAppHeader "Installing fonts"

    Cmd "mkdir -p ${Home_real}/.local/share/fonts" 1

    for font in $(ls "${FontsDir}"/*.ttf 2>/dev/null)
    do
        Output "Installing font ${font}"
        Cmd "cp -f '${font}' ${Home_real}/.local/share/fonts" 1
    done
}

# Uninstall Junest chroot
function UninstallJunest {
    InstallAppHeader "Deleting ${JunestAppPath_chroot}"
    JUNEST_HOME="${JunestAppPath_chroot}" "${JunestAppPath_bin}" -d
}

# Installation is finished
function Finish {
    exit="${1}"

    if [ "${VSCode_Anywhere_CI:-0}" -ne 1 ]
    then
        echo
        read -r -s -p 'Press enter to finish'
        echo -e "\\n"
    fi

    exit "${exit:-0}"
}


############
#   VARS   #
############

export ProgramName="VSCode-Anywhere"

# Parse arguments
Params "${@}"

# Define InstallDir var => path where is installed VSCode-Anywhere
if [ "${path}" ]
then
    export InstallDir="${path}/${ProgramName}"
elif [ "$(basename $(dirname $(realpath $(dirname ${0}))))" = "${ProgramName}" ]
then
    InstallDir="$(dirname $(realpath $(dirname ${0})))"
else
    InstallDir="$(realpath $(dirname ${0}))/${ProgramName}"

fi

export InstallDir

# Define ProgramConfig var => location of the configuration file
if [ "${conf}" ]
then
    ProgramConfig="$(realpath ${conf})"
elif [ "$(basename $(dirname $(realpath $(dirname ${0}))))" = "${ProgramName}" ]
then
    ProgramConfig="$(dirname $(realpath $(dirname ${0})))/Conf/${ProgramName}.conf"
else
    ProgramConfig="$(realpath $(dirname ${0}))/${ProgramName}.conf"
fi

# Define ProgramConfigUser var => location of the configuration user file
if [ "${user_conf}" ]
then
    ProgramConfigUser="$(realpath ${user_conf})"
elif [ "$(basename $(dirname $(realpath $(dirname ${0}))))" = "${ProgramName}" ]
then
    ProgramConfigUser="$(dirname $(realpath $(dirname ${0})))/Conf/User.conf"
else
    ProgramConfigUser="$(realpath $(dirname ${0}))/User.conf"
fi

# Config URL
if [ "${TRAVIS_TAG}" ]
then
    branch="${TRAVIS_TAG}"
elif [ "${TRAVIS_BRANCH}" ]
then
    branch="${TRAVIS_BRANCH}"
else
    branch='master'
fi

export ProgramConfigUrl="https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/${branch}/Linux/VSCode-Anywhere.conf"
export InstallScriptUrl="https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/${branch}/Linux/install.sh"

# Home user
export Home_real="$(echo ~)"
export Home_chroot="/home/${ProgramName}"

# Install vars
export ProgramConfig
export LogDir="${InstallDir}/Logs"
export Log="${LogDir}/install.log"
[ "${update}" = 1 ] && export Log="${LogDir}/update.log"
[ "${fonts}" = 1 ] && export Log="${LogDir}/fonts.log"
[ "${link}" = 1 ] && export Log="${LogDir}/link.log"
export ThirdParty="${InstallDir}/Third-Party"
export FontsDir="${ThirdParty}/Fonts"
export ToolsDir="${InstallDir}/Tools"
export ConfDir="${InstallDir}/Conf"

# VSCode
export VSCAppName="VSCode"
export VSCAppPath="${InstallDir}/${VSCAppName}"
export VSCAppPath_install="${VSCAppPath}/install"
export VSCAppPath_extensions="${VSCAppPath}/extensions"
export VSCAppPath_user_data="${VSCAppPath}/user-data"

# Junest
export JunestAppName="Junest"
export JunestAppPath="${ThirdParty}/${JunestAppName}"
export JunestAppPath_install="${JunestAppPath}/install"
export JunestAppPath_home="${JunestAppPath}/home"
export JunestAppPath_user_home="${JunestAppPath_home}/HOME"
export JunestAppPath_chroot="${JunestAppPath}/chroot"
export JunestAppPath_bin="${JunestAppPath_install}/bin/junest"
export JunestExternalPath="/${ProgramName}"

# Zeal
export ZealAppName="Zeal"
export ZealAppPath="${ThirdParty}/${ZealAppName}"
export ZealAppPath_install="${ZealAppPath}/install"
export ZealAppPath_bin="${ZealAppPath_install}/zeal"
export ZealAppPath_docsets="${ZealAppPath_install}/docsets"

# Proot
export PROOT_NO_SECCOMP=1


############
#   CODE   #
############

Init

if [ "${update}" = 1 ]
then
    TestInternet
    Update
    InstallAppHeader "Relink ${ZealAppName}"
    MakeScriptZeal
elif [ "${fonts}" = 1 ]
then
    InstallFonts
elif [ "${link}" = 1 ]
then
    MakeScripts
elif [ "${delete}" = 1 ]
then
    UninstallJunest
else
    TestInternet
    InstallJunest
    InstallVSCode
    InstallZeal
    InstallConfig
    MakeScripts
    InstallFonts
fi

InstallAppHeader "Congratulations, installation is finished !!!"

Finish