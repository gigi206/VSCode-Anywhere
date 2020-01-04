"""
Support for Zeal (https://zealdocs.org)
"""

import salt.exceptions


def __virtual__():
    """
    Only load if Zeal is installed on the system
    """
    return True


def docset_installed(name):
    """
    Install the specified docset

    Args:
        name (str):
            name of the docset to install

    CLI Example:

    .. code-block:: bash

        salt '*' zeal.docset_installed <docset name>
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}
    if __salt__["zeal.is_docset_installed"](name):
        ret["comment"] = "docset {} is already installed".format(name)
        return ret
    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = "docset {} is set to be installed".format(name)
        return ret
    old_version = __salt__["zeal.docset_current_version"](name)
    try:
        __salt__["zeal.docset_install"](name)
    except salt.exceptions.CommandExecutionError as e:
        ret["comment"] = "{}".format(e)
        ret["result"] = False
        return ret
    except Exception:
        pass
    new_version = __salt__["zeal.docset_current_version"](name)
    if old_version == new_version:
        ret["comment"] = "docset {} has not been installed".format(name)
        ret["result"] = False
    else:
        ret["comment"] = "docset {} has been installed".format(name)
        ret["changes"] = {
            "old": {"version": old_version[0], "revision": old_version[1]},
            "new": {"version": new_version[0], "revision": new_version[1]},
        }
    return ret


def docset_latest(name):
    """
    Update the specified docset. If docset does not exist it will be installed

    Args:
        name (str):
            name of the docset to update

    CLI Example:

    .. code-block:: bash

        salt '*' zeal.docset_updated <docset name>
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}
    old_version = __salt__["zeal.docset_current_version"](name)
    target_version = __salt__["zeal.docset_last_version"](name)
    if __salt__["zeal.is_docset_installed"](name) and old_version == target_version:
        ret["comment"] = "docset {} is already up to date".format(name)
        return ret
    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = "docset {} is set to be updated".format(name)
        return ret
    __salt__["zeal.docset_install"](name)
    new_version = __salt__["zeal.docset_current_version"](name)
    if old_version == new_version:
        ret["comment"] = "docset {} has not been updated".format(name)
        ret["result"] = False
    else:
        ret["comment"] = "docset {} has been updated".format(name)
        ret["changes"] = {
            "old": {"version": old_version[0], "revision": old_version[1]},
            "new": {"version": new_version[0], "revision": new_version[1]},
        }
    return ret


def docset_removed(name):
    """
    Remove the specified docset

    Args:
        name (str):
            name of the docset to remove

    CLI Example:

    .. code-block:: bash

        salt '*' zeal.docset_removed <docset name>
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    if not __salt__["zeal.is_docset_installed"](name):
        ret["comment"] = "docset {} is not installed".format(name)
        return ret
    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = "docset {} is set to be removed".format(name)
        return ret
    old_version = __salt__["zeal.docset_current_version"](name)
    __salt__["zeal.docset_delete"](name)
    new_version = __salt__["zeal.docset_current_version"](name)
    if old_version == new_version and old_version != (None, None):
        ret["comment"] = "docset {} has not been removed".format(name)
        ret["result"] = False
    else:
        ret["comment"] = "docset {} has been removed".format(name)
        ret["changes"] = {
            "old": {"version": old_version[0], "revision": old_version[1]},
            "new": {"version": new_version[0], "revision": new_version[1]},
        }
    return ret
