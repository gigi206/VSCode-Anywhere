"""
Support for scoop (https://scoop.sh)
"""

import salt.utils.platform
import os
from glob import glob


def __virtual__():
    """
    Only works on Windows systems
    """
    if salt.utils.platform.is_windows():
        return True
    else:
        return (False, "Module scoop: module only works on Windows systems.")


def pkg_installed(
    name,
    version=None,
    globally=None,
    independent=None,
    nocache=None,
    skip=None,
    arch=None,
    path="scoop.cmd",
):
    """
    Install an application

    Args

        name (string):
            package to install

        version (string):
            specify a version to install instead of the last version (latest by default)

        globally (bool):
            install the app globally if True (default is None)

        independent (bool):
            don't install dependencies automatically (default is None)

        nocache (bool):
            don't use the download cache (default is None)

        skip (bool):
            skip hash validation => use with caution ! (default is None)

        arch (string):
            use the specified architecture, if the app supports it (default is None)
            Valid values are 32bit or 64bit
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    if __salt__["scoop.is_pkg_installed"](name) is True and (
        (
            version is not None
            and __salt__["scoop.pkg_current_version"](name) == str(version)
        )
        or version is None
    ):
        ret["comment"] = "{} is already installed".format(name)
    else:
        if __salt__["scoop.is_pkg_installed"](name) is True:
            previous_version = __salt__["scoop.pkg_current_version"](name)
        else:
            previous_version = None

        if __opts__["test"]:
            ret["result"] = None
            ret["comment"] = "{} will be installed".format(name)
            return ret
        else:
            cmd = __salt__["scoop.pkg_install"](
                name,
                version=version,
                globally=globally,
                independent=independent,
                nocache=nocache,
                skip=skip,
                arch=arch,
                path=path,
            )

        if __salt__["scoop.is_pkg_installed"](name) is True:
            current_version = __salt__["scoop.pkg_current_version"](name)
        else:
            current_version = None

        # if previous_version == current_version or cmd["retcode"] != 0 or cmd["stderr"]:
        if previous_version == current_version or cmd["retcode"] != 0:
            ret["result"] = False
            if cmd["stderr"]:
                ret["comment"] = "Failed to install {} => {}".format(
                    name, cmd["stderr"]
                )
            else:
                ret["comment"] = "Failed to install {}".format(name)
        else:
            if version is None:
                ret["comment"] = "{} has been installed".format(name)
                ret["changes"] = {"old": previous_version, "new": current_version}
            else:
                if __salt__["scoop.pkg_current_version"](name) == str(version):
                    ret["changes"] = {"old": previous_version, "new": current_version}
                    ret[
                        "comment"
                    ] = "{} has been installed with the specified version {}".format(
                        name, version
                    )
                else:
                    ret["comment"] = "Failed to install {} to the version {}".format(
                        name, version
                    )
                    ret["result"] = False
    return ret


def pkg_latest(
    name,
    force=None,
    globally=None,
    independent=None,
    nocache=None,
    skip=None,
    quiet=None,
    path="scoop.cmd",
):
    """
    Upgrade an application

    Args

        name (string):
            package to upgrade

        force (bool):
            force update even when there isn't a newer version (default is None)

        globally (bool):
            install the app globally if True (default is None)

        independent (bool):
            don't install dependencies automatically (default is None)

        nocache (bool):
            don't use the download cache (default is None)

        skip (bool):
            skip hash validation => use with caution ! (default is None)

        quiet (bool):
            Hide extraneous messages (default is None)
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    if __salt__["scoop.is_pkg_locked"](name) is True:
        ret["comment"] = "{} is freezed to version {}".format(
            name, __salt__["scoop.pkg_last_version"](name)
        )
    elif (
        __salt__["scoop.is_pkg_installed"](name) is True
        and __salt__["scoop.is_pkg_latest"](name) is True
    ):
        ret["comment"] = "{} is already up to date".format(name)
    else:
        if __salt__["scoop.is_pkg_installed"](name) is True:
            previous_version = __salt__["scoop.pkg_current_version"](name)
        else:
            previous_version = None

        if __opts__["test"]:
            ret["result"] = None
            ret["comment"] = "{} will be upgraded".format(name)
            return ret
        else:
            if previous_version is None:
                cmd = __salt__["scoop.pkg_install"](
                    name,
                    globally=globally,
                    independent=independent,
                    nocache=nocache,
                    skip=skip,
                    path=path,
                )
            else:
                cmd = __salt__["scoop.pkg_latest"](
                    name,
                    force=force,
                    globally=globally,
                    independent=independent,
                    nocache=nocache,
                    skip=skip,
                    quiet=quiet,
                    path=path,
                )

        if __salt__["scoop.is_pkg_installed"](name) is True:
            current_version = __salt__["scoop.pkg_current_version"](name)
        else:
            current_version = None

        # if previous_version == current_version or cmd["retcode"] != 0 or cmd["stderr"]:
        if previous_version == current_version or cmd["retcode"] != 0:
            ret["result"] = False
            if cmd["stderr"]:
                ret["comment"] = "Failed to upgrade {} to version {} => {}".format(
                    name, __salt__["scoop.pkg_last_version"](name), cmd["stderr"]
                )
            else:
                ret["comment"] = "Failed to upgrade {} to version {}".format(
                    name, __salt__["scoop.pkg_last_version"](name)
                )
        else:
            ret["changes"] = {"old": previous_version, "new": current_version}
            ret["comment"] = "{} has been upgraded".format(name)
    return ret


def buckets_uptodate(
    name,
    force=None,
    globally=None,
    independent=None,
    nocache=None,
    skip=None,
    quiet=None,
    path="scoop.cmd",
):
    """
    Upgrade all applications

    Args

        name (string):
            the name has no functional value and is only used as a tracking reference

        force (bool):
            force update even when there isn't a newer version (default is None)

        globally (bool):
            install the app globally if True (default is None)

        independent (bool):
            don't install dependencies automatically (default is None)

        nocache (bool):
            don't use the download cache (default is None)

        skip (bool):
            skip hash validation => use with caution ! (default is None)

        quiet (bool):
            Hide extraneous messages (default is None)
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}
    # is_uptodate = True
    buckets = []
    for bucket in __salt__["scoop.bucket_list"](path=path):
        try:
            if __salt__["git.fetch"](
                os.path.join(
                    __salt__["grains.get"]("vscode-anywhere:apps:path"),
                    "scoop",
                    "buckets",
                    bucket,
                )
            ):
                buckets.append(bucket)
        except Exception:
            pass
    if buckets:
        if __opts__["test"]:
            ret["comment"] = "All buckets will be updated"
            ret["changes"] = {"pkgs": buckets}
            ret["result"] = None
        else:
            cmd = __salt__["scoop.bucket_latest"](
                name,
                force=force,
                globally=globally,
                independent=independent,
                nocache=nocache,
                skip=skip,
                quiet=quiet,
                path=path,
            )
            # if cmd["retcode"] != 0 or cmd["stderr"]:
            if cmd["retcode"] != 0:
                ret["result"] = False
                if cmd["stderr"]:
                    ret["comment"] = "Failed to update all buckets:\n{}".format(
                        cmd["stderr"]
                    )
                else:
                    ret["comment"] = "Failed to update all buckets"
            else:
                ret["comment"] = "Buckets {} have been updated".format(
                    ", ".join(buckets)
                )
                ret["changes"] = {"pkgs": buckets}
    else:
        ret["comment"] = "All buckets are up to date"
    return ret


def pkg_uptodate(
    name,
    force=None,
    globally=None,
    independent=None,
    nocache=None,
    skip=None,
    quiet=None,
    path="scoop.cmd",
):
    """
    Upgrade all applications

    Args

        name (string):
            the name has no functional value and is only used as a tracking reference

        force (bool):
            force update even when there isn't a newer version (default is None)

        globally (bool):
            install the app globally if True (default is None)

        independent (bool):
            don't install dependencies automatically (default is None)

        nocache (bool):
            don't use the download cache (default is None)

        skip (bool):
            skip hash validation => use with caution ! (default is None)

        quiet (bool):
            Hide extraneous messages (default is None)
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}
    is_uptodate = True
    pkgs = []
    for pkg in __salt__["scoop.pkg_get_installed"]():
        if pkg == "scoop":
            continue
        if not (
            __salt__["scoop.pkg_last_version"](pkg)
            in __salt__["scoop.pkg_installed_versions"](pkg)
            or __salt__["scoop.is_pkg_locked"](pkg)
        ):
            is_uptodate = False
            pkgs.append(pkg)

    if is_uptodate:
        ret["comment"] = "All applications are up to date"
    else:
        if __opts__["test"]:
            ret["comment"] = "All applications will be upgraded"
            ret["result"] = None
        else:
            cmd = __salt__["scoop.pkg_latest"](
                "*",
                force=force,
                globally=globally,
                independent=independent,
                nocache=nocache,
                skip=skip,
                quiet=quiet,
                path=path,
            )

            # if cmd["retcode"] != 0 or cmd["stderr"]:
            if cmd["retcode"] != 0:
                ret["result"] = False
                if cmd["stderr"]:
                    ret["comment"] = "Failed to upgrade all applications:\n{}".format(
                        cmd["stderr"]
                    )
                else:
                    ret["comment"] = "Failed to upgrade all applications"
            else:
                ret["comment"] = "Applications {} have been upgraded".format(
                    ", ".join(pkgs)
                )
                ret["changes"] = {"pkgs": pkgs}
    return ret


def pkg_removed(name, version=None, globally=None, purge=None, path="scoop.cmd"):
    """
    Remove an application

    Args

        name (string):
            application to remove

        version (string):
            specific version to uninstall (if multiple versions)

        globally (bool):
            uninstall globally an application (default is None)

        purge (bool):
            remove all persistent data (default is None)
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    if (
        version is not None
        and __salt__["scoop.is_pkg_installed"](name) is True
        and str(version) not in __salt__["scoop.pkg_installed_versions"](name)
    ) or __salt__["scoop.is_pkg_installed"](name) is False:
        ret["comment"] = "{} is already removed".format(name)
    else:
        previous_version = __salt__["scoop.pkg_current_version"](name)

        if __opts__["test"]:
            ret["result"] = None
            if version:
                ret["comment"] = "{} version {} will be removed".format(name, version)
            else:
                ret["comment"] = "{} will be removed".format(name)
            return ret
        else:
            cmd = __salt__["scoop.pkg_remove"](
                name, version=version, globally=globally, purge=purge, path=path
            )

        if version is None:
            if (
                __salt__["scoop.is_pkg_installed"](name) is True
                or cmd["retcode"] != 0
                or cmd["stderr"]
            ):
                ret["result"] = False
                if cmd["stderr"]:
                    ret["comment"] = "Failed to remove {} => {}".format(
                        name, cmd["stderr"]
                    )
                else:
                    ret["comment"] = "Failed to remove {}".format(name)
            else:
                ret["comment"] = "{} has been removed".format(name)
                ret["changes"] = {"old": previous_version, "new": None}
        else:
            if (
                (
                    __salt__["scoop.is_pkg_installed"](name) is True
                    and str(version) in __salt__["scoop.pkg_installed_versions"](name)
                )
                or cmd["retcode"] != 0
                or cmd["stderr"]
            ):
                ret["result"] = False
                if cmd["stderr"]:
                    ret["comment"] = "Failed to remove {} => {}".format(
                        name, cmd["stderr"]
                    )
                else:
                    ret["comment"] = "Failed to remove {} version {}".format(
                        name, version
                    )
            else:
                ret["comment"] = "{} version {} has been removed".format(name, version)
                ret["changes"] = {"old": version, "new": None}
    return ret


def pkg_cleanup(name, globally=None, cache=None, path="scoop.cmd"):
    """
    Cleanup an application by removing old versions

    Args

        name (string):
            application to cleanup

        globally (bool):
            cleanup globally an application (default is None)

        cache (bool):
            remove outdated download cache
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}
    cache_dir = os.path.join(
        __salt__["grains.get"]("vscode-anywhere:apps:path"), "scoop", "cache"
    )
    has_cache = (
        len(
            [
                pkg
                for pkg in glob(os.path.join(cache_dir, "{}#*".format(name)))
                if not os.path.basename(pkg).startswith(
                    "{}#{}#".format(name, __salt__["scoop.pkg_current_version"](name))
                )
            ]
        )
        > 0
    )

    if (
        __salt__["scoop.is_pkg_installed"](name) is True
        and len(__salt__["scoop.pkg_installed_versions"](name)) > 1
    ) or (bool(cache) is True and has_cache):
        if __opts__["test"]:
            ret["comment"] = "{} will be cleanup".format(name)
            ret["result"] = None
        else:
            cmd = __salt__["scoop.pkg_cleanup"](
                name, globally=globally, cache=cache, path=path
            )
            if cmd["retcode"] != 0 or cmd["stderr"]:
                ret["result"] = False
                if cmd["stderr"]:
                    ret["comment"] = "Failed to cleanup {} => {}".format(
                        name, cmd["stderr"]
                    )
                else:
                    ret["comment"] = "Failed to cleanup {}".format(name)
            else:
                ret["comment"] = "{} has been cleaned up".format(name)
                ret["changes"] = {"cleanup": True}
    else:
        ret["comment"] = "{} is already cleanup".format(name)
    return ret


def bucket_added(name, path="scoop.cmd"):
    """
    Add a bucket

    Args

        name (string):
            Name of the bucket to add
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}
    if name in __salt__["scoop.bucket_list"](path=path):
        ret["comment"] = "Bucket {} is present".format(name)
    elif name not in __salt__["scoop.bucket_known"](path=path):
        ret["result"] = False
        ret["comment"] = "Bucket {} is unknown".format(name)
    else:
        if __opts__["test"]:
            ret["comment"] = "Bucket {} will be added".format(name)
        else:
            cmd = __salt__["scoop.bucket_add"](name, path=path)
            if (
                name not in __salt__["scoop.bucket_list"](path=path)
                or cmd["retcode"] != 0
                or cmd["stderr"]
            ):
                ret["result"] = False
                if cmd["stderr"]:
                    ret["comment"] = "Failed to add bucket {} => {}".format(
                        name, cmd["stderr"]
                    )
                else:
                    ret["comment"] = "Failed to add bucket {}".format(name)
            else:
                ret["comment"] = "Bucket {} has been added".format(name)
                ret["changes"] = {"added": name}
    return ret


def bucket_removed(name, path="scoop.cmd"):
    """
    Remove a bucket

    Args

        name (string):
            Name of the bucket to remove
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}
    if name in __salt__["scoop.bucket_list"](path=path):
        if __opts__["test"]:
            ret["comment"] = "Bucket {} will be removed".format(name)
        else:
            cmd = __salt__["scoop.bucket_rm"](name, path=path)
            if (
                name in __salt__["scoop.bucket_list"](path=path)
                or cmd["retcode"] != 0
                or cmd["stderr"]
            ):
                ret["result"] = False
                if cmd["stderr"]:
                    ret["comment"] = "Failed to remove bucket {} => {}".format(
                        name, cmd["stderr"]
                    )
                else:
                    ret["comment"] = "Failed to remove bucket {}".format(name)
            else:
                ret["comment"] = "Bucket {} has been removed".format(name)
                ret["changes"] = {"removed": name}
    else:
        ret["comment"] = "Bucket {} is absent".format(name)
    return ret


def cache_clean(name, path="scoop.cmd"):
    """
    Show or clear the download cache

    Args

        name (string):
            Name of the application cache to remove (use '*' for remove all cache)
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}
    cache_dir = os.path.join(
        __salt__["grains.get"]("vscode-anywhere:apps:path"), "scoop", "cache"
    )

    if name == "*":
        has_cache = len(os.listdir(cache_dir)) > 0
    else:
        has_cache = (
            len([pkg for pkg in glob(os.path.join(cache_dir, "{}#*".format(name)))]) > 0
        )
    if has_cache:
        if __opts__["test"]:
            ret["comment"] = "Cache will be cleaned"
            ret["result"] = None
        else:
            cmd = __salt__["scoop.cache_clean"](name, path=path)
            if cmd["retcode"] != 0 or cmd["stderr"]:
                ret["comment"] = "Failed to clean cache"
                ret["result"] = False
            else:
                ret["comment"] = "Cache has been cleaned"
                ret["changes"] = {"cleaned": True}
    else:
        ret["comment"] = "Cache is already cleaned"
    return ret


def pkg_holded(name, path="scoop.cmd"):
    """
    Hold an app to disable updates

    Args

        name (string):
            Name of the application to hold
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    if __salt__["scoop.is_pkg_holded"](name):
        ret["comment"] = "Application {} is already holded".format(name)
    else:
        if __opts__["test"]:
            ret["comment"] = "Application {} will be holded".format(name)
            ret["result"] = None
        else:
            cmd = __salt__["scoop.pkg_hold"](name, path=path)
            if (
                not __salt__["scoop.is_pkg_holded"](name)
                or cmd["retcode"] != 0
                or cmd["stderr"]
            ):
                if cmd["stderr"]:
                    ret["comment"] = "Failed to hold application {}:\n{}".format(
                        name, cmd["stderr"]
                    )
                else:
                    ret["comment"] = "Failed to hold application {}".format(name)
                ret["result"] = False
            else:
                ret["comment"] = "Application {} has been holded".format(name)
                ret["changes"] = {"hold": True}
    return ret


def pkg_unholded(name, path="scoop.cmd"):
    """
    Unhold an app to enable updates

    Args

        name (string):
            Name of the application to unhold
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    if __salt__["scoop.is_pkg_holded"](name):
        if __opts__["test"]:
            ret["comment"] = "Application {} will be unholded".format(name)
            ret["result"] = None
        else:
            cmd = __salt__["scoop.pkg_unhold"](name, path=path)
            if (
                __salt__["scoop.is_pkg_holded"](name)
                or cmd["retcode"] != 0
                or cmd["stderr"]
            ):
                if cmd["stderr"]:
                    ret["comment"] = "Failed to unhold application {}:\n{}".format(
                        name, cmd["stderr"]
                    )
                else:
                    ret["comment"] = "Failed to unhold application {}".format(name)
                ret["result"] = False
            else:
                ret["comment"] = "Application {} has been unholded".format(name)
                ret["changes"] = {"unhold": True}
    else:
        ret["comment"] = "Application {} is already unholded".format(name)

    return ret
