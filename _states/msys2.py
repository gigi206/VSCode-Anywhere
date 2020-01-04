"""
Support for msys2 (https://www.msys2.org)
Inspired by the source code from https://github.com/peakwinter/python-pacman
"""

import salt.utils.platform
import salt.exceptions


def __virtual__():
    """
    Only works on Windows systems
    """
    if salt.utils.platform.is_windows():
        return True
    else:
        return (False, "Module msys2: module only works on Windows systems.")


def pkg_installed(
    name,
    version=None,
    needed=True,
    refresh=False,
    shell_path=None,
    shell_args="-lc",
    **kwargs
):
    """
    Install a package

    Args

        name (list or string):
            list of packages to install
            can be a list or a string separated by a comma between package names

        version (string):
            specify a version to install instead of the last version
            Note when you specify a version you can install only one package

        needed (bool):
            pass the needed option to pacman (True by default)

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}
    if isinstance(name, list):
        if version:
            raise salt.exceptions.CommandExecutionError(
                "version argument can't be used with multiple packages"
            )
        packages = __salt__["msys2.pkg_needs_for"](
            name, shell_path=shell_path, shell_args=shell_args, **kwargs
        )
    else:
        packages = __salt__["msys2.pkg_needs_for"](
            name.split(","), shell_path=shell_path, shell_args=shell_args, **kwargs
        )
    pkgs = []
    pkg_version = None
    if refresh and not __opts__["test"]:
        __salt__["msys2.pkg_refresh"](
            shell_path=shell_path, shell_args=shell_args, **kwargs
        )
    for pkg in packages:
        if not __salt__["msys2.is_pkg_installed"](
            pkg, shell_path=shell_path, shell_args=shell_args, **kwargs
        ):
            pkgs.append(pkg)
        else:
            if version:
                pkg_version = __salt__["msys2.pkg_get_info"](
                    pkg, shell_path=shell_path, shell_args=shell_args, **kwargs
                )["Version"]
    if (len(pkgs) == 0 and version is None) or (
        len(pkgs) == 0 and version == pkg_version
    ):
        ret["comment"] = "All packages ({}) is already installed".format(
            ", ".join(packages)
        )
    else:
        if version != pkg_version:
            pkgs = packages
        if __opts__["test"]:
            ret["result"] = None
            ret["comment"] = "Following packages will be installed : {}".format(
                ", ".join(pkgs)
            )
            return ret

        __salt__["msys2.pkg_install"](
            pkgs,
            version=version,
            needed=needed,
            shell_path=shell_path,
            shell_args=shell_args,
            **kwargs
        )
        ret["changes"] = {"old": {}, "new": {}}

        for pkg in pkgs:
            ret["changes"]["old"][pkg] = pkg_version
            if __salt__["msys2.is_pkg_installed"](
                pkg, shell_path=shell_path, shell_args=shell_args, **kwargs
            ):
                ret["changes"]["new"][pkg] = __salt__["msys2.pkg_get_info"](
                    pkg, shell_path=shell_path, shell_args=shell_args, **kwargs
                )["Version"]
            else:
                ret["result"] = False
                if not isinstance(ret["changes"].get("failed"), list):
                    ret["changes"]["failed"] = []
                ret["changes"]["failed"].append(pkg)
        if ret["changes"].get("failed"):
            ret["comment"] = "Following packages {} failed to install".format(
                ", ".join(ret["changes"]["failed"])
            )
        else:
            ret["comment"] = "Packages {} have been installed".format(", ".join(pkgs))
    return ret


def pkg_latest(
    name,
    version=None,
    needed=True,
    refresh=False,
    shell_path=None,
    shell_args="-lc",
    **kwargs
):
    """
    Upgrade a package

    Args

        name (list or string):
            list of packages to install
            can be a list or a string separated by a comma between package names

        version (string):
            specify a version to install instead of the last version
            Note when you specify a version you can install only one package

        needed (bool):
            pass the needed option to pacman (True by default)

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}
    if isinstance(name, list):
        if version:
            raise salt.exceptions.CommandExecutionError(
                "version argument can't be used with multiple packages"
            )
        packages = __salt__["msys2.pkg_needs_for"](
            name, shell_path=shell_path, shell_args=shell_args, **kwargs
        )
    else:
        packages = __salt__["msys2.pkg_needs_for"](
            name.split(","), shell_path=shell_path, shell_args=shell_args, **kwargs
        )
    pkgs = []
    pkg_version = None
    if refresh and not __opts__["test"]:
        __salt__["msys2.pkg_refresh"](
            shell_path=shell_path, shell_args=shell_args, **kwargs
        )
    for pkg in packages:
        if version is None and (
            __salt__["msys2.is_pkg_upgradable"](
                pkg, shell_path=shell_path, shell_args=shell_args, **kwargs
            )
            or not __salt__["msys2.is_pkg_installed"](
                pkg, shell_path=shell_path, shell_args=shell_args, **kwargs
            )
        ):
            pkgs.append(pkg)
        else:
            if version:
                pkg_version = __salt__["msys2.pkg_get_info"](
                    pkg, shell_path=shell_path, shell_args=shell_args, **kwargs
                )["Version"]
    if (len(pkgs) == 0 and version is None) or (
        len(pkgs) == 0 and version == pkg_version
    ):
        ret["comment"] = "All packages ({}) is already up to date".format(
            ", ".join(packages)
        )
    else:
        if version != pkg_version:
            pkgs = packages
        if __opts__["test"]:
            ret["result"] = None
            ret["comment"] = "Following packages will be upgraded : {}".format(
                ", ".join(pkgs)
            )
            return ret
        ret["changes"] = {"old": {}, "new": {}}
        for pkg in pkgs:
            if __salt__["msys2.is_pkg_installed"](
                pkg, shell_path=shell_path, shell_args=shell_args, **kwargs
            ):
                ret["changes"]["old"][pkg] = __salt__["msys2.pkg_get_info"](
                    pkg, shell_path=shell_path, shell_args=shell_args, **kwargs
                )["Version"]
            else:
                ret["changes"]["old"][pkg] = None

        __salt__["msys2.pkg_install"](
            pkgs,
            version=version,
            needed=needed,
            shell_path=shell_path,
            shell_args=shell_args,
            **kwargs
        )
        for pkg in pkgs:
            if version is None and (
                __salt__["msys2.is_pkg_installed"](
                    pkg, shell_path=shell_path, shell_args=shell_args, **kwargs
                )
                is False
                or __salt__["msys2.is_pkg_upgradable"](
                    pkg, shell_path=shell_path, shell_args=shell_args, **kwargs
                )
            ):
                ret["result"] = False
                if not isinstance(ret["changes"].get("failed"), list):
                    ret["changes"]["failed"] = []
                ret["changes"]["failed"].append(pkg)
            else:
                ret["changes"]["new"][pkg] = __salt__["msys2.pkg_get_info"](
                    pkg, shell_path=shell_path, shell_args=shell_args, **kwargs
                )["Version"]
        if ret["changes"].get("failed"):
            ret["comment"] = "Following packages {} failed to upgrade".format(
                ", ".join(ret["changes"]["failed"])
            )
        else:
            ret["comment"] = "Packages {} have been installed".format(", ".join(pkgs))
    return ret


def pkg_removed(name, purge=False, shell_path=None, shell_args="-lc", **kwargs):
    """
    Remove a package

    Args

        name (list or string):
            list of packages to remove
            can be a list or a string separated by a comma between package names

        purge (bool):
            if True (default) then remove also configuration files

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}
    if isinstance(name, list):
        packages = __salt__["msys2.pkg_needs_for"](
            name, shell_path=shell_path, shell_args=shell_args, **kwargs
        )
    else:
        packages = __salt__["msys2.pkg_needs_for"](
            name.split(","), shell_path=shell_path, shell_args=shell_args, **kwargs
        )
    pkgs = []
    for pkg in packages:
        if __salt__["msys2.is_pkg_installed"](
            pkg, shell_path=shell_path, shell_args=shell_args, **kwargs
        ):
            pkgs.append(pkg)
    if len(pkgs) == 0:
        ret["comment"] = "All packages ({}) is already removed".format(
            ", ".join(packages)
        )
    else:
        if __opts__["test"]:
            ret["result"] = None
            ret["comment"] = "Following packages will be removed : {}".format(
                ", ".join(pkgs)
            )
            return ret
        ret["changes"] = {"old": {}, "new": {}}
        for pkg in pkgs:
            ret["changes"]["old"][pkg] = __salt__["msys2.pkg_get_info"](
                pkg, shell_path=shell_path, shell_args=shell_args, **kwargs
            )["Version"]
        __salt__["msys2.pkg_remove"](
            pkgs, purge=purge, shell_path=shell_path, shell_args=shell_args, **kwargs
        )
        for pkg in pkgs:
            if __salt__["msys2.is_pkg_installed"](
                pkg, shell_path=shell_path, shell_args=shell_args, **kwargs
            ):
                ret["result"] = False
                if not isinstance(ret["changes"].get("failed"), list):
                    ret["changes"]["failed"] = []
                ret["changes"]["failed"].append(pkg)
            else:
                ret["changes"]["new"][pkg] = None
        if ret["changes"].get("failed"):
            ret["comment"] = "Following packages {} failed to uninstall".format(
                ", ".join(ret["changes"]["failed"])
            )
        else:
            ret["comment"] = "Packages {} have been removed".format(", ".join(pkgs))
    return ret


def pkg_refresh(name, shell_path=None, shell_args="-lc", **kwargs):
    """
    Download fresh package databases from the server

    Args

        name (string):
            the name has no functional value and is only used as a tracking reference

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}
    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = "Packages database will be refresh"
    else:
        __salt__["msys2.pkg_refresh"](
            shell_path=shell_path, shell_args=shell_args, **kwargs
        )
        ret["comment"] = "Packages database have been refreshed"
        ret["changes"] = {"refresh": True}
    return ret


def pkg_uptodate(name, refresh=False, shell_path=None, shell_args="-lc", **kwargs):
    """
    Upgrade all packages

    Args

        name (string):
            the name has no functional value and is only used as a tracking reference

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}
    if refresh and not __opts__["test"]:
        __salt__["msys2.pkg_refresh"](
            shell_path=shell_path, shell_args=shell_args, **kwargs
        )
    pkgs = [
        pkg["id"]
        for pkg in __salt__["msys2.pkg_get_installed"](
            shell_path=shell_path, shell_args=shell_args, **kwargs
        )
        if pkg["upgradable"] is not False
    ]
    if len(pkgs) == 0:
        ret["comment"] = "All packages are up to date"
    else:
        if __opts__["test"]:
            ret["result"] = None
            ret["comment"] = "Following packages will be updated : {}".format(
                ", ".join(pkgs)
            )
            return ret
        ret["changes"] = {"old": {}, "new": {}}
        for pkg in pkgs:
            ret["changes"]["old"][pkg] = __salt__["msys2.pkg_get_info"](
                pkg, shell_path=shell_path, shell_args=shell_args, **kwargs
            )["Version"]
        # Run upgrade 2 times if pacman has an update
        if "pacman" in __salt__["msys2.pkgs_get_upgradable"](
            shell_path=shell_path, shell_args=shell_args, **kwargs
        ):
            __salt__["msys2.pkg_upgrade"](
                shell_path=shell_path, shell_args=shell_args, **kwargs
            )

        __salt__["msys2.pkg_upgrade"](
            shell_path=shell_path, shell_args=shell_args, **kwargs
        )
        for pkg in pkgs:
            version = __salt__["msys2.pkg_get_info"](
                pkg, shell_path=shell_path, shell_args=shell_args, **kwargs
            )["Version"]
            if version == ret["changes"]["old"][pkg]:
                if not isinstance(ret["changes"].get("failed"), list):
                    ret["changes"]["failed"] = []
                ret["changes"]["failed"].append(pkg)
            else:
                ret["changes"]["new"][pkg] = version
        if ret["changes"].get("failed"):
            ret["result"] = False
            ret["comment"] = "Some packages failed to update"
        else:
            ret["comment"] = "Packages have been updated"
    return ret
