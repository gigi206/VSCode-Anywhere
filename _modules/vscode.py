"""
Support for VSCode (https://code.visualstudio.com)
"""

import salt.utils.path
import salt.utils.platform
import salt.utils.files
import salt.utils.json
import salt.exceptions
import pathlib
import re
import os


def __virtual__():
    """
    Only load if code.cmd exists on the system
    """
    if (
        salt.utils.platform.is_windows()
        or salt.utils.platform.is_linux()
        or salt.utils.platform.is_darwin()
    ):
        return True
    else:
        return (False, "{} platform is not supported".format(__grains__["kernel"]))


def _settings_path(path):
    """
    Return the path for the VSCode settings file

    Args

        path (str)

    Returns

        str:
            path
    """
    if path is None:
        if salt.utils.platform.is_windows():
            # path = __salt__["cmd.run"](
            #     "Write-Output ${env:APPDATA}\\Code\\User\\settings.json",
            #     shell="powershell",
            #     python_shell=False,
            # )
            # path = os.path.expandvars("%APPDATA%\\Code\\User\\settings.json")
            path = os.path.join(
                __salt__["grains.get"]("vscode-anywhere:apps:path"),
                "scoop",
                "persist",
                "vscode",
                "user",
                "User",
                "settings.json",
            )
        elif salt.utils.platform.is_linux():
            # path = __salt__["cmd.run"](
            #     "echo ${HOME}/.config/Code/User/settings.json", python_shell=False
            # )
            # path = os.path.expandvars("${HOME}/.config/Code/User/settings.json")
            raise salt.exceptions.CommandExecutionError(
                "Need to be configured for Linux"
            )
        elif salt.utils.platform.is_darwin():
            # path = __salt__["cmd.run"](
            #     "echo ${HOME}/Library/Application Support/Code/User/settings.json",
            #     python_shell=False,
            # )
            # path = os.path.expandvars("${HOME}/Library/Application Support/Code/User/settings.json")
            raise salt.exceptions.CommandExecutionError("Need to be configured for Mac")
    if not os.path.isdir(os.path.dirname(path)):
        pathlib.Path(str(os.path.dirname(path))).mkdir(parents=True)
        open(path, "w").write("{}")
    return os.path.expandvars(path)


def _keybindings_path(path):
    """
    Return the path for the VSCode keybindings file

    Args

        path (str)

    Returns

        str:
            path
    """
    if path is None:
        if salt.utils.platform.is_windows():
            # path = __salt__["cmd.run"](
            #     "Write-Output ${env:APPDATA}\\Code\\User\\settings.json",
            #     shell="powershell",
            #     python_shell=False,
            # )
            # path = os.path.expandvars("%APPDATA%\\Code\\User\\keybindings.json")
            path = os.path.join(
                __salt__["grains.get"]("vscode-anywhere:apps:path"),
                "scoop",
                "persist",
                "vscode",
                "user",
                "User",
                "keybindings.json",
            )
        elif salt.utils.platform.is_linux():
            # path = __salt__["cmd.run"](
            #     "echo ${HOME}/.config/Code/User/settings.json", python_shell=False
            # )
            # path = os.path.expandvars("${HOME}/.config/Code/User/keybindings.json")
            raise salt.exceptions.CommandExecutionError(
                "Need to be configured for Linux"
            )
        elif salt.utils.platform.is_darwin():
            # path = __salt__["cmd.run"](
            #     "echo ${HOME}/Library/Application Support/Code/User/settings.json",
            #     python_shell=False,
            # )
            # path = os.path.expandvars(
            #     "${HOME}/Library/Application Support/Code/User/keybindings.json"
            # )
            raise salt.exceptions.CommandExecutionError("Need to be configured for Mac")

    if not os.path.isdir(os.path.dirname(path)):
        pathlib.Path(str(os.path.dirname(path))).mkdir(parents=True)
        open(path, "w").write("[]")
    return os.path.expandvars(path)


def _write_settings(path, settings, indent=4):
    """
    Write new settings to the VSCode settings file

    Args

        path (str):
            path of the VSCode settingsfile

        settings(dict):
            settings to write

        indent (int):
            Number of spaces for indentation in the VSCode settings file

    Returns

        None
    """
    dump = salt.utils.json.dumps(settings, indent=indent, sort_keys=True)
    with salt.utils.files.fopen(path, "w") as _f:
        try:
            _f.write(dump)
        except Exception as e:
            raise salt.exceptions.CommandExecutionError(
                "Unable to write settings to {} => {}".format(path, e)
            )


def extensions_installed(dir=None, path="code"):
    """
    List all installed VSCode extensions.

    Args

        dir (str):
            specify the directory path where the extensions are installed

    Returns

        list:
            list of installed extensions

            [
                {'name':  '<extension name>', 'version': '<extension version>'},
                {...}
            ]

    CLI Example:

        salt '*' vscode.extensions_installed
        salt '*' vscode.extensions_installed dir=<custom extension directory>
    """
    cmd = [path, "--list-extensions", "--show-versions"]

    if dir:
        cmd.extend(["--extensions-dir", dir])

    ret = __salt__["cmd.run_all"](cmd, python_shell=False)

    if ret["retcode"] == 0:
        return [
            {
                "name": "@".join(extension.split("@")[:-1]).lower(),
                "version": extension.split("@")[-1],
            }
            for extension in ret["stdout"].strip().splitlines()
        ]
    else:
        return []


def is_extension_installed(extension, dir=None, path="code"):
    """
    Return True if extension is installed

    Args

        extension (str):
            extension to check if installed

        dir (str):
            specify the directory path where the extensions are installed

    Returns

        bool:
            True if extension is installed

    .. code-block:: bash

    CLI Example:

        salt '*' vscode.is_extension_installed <extension>
        salt '*' vscode.is_extension_installed <extension> dir=<custom extension directory>
    """
    return extension.lower() in [
        ext["name"] for ext in extensions_installed(dir=dir, path=path)
    ]


def extension_version(extension, dir=None, path="code"):
    """
    Return the version of an extension

    Args

        extension (str):
            extension name

        dir (str):
            specify the directory path where the extensions are installed

    Returns

        str or None:
            version of the current installed extension or return None if extension does not exist

    .. code-block:: bash

    CLI Example:

        salt '*' vscode.extension_version <extension>
        salt '*' vscode.extension_version <extension> dir=<custom extension directory>
    """
    if is_extension_installed(extension, dir=dir, path=path):
        return [
            ext["version"]
            for ext in extensions_installed(dir=dir, path=path)
            if ext["name"].lower() == extension.lower()
        ][0]
    else:
        return None


def extension_install(extension, version=None, dir=None, path="code"):
    """
    Install VSCode extension.

    Args

        extension (str):
            extension to install

        version (str):
            Install a specific version of the package. Defaults to latest version.
            Default is None.

        dir (str):
            specify the directory path where the extensions are installed

    Returns

        int:
            retcode

        str:

            stderr
        str:

            stdout

    CLI Example:

    .. code-block:: bash

        salt '*' vscode.extension_install <extension name>
        salt '*' vscode.extension_install <extension name> version=<extension version>
        salt '*' vscode.extension_install <extension name> version=<extension version> dir=<custom extension directory>
    """
    if version:
        extension += "@" + str(version)

    cmd = [path, "--install-extension", extension]

    if dir:
        cmd.extend(["--extensions-dir", dir])

    ret = __salt__["cmd.run_all"](cmd, python_shell=False)
    return ret


def extension_latest(extension, dir=None, path="code"):
    """
    Update a VSCode extension. Extension will be installed if not.

    Args

        extension (str):
            extension to update

        dir (str):
            specify the directory path where the extensions are installed

    Returns

        dict:
            int:
                retcode

            str:
                stderr

            str:
                stdout

    CLI Example:

    .. code-block:: bash

        salt '*' vscode.extension_latest <extension name>
        salt '*' vscode.extension_latest <extension name> dir=<custom extension directory>
    """
    cmd = [path, "--force", "--install-extension", extension]

    if dir:
        cmd.extend(["--extensions-dir", dir])

    ret = __salt__["cmd.run_all"](cmd, python_shell=False)
    return ret


def extension_uninstall(extension, dir=None, path="code"):
    """
    Uninstall VSCode extension.

    Args

        extension (str):
            extension to uninstall

        dir (str):
            specify the directory path where the extensions are installed

    Returns

        int: retcode
        str: stderr
        str: stdout

    CLI Example:

    .. code-block:: bash

        salt '*' vscode.extension_uninstall <extension name>
        salt '*' vscode.extension_uninstall <extension name> dir=<custom extension directory>
    """
    cmd = [path, "--uninstall-extension", extension]

    if dir:
        cmd.extend(["--extensions-dir", dir])

    ret = __salt__["cmd.run_all"](cmd, python_shell=False)
    return ret


def keybindings_get_all(path=None, ignore_comments=True):
    """
    Read all keybindings from VSCode.

    Args

        path (str):
            path of the keybindings file

        ignore_comments (bool):
            json doesn't support comments. Remove all comments from file for avoid errors when parsing json

    Returns

        list:
            list of keybindings

    CLI Example:

    .. code-block:: bash

        salt '*' vscode.keybindings_get_all
        salt '*' vscode.keybindings_get_all path=<keybindings path> ignore_comments=<bool>
    """
    path = _keybindings_path(path)

    if os.path.isfile(path):
        lines = []
        with salt.utils.files.fopen(path) as _f:
            for line in _f.readlines():
                if ignore_comments:
                    match = re.search("^[^/]*", line)
                    if match:
                        lines.append(match.group(0).strip())
                else:
                    lines.append(line)
    else:
        return []

    try:
        return salt.utils.json.loads("\n".join(lines))
    except Exception:
        raise salt.exceptions.CommandExecutionError(
            "{} is not a valid json file".format(path)
        )


def is_keybindings_set(key, when=None, path=None, ignore_comments=True):
    """
    Check if the keybinding is defined

    Args

        keybindings (dict):
            keybindings to check

        path (str):
            path of the keybindings file

        ignore_comments (bool):
            json doesn't support comments. Remove all comments from file for avoid errors when parsing json

    Returns

        bool:
            True if keybinding is set else False

    CLI Example:

    .. code-block:: bash

        salt '*' vscode.is_keybindings_set
        salt '*' vscode.is_keybindings_set path=<keybindings path> ignore_comments=<bool>
    """
    for keybindings in keybindings_get_all(path, ignore_comments=ignore_comments):
        if keybindings.get("key") == key:
            if when is not None and when != keybindings.get("when"):
                return False
            else:
                return True
    return False


def keybindings_get(key, when=None, path=None, ignore_comments=True):
    """
    Get the keybindings

    Args

        keybindings (dict):
            keybindings to get

        path (str):
            path of the keybindings file

        ignore_comments (bool):
            json doesn't support comments. Remove all comments from file for avoid errors when parsing json

    Returns:

        dict:
            keybinding if found else None

    CLI Example:

    .. code-block:: bash

        salt '*' vscode.is_keybindings_get
        salt '*' vscode.is_keybindings_get path=<keybindings path> ignore_comments=<bool>
    """
    for keybindings in keybindings_get_all(path, ignore_comments=ignore_comments):
        if keybindings.get("key") == key:
            if (when is not None and keybindings.get("when") == when) or when is None:
                return keybindings
    return None


def keybindings_remove(key, when=None, path=None, ignore_comments=True, indent=4):
    """
    Remove the specified keybindings

    Args

        keybindings (dict):
            keybindings to remove

        path (str):
            path of the keybindings file

        ignore_comments (bool):
            json doesn't support comments. Remove all comments from file for avoid errors when parsing json

    Returns

        bool:
            True

    CLI Example:

    .. code-block:: bash

        salt '*' vscode.keybindings_remove
        salt '*' vscode.keybindings_remove key=<keybindings key> path=<keybindings path> ignore_comments=<bool>
    """
    path = _keybindings_path(path)
    keys = []
    for keybindings in keybindings_get_all(path, ignore_comments=ignore_comments):
        if keybindings.get("key") == key:
            if not (
                (when is not None and keybindings.get("when") == when) or when is None
            ):
                keys.append(keybindings)
        else:
            keys.append(keybindings)

    _write_settings(path, keys, indent=indent)
    return True


def keybindings_set(key, command, when=None, path=None, ignore_comments=True, indent=4):
    """
    Set the specified keybindings

    Args

        keybindings (dict):
            keybindings to set

        path (str):
            path of the keybindings file

        ignore_comments (bool):
            json doesn't support comments. Remove all comments from file for avoid errors when parsing json

    Returns

        bool:
            True

    CLI Example:

    .. code-block:: bash

        salt '*' vscode.keybindings_remove
        salt '*' vscode.keybindings_remove key=<keybindings key> path=<keybindings path> ignore_comments=<bool>
    """
    path = _keybindings_path(path)
    found = False
    keys = []
    for keybindings in keybindings_get_all(path, ignore_comments=ignore_comments):
        if keybindings.get("key") == key:
            if (when is not None and keybindings.get("when") == when) or when is None:
                keys.append({"key": key, "command": command, "when": when})
                found = True
            else:
                keys.append(keybindings)
        else:
            keys.append(keybindings)

    if found is False:
        keys.append({"key": key, "command": command, "when": when})

    _write_settings(path, keys, indent=indent)
    return True


def settings_get_all(path=None, ignore_comments=True):
    """
    Read all settings from VSCode.

    Args

        path (str):
            path of the settings file

        ignore_comments (bool):
            json doesn't support comments. Remove all comments from file for avoid errors when parsing json

    Returns

        dict:
            dict of settings

    CLI Example:

    .. code-block:: bash

        salt '*' vscode.settings_get_all
        salt '*' vscode.settings_get_all path=<settings path> ignore_comments=<bool>
    """
    path = _settings_path(path)

    if os.path.isfile(path):
        lines = []
        with salt.utils.files.fopen(path) as _f:
            for line in _f.readlines():
                if ignore_comments:
                    match = re.search("^[^/]*", line)
                    if match:
                        lines.append(match.group(0).strip())
                else:
                    lines.append(line)
    else:
        return {}

    try:
        return salt.utils.json.loads("\n".join(lines))
    except Exception:
        raise salt.exceptions.CommandExecutionError(
            "{} is not a valid json file".format(path)
        )


def settings_get(key, path=None, ignore_comments=True):
    """
    Read all settings from VSCode.

    Args

        key (str):
            key settings to request

        path (str):
            path of the settings file

        ignore_comments (bool):
            json doesn't support comments. Remove all comments from file for avoid errors when parsing json

    Returns

        dict:
            dict of settings

    CLI Example:

    .. code-block:: bash

        salt '*' vscode.settings_get
        salt '*' vscode.settings_get key=<settings key> path=<settings path> ignore_comments=<bool>
    """
    path = _settings_path(path)
    settings = settings_get_all(path=path, ignore_comments=ignore_comments)
    if isinstance(settings, dict):
        return settings.get(key, None)
    else:
        return None


def settings_remove(key, path=None, remove_comments=True, indent=4):
    """
    Remove a entry from settings

    Args

        key (str):
            key settings to request

        path (str):
            path of the settings file

        remove_comments (bool):
            json doesn't support comments. Remove all comments from file for avoid errors when parsing json

        indent:
            spaces indentation in VSCode settings

    Returns

        bool:
            True

    CLI Example:

    .. code-block:: bash

        salt '*' vscode.settings_remove
        salt '*' vscode.settings_remove key=<settings key> path=<settings path> ignore_comments=<bool>
    """
    path = _settings_path(path)
    settings = settings_get_all(path=path, ignore_comments=remove_comments)

    if settings.get(key, None) is None:
        return True
    else:
        del settings[key]

    _write_settings(path, settings, indent=indent)
    return True


def settings_set(key, value, path=None, remove_comments=True, indent=4):
    """
    Apply settings in VSCode.

    Args

        key (str):
            setting key to set

        value (str):
            setting value to set for the key

        path (str):
            path of the settings file

        remove_comments (bool):
            json doesn't support comments. Remove all comments from file for avoid errors when parsing json

        indent:
            spaces indentation in VSCode settings

    Returns

        bool:
            True

    CLI Example:

    .. code-block:: bash

        salt '*' vscode.settings_set <settings key> value=<settings value>
        salt '*' vscode.settings_set <settings key> value=<settings value> path=<settings path>
    """
    path = _settings_path(path)
    settings = settings_get_all(path=path, ignore_comments=remove_comments)
    settings[key] = value
    _write_settings(path, settings, indent=indent)
    return True
