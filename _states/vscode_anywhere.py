"""
Support VSCode-Anywhere
"""

import salt.utils.platform


def __virtual__():
    """
    Load vscode-anywhere
    """
    return True


def append_path_env(name):
    """
    Append a path to the env file

    Args:
        name (str):
            path to add separated by ":" for Linux or ";" for Windows

    CLI Example:

    .. code-block:: bash

        salt '*' vscode_anywhere.append_path_env <path>
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    if salt.utils.platform.is_windows():
        sep = ";"
    else:
        sep = ":"

    find = True

    for path in name.split(sep):
        if not __salt__["vscode_anywhere.is_path_env"](path):
            find = False

    if find:
        ret["comment"] = "path {} is already present".format(name)
    else:
        if __opts__["test"]:
            ret["result"] = None
            ret["comment"] = "path {} is set to be added".format(name)
        else:
            ret["comment"] = "path {} has been added".format(name)
            ret["changes"] = {"diff": __salt__["vscode_anywhere.append_path_env"](name)}
    return ret


def remove_path_env(name):
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    if __salt__["vscode_anywhere.is_path_env"](name):
        if __opts__["test"]:
            ret["result"] = None
            ret["comment"] = "path {} is set to be removed".format(name)
        else:
            ret["comment"] = "path {} has been removed".format(name)
            ret["changes"] = {"diff": __salt__["vscode_anywhere.remove_path_env"](name)}
    else:
        ret["comment"] = "path {} is already removed".format(name)
    return ret
