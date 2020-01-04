"""
Support for msys2 (https://www.msys2.org)
Inspired by the source code from https://github.com/peakwinter/python-pacman
"""

import salt.utils.platform
import salt.exceptions
from shlex import quote
import os
import signal


def __virtual__():
    """
    Only works on Windows systems
    """
    if salt.utils.platform.is_windows():
        return True
    else:
        return (False, "Module msys2: module only works on Windows systems.")


def pkg_install(
    packages, version=None, needed=True, shell_path=None, shell_args="-lc", **kwargs
):
    """
    Install a package

    Args

        packages (list or string):
            list of packages to install
            can be a list or a string separated by a comma between package name

        version (string):
            specific version to install instead of the last
            Note when you specify a version you can install only one package

        needed (bool):
            pass the needed option to pacman (True by default)

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)

    Returns

        none
    """
    if isinstance(packages, list):
        pkgs = " ".join(packages)
    else:
        pkgs = " ".join(packages.split(","))
    if version:
        if len(pkgs.split()) != 1:
            raise salt.exceptions.CommandExecutionError(
                "Only one package can be installed when you specify a version"
            )
        s = pacman(
            "-Si",
            packages,
            shell_path=shell_path,
            shell_args=shell_args,
            **kwargs
        )
        if s["retcode"] != 0:
            raise salt.exceptions.CommandExecutionError(
                "Failed to install: {}".format(s["stderr"])
            )
        interim = []
        for x in s["stdout"].split("\n"):
            if not x.split():
                continue
            if ":" in x:
                x = x.split(":", 1)
                interim.append((x[0].strip(), x[1].strip()))
            else:
                data = interim[-1]
                data = (data[0], data[1] + "  " + x.strip())
                interim[-1] = data
        pkg = {}
        for x in interim:
            pkg[x[0]] = x[1]
        if pkg["Repository"] == "mingw32":
            repo = "mingw/i686"
        elif pkg["Repository"] == "mingw64":
            repo = "mingw/x86_64"
        else:
            repo = "msys/x86_64"
        # Install a specific package version
        s = pacman(
            "-U",
            "http://repo.msys2.org/{}/{}-{}-{}.pkg.tar.xz".format(
                repo, pkg["Name"], version, pkg["Architecture"]
            ),
            ["--needed" if needed else None, "--overwrite='*'"],
            shell_path=shell_path,
            shell_args=shell_args,
            **kwargs
        )
        if s["retcode"] != 0:
            raise salt.exceptions.CommandExecutionError(
                "Failed to install {}: version {} does not exist".format(pkg["Name"], version)
            )
    else:
        # Install package(s)
        s = pacman(
            "-S",
            pkgs,
            ["--needed" if needed else None, "--overwrite='*'"],
            shell_path=shell_path,
            shell_args=shell_args,
            **kwargs
        )
        if s["retcode"] != 0:
            raise salt.exceptions.CommandExecutionError(
                "Failed to install: {}".format(s["stderr"])
            )


def pkg_refresh(shell_path=None, shell_args="-lc", **kwargs):
    """
    Download fresh package databases from the server

    Args

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)

    Returns

        none
    """
    # Refresh the local package information database
    s = pacman("-Sy", shell_path=shell_path, shell_args=shell_args, **kwargs)
    if s["retcode"] != 0:
        raise salt.exceptions.CommandExecutionError(
            "Failed to refresh database: {}".format(s["stderr"])
        )


def pkg_upgrade(packages=[], shell_path=None, shell_args="-lc", **kwargs):
    """
    Upgrade packages

    Args

        packages (list or string):
            list of packages to upgrade
            can be a list or a string separated by a comma between package name
            if no packages are provided, all packages will be upgraded

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)

    Returns

        none
    """
    if packages:
        if isinstance(packages, list):
            pkgs = " ".join(packages)
        else:
            pkgs = " ".join(packages.split(","))
        # Upgrade packages; if unspecified upgrade all packages
        pkg_install(pkgs, shell_path=shell_path, shell_args=shell_args, **kwargs)
    else:
        # Workaround to prevent Appveyor from getting stuck
        s = cmd("pacman --noconfirm -Su; kill -9 -1", shell_path=shell_path, shell_args=shell_args, **kwargs)
        if s["retcode"] not in [0, 2304]: # 2304 is the return code when pacman is killed
            raise salt.exceptions.CommandExecutionError(
                "Failed to upgrade packages: {}".format(s["stderr"])
            )


def pkgs_get_upgradable(shell_path=None, shell_args="-lc", **kwargs):
    """
    List of packages that have an update

    Args

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)

    Returns

        list:
            packages that are upgradable
    """
    return [
        pkg["id"]
        for pkg in pkg_get_installed(
            shell_path=shell_path, shell_args=shell_args, **kwargs
        )
        if pkg["upgradable"]
    ]


def is_pkg_installed(package, shell_path=None, shell_args="-lc", **kwargs):
    """
    Check if a package is installed

    Args

        package (string):
            name of the package to check if installed

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)

    Returns

        bool:
            True if package is installed else False
    """
    s = pacman("-Q", package, shell_path=shell_path, shell_args=shell_args, **kwargs)
    if s["retcode"] == 0:
        return True
    else:
        return False


def is_pkg_upgradable(package, shell_path=None, shell_args="-lc", **kwargs):
    """
    check if a package is upgradable

    Args

        package (string):
            name of the package to check if upgradable

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)

    Returns

        bool:
            True if package is upgradable else False
    """
    return (
        True
        if pkg_get_info(
            package, shell_path=shell_path, shell_args=shell_args, **kwargs
        ).get("Name")
        in pkgs_get_upgradable(
            shell_path=shell_path, shell_args=shell_args, **kwargs
        )
        else False
    )


def pkg_remove(packages, purge=False, shell_path=None, shell_args="-lc", **kwargs):
    """
    Remove an istalled package

    Args

        package (string):
            name of the package to check if upgradable

        purge (bool):
            if True (default) then remove also configuration files

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)

    Returns

        none
    """
    if isinstance(packages, list):
        pkgs = " ".join(
            [
                pkg_get_info(
                    pkg, shell_path=shell_path, shell_args=shell_args, **kwargs
                )["Name"]
                for pkg in packages
            ]
        )
    else:
        pkgs = " ".join(
            [
                pkg_get_info(
                    pkg, shell_path=shell_path, shell_args=shell_args, **kwargs
                )["Name"]
                for pkg in packages.split(",")
            ]
        )
    # Remove package(s), purge its files if requested
    s = pacman(
        "-Rcs{}".format("n" if purge else ""),
        pkgs,
        shell_path=shell_path,
        shell_args=shell_args,
        **kwargs
    )
    if s["retcode"] != 0:
        raise salt.exceptions.CommandExecutionError(
            "Failed to remove: {}".format(s["stderr"])
        )


def pkg_get_all(shell_path=None, shell_args="-lc", **kwargs):
    """
    Get list of packages with some details:
        package version
        is the package installed
        is the package upgradable

    Args

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)

    Returns

        list:
            list (of dict) of packages
    """
    # List all packages, installed and not installed
    interim, results = {}, []
    s = pacman("-Q", shell_path=shell_path, shell_args=shell_args, **kwargs)
    if s["retcode"] != 0:
        raise salt.exceptions.CommandExecutionError(
            "Failed to get installed list: {}".format(s["stderr"])
        )
    for x in s["stdout"].split("\n"):
        if not x.split():
            continue
        x = x.split(" ")
        interim[x[0]] = {
            "id": x[0],
            "version": x[1],
            "upgradable": False,
            "installed": True,
        }
    s = pacman("-Sl", shell_path=shell_path, shell_args=shell_args, **kwargs)
    if s["retcode"] != 0:
        raise salt.exceptions.CommandExecutionError(
            "Failed to get available list: {}".format(s["stderr"])
        )
    for x in s["stdout"].split("\n"):
        if not x.split():
            continue
        x = x.split(" ")
        if x[1] in interim:
            interim[x[1]]["repo"] = x[0]
            if interim[x[1]]["version"] != x[2]:
                interim[x[1]]["upgradable"] = x[2]
        else:
            results.append(
                {
                    "id": x[1],
                    "repo": x[0],
                    "version": x[2],
                    "upgradable": False,
                    "installed": False,
                }
            )
    for x in interim:
        results.append(interim[x])
    return results


def pkg_get_installed(shell_path=None, shell_args="-lc", **kwargs):
    """
    Get list of installed packages

    Args

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)

    Returns

        list:
            list (of dict) of packages
    """
    # List all installed packages
    interim = {}
    s = pacman("-Q", shell_path=shell_path, shell_args=shell_args, **kwargs)
    if s["retcode"] != 0:
        raise salt.exceptions.CommandExecutionError(
            "Failed to get installed list: {}".format(s["stderr"])
        )
    for x in s["stdout"].split("\n"):
        if not x.split():
            continue
        x = x.split(" ")
        interim[x[0]] = {
            "id": x[0],
            "version": x[1],
            "upgradable": False,
            "installed": True,
        }
    s = pacman("-Qu", shell_path=shell_path, shell_args=shell_args, **kwargs)
    if s["retcode"] != 0 and s["stderr"]:
        raise salt.exceptions.CommandExecutionError(
            "Failed to get upgradable list: {}".format(s["stderr"])
        )
    for x in s["stdout"].split("\n"):
        if not x.split():
            continue
        x = x.split(" -> ")
        name = x[0].split(" ")[0]
        if name in interim:
            r = interim[name]
            r["upgradable"] = x[1]
            interim[name] = r
    results = []
    for x in interim:
        results.append(interim[x])
    return results


def pkg_get_available(shell_path=None, shell_args="-lc", **kwargs):
    """
    Get list of packages from remote repository

    Args

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)

    Returns

        list:
            list (of dict) of packages
    """
    # List all available packages
    results = []
    s = pacman("-Sl", shell_path=shell_path, shell_args=shell_args, **kwargs)
    if s["retcode"] != 0:
        raise salt.exceptions.CommandExecutionError(
            "Failed to get available list: {}".format(s["stderr"])
        )
    for x in s["stdout"].split("\n"):
        if not x.split():
            continue
        x = x.split(" ")
        results.append({"id": x[1], "repo": x[0], "version": x[2]})
    return results


def pkg_get_info(package, shell_path=None, shell_args="-lc", **kwargs):
    """
    Get informations about a package

    Args

        package (string):
            package to ask some information

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)

    Returns

        list:
            list (of dict) of packages
    """
    # Get package information from database
    interim = []
    s = pacman(
        "-Qi"
        if pkg_is_installed(
            package, shell_path=shell_path, shell_args=shell_args, **kwargs
        )
        else "-Si",
        package,
        shell_path=shell_path,
        shell_args=shell_args,
        **kwargs
    )
    if s["retcode"] != 0:
        raise salt.exceptions.CommandExecutionError(
            "Failed to get info: {}".format(s["stderr"])
        )
    for x in s["stdout"].split("\n"):
        if not x.split():
            continue
        if ":" in x:
            x = x.split(":", 1)
            interim.append((x[0].strip(), x[1].strip()))
        else:
            data = interim[-1]
            data = (data[0], data[1] + "  " + x.strip())
            interim[-1] = data
    result = {}
    for x in interim:
        result[x[0]] = x[1]
    return result


def pkg_needs_for(packages, shell_path=None, shell_args="-lc", **kwargs):
    """
    Get dependancies for packages

    Args

        packages (list or string):
            list of packages to ask
            can be a list or a string separated by a comma between package name

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)

    Returns

        list:
            list of packages
    """
    if isinstance(packages, list):
        pkgs = " ".join(packages)
    else:
        pkgs = " ".join(packages.split(","))
    # Get list of not-yet-installed dependencies of these packages
    s = pacman(
        "-Sp",
        pkgs,
        ["--print-format", "%n"],
        shell_path=shell_path,
        shell_args=shell_args,
        **kwargs
    )
    if s["retcode"] != 0:
        raise salt.exceptions.CommandExecutionError(
            "Failed to get requirements: {}".format(s["stderr"])
        )
    return [x for x in s["stdout"].split("\n") if x]


def pkg_depends_for(packages, shell_path=None, shell_args="-lc", **kwargs):
    """
    Get list of installed packages that depend on these packages

    Args

        packages (list or string):
            list of packages to ask
            can be a list or a string separated by a comma between package name

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)

    Returns

        list:
            list of packages
    """
    if isinstance(packages, list):
        pkgs = " ".join(packages)
    else:
        pkgs = " ".join(packages.split(","))
    # Get list of installed packages that depend on these
    s = pacman(
        "-Rpc",
        pkgs,
        ["--print-format", "%n"],
        shell_path=shell_path,
        shell_args=shell_args,
        **kwargs
    )
    if s["retcode"] != 0:
        raise salt.exceptions.CommandExecutionError(
            "Failed to get depends: {}".format(s["stderr"])
        )
    return [x for x in s["stdout"].split("\n") if x]


def pkg_is_installed(package, shell_path=None, shell_args="-lc", **kwargs):
    """
    Check if a package is installed

    Args

        package (string):
            package to check if installed

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)

    Returns

        bool:
            True if the package is installed else False
    """
    # Return True if the specified package is installed
    return (
        pacman(
            "-Q", package, shell_path=shell_path, shell_args=shell_args, **kwargs
        )["retcode"]
        == 0
    )


def pacman(flags, packages=[], eflags=[], shell_path=None, shell_args="-lc", **kwargs):
    """
    pacman wrapper

    Args

        flags (string):
                -D or --database <options>
                -F or --files    [options]
                -Q or --query    [options]
                -R or --remove   [options]
                -S or --sync     [options]
                -T or --deptest  [options]
                -U or --upgrade  [options]

        packages (list or string):
            package(s) name

        eflags:
            extra flags

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)

    Returns

        bool:
            salt cmd.run_all object
    """
    # Subprocess wrapper, get all data
    if not packages:
        c = "pacman --noconfirm {}".format(flags)
    elif isinstance(packages, list):
        c = "pacman --noconfirm {} {}".format(flags, " ".join([quote(s) for s in packages]))
    else:
        c = "pacman --noconfirm {} {}".format(flags, packages)
    if eflags and any(eflags):
        eflags = [x for x in eflags if x]
        c += " {}".format(" ".join(eflags))
    return cmd(c, shell_path=shell_path, shell_args=shell_args, **kwargs)


def cmd(cmd, shell_path, shell_args="-lc", **kwargs):
    """
    salt cmd.run_all wrapper

    Args

        cmd:
            cmd to run

        shell_path (string):
            full path to the MSYS2 shell binary (bash recommended)

        shell_args (string):
            options to give to shell_path ("-lc" by default)

        kwargs:
            salt cmd.run_all options

    Returns

        bool:
            salt cmd.run_all object
    """
    if shell_path is None:
        raise salt.exceptions.CommandExecutionError(
            "missing mandatory argument shell_path"
        )

    if not isinstance(shell_path, str) or not os.path.exists(shell_path):
        raise salt.exceptions.CommandExecutionError(
            "command not found: {}".format(shell_path)
        )
    # Run a command within MSYS2
    kwargs["python_shell"] = kwargs.get("python_shell", False)
    kwargs["ignore_retcode"] = kwargs.get("ignore_retcode", True)
    c = "{} {} {}".format(shell_path, shell_args, quote(cmd))
    return __salt__["cmd.run_all"](c, **kwargs)
