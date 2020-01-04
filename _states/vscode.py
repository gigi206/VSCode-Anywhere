"""
Support for VSCode (https://code.visualstudio.com)
"""

import salt.utils.platform


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


def extension_installed(name, version=None, dir=None, path="code"):
    """
    Install a VSCode extension.

    Args:

        name (str):
            extension to install

        version (str):
            Install a specific version of the package. Defaults to latest version.
            Default is None.

        dir (str):
            specify the directory path where the extensions are installed

    CLI Example:

    .. code-block:: bash

        salt '*' vscode.extension_installed <extension name>
        salt '*' vscode.extension_installed <extension name> version=<extension version>
        salt '*' vscode.extension_installed <extension name> version=<extension version> dir=<custom extension directory>
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}
    old_version = __salt__["vscode.extension_version"](name, dir=dir, path=path)

    if version is None and __salt__["vscode.is_extension_installed"](
        name, dir=dir, path=path
    ):
        ret["comment"] = "extension {} {} is already installed".format(
            name, old_version
        )
        return ret

    if version and version == old_version:
        ret["comment"] = "extension {} is in the desired version {}".format(
            name, version
        )
        return ret

    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = "extension {0} is set to be installed".format(name)
        return ret

    vscode_install = __salt__["vscode.extension_install"](
        name, version=version, dir=dir, path=path
    )
    new_version = __salt__["vscode.extension_version"](name, dir=dir, path=path)

    if old_version != new_version:
        ret["comment"] = "extension {} has been changed from version {} to {}".format(
            name, old_version, new_version
        )
        ret["changes"] = {"old": old_version, "new": new_version}
        return ret

    if vscode_install["retcode"] != 0 or vscode_install["stderr"]:
        ret["result"] = False

    if vscode_install["stderr"]:
        ret["comment"] = vscode_install["stderr"]
    else:
        ret["comment"] = vscode_install["stdout"]

    return ret


def extension_latest(name, dir=None, path="code"):
    """
    Update a VSCode extension. Extension will be installed if not.

    Args:

        name (str):
            extension to update

        dir (str):
            specify the directory path where the extensions are installed

    CLI Example:

    .. code-block:: bash

        salt '*' vscode.extension_latest <extension name>
        salt '*' vscode.extension_latest <extension name> dir=<custom extension directory>
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}
    old_version = __salt__["vscode.extension_version"](name, dir=dir, path=path)

    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = "extension update will be performed".format(name)
        return ret

    vscode_install = __salt__["vscode.extension_latest"](name, dir=dir, path=path)
    new_version = __salt__["vscode.extension_version"](name, dir=dir, path=path)

    if __salt__["vscode.is_extension_installed"](name, dir=dir, path=path):
        if old_version == new_version:
            ret["comment"] = "extension {} is in the latest version {}".format(
                name, new_version
            )
            return ret
        else:
            ret[
                "comment"
            ] = "extension {} has been updated from version {} to {}".format(
                name, old_version, new_version
            )
            ret["changes"] = {"old": old_version, "new": new_version}
            return ret

    if vscode_install["retcode"] != 0 or vscode_install["stderr"]:
        ret["result"] = False

    if vscode_install["stderr"]:
        ret["comment"] = vscode_install["stderr"]
    else:
        ret["comment"] = vscode_install["stdout"]

    return ret


def extension_removed(name, dir=None, path="code"):
    """
    Uninstall a VSCode extension.

    Args:

        name (str):
            extension to uninstall

        dir (str):
            specify the directory path where the extensions are installed

    CLI Example:

    .. code-block:: bash

        salt '*' vscode.extension_removed <extension name>
        salt '*' vscode.extension_removed <extension name> dir=<custom extension directory>
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    if not __salt__["vscode.is_extension_installed"](name, dir=dir, path=path):
        ret["comment"] = "extension {} is not installed".format(name)
        return ret

    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = "extension {0} is set to be removed".format(name)
        return ret

    old_version = __salt__["vscode.extension_version"](name, dir=dir, path=path)
    vscode_uninstall = __salt__["vscode.extension_uninstall"](name, dir=dir, path=path)
    new_version = __salt__["vscode.extension_version"](name, dir=dir, path=path)

    if old_version != new_version:
        ret["comment"] = "extension {} has been removed".format(name)
        ret["changes"] = {"old": old_version, "new": new_version}
        return ret

    if vscode_uninstall["retcode"] != 0 or vscode_uninstall["stderr"]:
        ret["result"] = False

    if vscode_uninstall["stderr"]:
        ret["comment"] = vscode_uninstall["stderr"]
    else:
        ret["comment"] = vscode_uninstall["stdout"]

    return ret


def keybindings_updated(
    name, command, when=None, path=None, remove_comments=True, indent=4
):
    """
    Update a VSCode keybindings. If not found it will be added.

    Args:

        name (dict):
            content of the keybindings to set

            path (str):
                path of the file settings

            remove_comments (bool):
                json doesn't support comments. Remove all comments from file for avoid errors when parsing json

            indent:
                spaces indentation in VSCode settings

    CLI Example:

    .. code-block:: bash

        salt '*' vscode.keybindings_installed <keybindings dict>
        salt '*' vscode.keybindings_installed <keybindings dict> path=<keybindings path>
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}
    if __salt__["vscode.is_keybindings_set"](
        key=name, when=when, path=path, ignore_comments=remove_comments
    ):
        ret["comment"] = "keybindings is already set"
        return ret

    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = "New Keybindings will be set"
        ret["changes"] = {
            "old": None,
            "new": {"key": name, "command": command, "when": when},
        }
        return ret

    __salt__["vscode.keybindings_set"](
        key=name,
        command=command,
        when=when,
        path=path,
        ignore_comments=remove_comments,
        indent=indent,
    )

    if __salt__["vscode.is_keybindings_set"](
        key=name, when=when, path=path, ignore_comments=remove_comments
    ):
        ret["comment"] = "keybindings have been set"
        ret["changes"] = {
            "old": None,
            "new": {"key": name, "command": command, "when": when},
        }
    else:
        ret["result"] = False
        ret["comment"] = "keybindings have not been set"

    return ret


def keybindings_removed(
    name, command, when=None, path=None, remove_comments=True, indent=4
):
    """
    Remove a VSCode keybindings.

    Args:

        name (dict):
            content of the keybindings to remove

            path (str):
                path of the file settings

            remove_comments (bool):
                json doesn't support comments. Remove all comments from file for avoid errors when parsing json

            indent:
                spaces indentation in VSCode settings

    CLI Example:

    .. code-block:: bash

        salt '*' vscode.keybindings_installed <keybindings dict>
        salt '*' vscode.keybindings_installed <keybindings dict> path=<keybindings path>
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    if (
        __salt__["vscode.is_keybindings_set"](
            key=name, when=when, path=path, ignore_comments=remove_comments
        )
        is False
    ):
        ret["comment"] = "keybindings already removed"
        return ret

    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = "New Keybindings will be set"
        ret["changes"] = {
            "old": None,
            "new": {"key": name, "command": command, "when": when},
        }
        return ret

    __salt__["vscode.keybindings_remove"](
        key=name, when=when, path=path, ignore_comments=remove_comments, indent=indent
    )

    if __salt__["vscode.is_keybindings_set"](
        key=name, when=when, path=path, ignore_comments=remove_comments
    ):
        ret["comment"] = "keybindings have been set"
        ret["changes"] = {
            "old": None,
            "new": {"key": name, "command": command, "when": when},
        }
    else:
        ret["result"] = False
        ret["comment"] = "keybindings have not been set"

    return ret


def settings_updated(name, value, path=None, remove_comments=True, indent=4):
    """
    Update a VSCcode setting. If the setting does not exist, it will be created.

    Args:

        name (str):
            key of the setting to change

            value (str):
                value for the setting

            path (str):
                path of the settings file

            remove_comments (bool):
                json doesn't support comments. Remove all comments from file for avoid errors when parsing json

            indent:
                spaces indentation in VSCode settings

    CLI Example:

    .. code-block:: bash

        salt '*' vscode.settings_updated <settings name> val=<setting value>
        salt '*' vscode.settings_updated <settings name> val=<setting value> path=<setting path>
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    old_setting = __salt__["vscode.settings_get"](
        name, path=path, ignore_comments=remove_comments
    )

    if __opts__["test"]:
        vscode_setting = True
    else:
        vscode_setting = __salt__["vscode.settings_set"](
            name, value=value, path=path, remove_comments=remove_comments, indent=indent
        )

    new_setting = __salt__["vscode.settings_get"](
        name, path=path, ignore_comments=remove_comments
    )

    if vscode_setting is not True:
        ret["result"] = False
        ret["comment"] = "An error occurred: {}".format(vscode_setting)
        return ret

    if old_setting == new_setting == value:
        ret["comment"] = "setting {} is already configured".format(name)
        return ret
    else:
        if __opts__["test"]:
            ret["result"] = None
            ret["changes"] = {}
            ret["comment"] = "setting {} will be updated".format(name)
            return ret
        else:
            ret["comment"] = "setting {} has been updated".format(name)
            ret["changes"] = {"old": old_setting, "new": new_setting}
            return ret


def settings_removed(name, path=None, remove_comments=True, indent=4):
    """
    Remove a setting in VSCode.

    Args:

        name (str):
            key of the setting to change

            path (str):
                path of the settings file

            remove_comments (bool):
                json doesn't support comments. Remove all comments from file for avoid errors when parsing json

            indent:
                spaces indentation in VSCode settings

    CLI Example:

    .. code-block:: bash

        salt '*' vscode.settings_updated <settings name> val=<setting value>
        salt '*' vscode.settings_updated <settings name> val=<setting value> path=<setting path>
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    old_setting = __salt__["vscode.settings_get"](
        name, path=path, ignore_comments=remove_comments
    )

    if __opts__["test"]:
        vscode_setting = True
    else:
        vscode_setting = __salt__["vscode.settings_remove"](
            name, path=path, remove_comments=remove_comments, indent=indent
        )

    new_setting = __salt__["vscode.settings_get"](
        name, path=path, ignore_comments=remove_comments
    )

    if vscode_setting is not True:
        ret["comment"] = "An error occurred: {}".format(vscode_setting)
        ret["result"] = False
        return ret

    if old_setting is None:
        ret["comment"] = "setting {} is already removed".format(name)
        return ret
    elif __opts__["test"] and old_setting is not None:
        ret["comment"] = "setting {} will be removed".format(name)
        ret["result"] = None
        ret["changes"] = {}
        return ret
    else:
        ret["comment"] = "setting {} has been removed".format(name)
        ret["changes"] = {"old": old_setting, "new": new_setting}
        return ret
