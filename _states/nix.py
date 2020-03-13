"""
Support for nix (https://nixos.org)
"""

import salt.utils.platform

# import salt.exceptions


def __virtual__():
    """
    Only works on Windows systems
    """
    if salt.utils.platform.is_linux():
        return True
    else:
        return (False, "Module nix: module only works on Linux systems.")


def pkg_installed(name, attributes=False, channel=None):
    """
    Install a package

    Args

        name (string):
            list of the package to install

        attributes (bool):
            the Nix package attribute, not the package name. default: False
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    if attributes:
        if len(name.split(".")) >= 2:
            chan = name.split(".")[0]
            pkg = ".".join(name.split(".")[1:])
        else:
            ret["result"] = False
            ret[
                "comment"
            ] = "Package name must respect this form: <channel>.<pkg> (example: nixpkgs.vscode)"
            return ret

        cmd_pkg_name = __salt__["cmd.run_all"](
            "nix-instantiate --eval -E '(import <{}> {{}}).{}.name'".format(chan, pkg),
            python_shell=True,
        )

        cmd_pkg_version = __salt__["cmd.run_all"](
            "nix-instantiate --eval -E '(import <{}> {{}}).{}.version'".format(
                chan, pkg
            ),
            python_shell=True,
        )

        if cmd_pkg_name["retcode"] == 0 and cmd_pkg_version["retcode"] == 0:
            pkg_name = (
                cmd_pkg_name["stdout"]
                .strip('"')
                .replace("-{}".format(cmd_pkg_version["stdout"].strip('"')), "")
            )
        else:
            ret["result"] = False
            ret["comment"] = "Package {} not found".format(name)
            return ret
    else:
        pkg_name = name

    if pkg_name in [pkg["name"] for pkg in __salt__["nix.list_pkgs"]()]:
        ret["comment"] = "Package {} is already installed".format(pkg_name)
    else:
        if __opts__["test"]:
            ret["result"] = None
            ret["comment"] = "Package {} ({}) will be installed".format(name, pkg_name)
        else:
            __salt__["nix.install"](name, attributes=attributes, channel=channel)

            if pkg_name in [pkg["name"] for pkg in __salt__["nix.list_pkgs"]()]:
                ret["comment"] = "Package {} has been installed".format(name)
                ret["changes"] = {"new": pkg_name}
            else:
                ret["result"] = False
                ret["comment"] = "The package {} could not be installed".format(name)

    return ret


def pkg_latest(name="*", channel=None):
    """
    Upgrade packages

    Args

        name (list or string):
            list of packages to upgrade
            can be a list or a string separated by a comma between package names
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    # nix = ["nix-channel", "--update"]
    # cmd = __salt__["cmd.run_all"](nix, python_shell=True)

    if isinstance(name, list):
        pkgs = name
    else:
        pkgs = [pkg for pkg in name.split(",")]

    if name == '*':
        pkgs_update = True
    else:
        pkgs_update = [
            pkg["name"] for pkg in __salt__["nix.list_pkgs"]() if pkg["name"] in pkgs
        ]

    if pkgs_update:
        if __opts__["test"]:
            nix = "nix-env --query --compare-versions {}".format(" ".join(pkgs))
            cmd = __salt__["cmd.run"](nix, python_shell=True)
            update = {
                line.split()[0]: line.split()[-1]
                for line in cmd.splitlines()
                if line.split()[1] == "<"
            }
            ret["result"] = None
            if len(update) > 0:
                ret["comment"] = "Following package(s) will be updated: {}".format(
                    ",".join(update)
                )
            else:
                ret["comment"] = "Package(s) are up to date"
        else:
            update = __salt__["nix.upgrade"](*pkgs, channel=channel)

            old_pkgs = [pkg[0] for pkg in update]
            new_pkgs = [pkg[1] for pkg in update]

            if len(old_pkgs) == 1:
                old_pkgs = [pkg[0] for pkg in update][0]
                new_pkgs = [pkg[1] for pkg in update][0]

            if len(update) > 0:
                ret["changes"] = {
                    "old": old_pkgs,
                    "new": new_pkgs
                }
                ret["comment"] = "Packages have been updated"
            else:
                ret["comment"] = "Packages are already up to date"
    else:
        ret["comment"] = "No package to update"

    return ret


def pkg_removed(name):
    """
    Remove a package

    Args

        name (list or string):
            list of packages to remove
            can be a list or a string separated by a comma between package names
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    local_pkgs = [pkg["name"] for pkg in __salt__["nix.list_pkgs"]()]
    remove_pkgs = []
    success_pkgs = []
    failed_pkgs = []

    if isinstance(name, list):
        for pkg in name:
            if pkg in local_pkgs:
                remove_pkgs.append(name)
    else:
        for pkg in name.split(","):
            if pkg in local_pkgs:
                remove_pkgs.append(name)

    if remove_pkgs:
        if __opts__["test"]:
            ret["result"] = None
            if len(remove_pkgs) > 0:
                ret[
                    "comment"
                ] = "The following packages will be uninstalled: {}".format(
                    ",".join(remove_pkgs)
                )
            else:
                ret["comment"] = "All packages are already removed"
        else:
            for pkg in remove_pkgs:
                try:
                    __salt__["nix.uninstall"](pkg)
                except Exception:
                    pass

            for pkg in remove_pkgs:
                if pkg in [pkg["name"] for pkg in __salt__["nix.list_pkgs"]()]:
                    failed_pkgs.append(pkg)
                else:
                    success_pkgs.append(pkg)

            if failed_pkgs:
                ret["result"] = False
                ret["comment"] = "Package(s) {} could not be uninstalled".format(
                    ", ".join(failed_pkgs)
                )
            else:
                ret["comment"] = "Packages {} have been uninstalled".format(
                    ", ".join(remove_pkgs)
                )
            ret["changes"]["removed"] = success_pkgs
            if failed_pkgs:
                ret["changes"]["failed"] = failed_pkgs
    else:
        ret["comment"] = "All packages are already removed"

    return ret


def channel_updated(name="nixpkgs"):
    """
    Upgrade packages

    Args

        name (string):
            the name of the channel to update
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    if name not in [channel["name"] for channel in __salt__["nix.channel_list"]()]:
        ret["comment"] = "Channel {} doesn't exist".format(name)
        ret["result"] = False
    else:
        nix_version = "nix-instantiate --eval -E '(import <{}> {{}}).lib.version'".format(
            name
        )
        cmd_before_version = __salt__["cmd.run"](nix_version, python_shell=True)

        if __opts__["test"]:
            ret["result"] = None
            ret["comment"] = "Channel {} will be upgraded".format(name)
        else:
            nix_update_channel = "nix-channel --update {}".format(name)
            __salt__["cmd.run"](nix_update_channel, python_shell=True)

            cmd_after_version = __salt__["cmd.run"](nix_version, python_shell=True)

            if cmd_before_version == cmd_after_version:
                ret["comment"] = "Channel {} is already up to date".format(name)
            else:
                ret["comment"] = "Channel {} has been updated".format(name)
                ret["changes"] = {"old": cmd_before_version, "new": cmd_after_version}

    return ret
