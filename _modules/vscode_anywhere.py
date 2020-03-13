"""
Functions for VSCode-Anywhere
"""

import salt.utils.platform
import salt.utils.files
import salt.exceptions
import os
import re


def __virtual__():
    """
    Load the module
    """
    return True


def get_id(sls):
    """
    Generate an id based on the sls

    Args

        sls (str):
            sls Saltstack variable ({{ sls }})

    Returns

        list:
            Return the id for a state

    """
    return sls.replace("/", ":").replace(".", ":")


def relpath(source, dest):
    """
    Return the relative path between two paths

    Args

        source (str):
            Start path

        dest (str):
            End path

    Returns

        str:
            Return the relative path from the source to the dest path
    """
    relpath = os.path.relpath(dest, source)
    if str(relpath).startswith("."):
        return relpath
    else:
        return os.path.join(".", str(relpath))


def abspath(path):
    """
    Return the absolute path of a path

    Args

        path (str):
            path to convert

    Returns

        str:
            Return the absolute path from the source to the dest path
    """
    return os.path.abspath(path)


def get_env():
    """
    Read the VSCode-Anywhere environment file and return a dict

    Returns

        dict:
            Returns a dictionnary environment
    """
    found = {}
    env_file = __salt__["grains.get"]("vscode-anywhere:tools:env")

    if os.path.isfile(env_file):
        with salt.utils.files.fopen(env_file) as _f:
            for line in _f.readlines():
                comment = re.search("^\\s*#", line)
                if not comment:
                    if salt.utils.platform.is_windows():
                        search = re.search("^\\$env:(.*?)=(.*)$", line)
                    else:
                        search = re.search("^(.*?)=(.*)$", line)

                    if search and len(search.groups()) == 2:
                        found[search.group(1)] = search.group(2).strip('"').strip("'")
    return found


def is_path_env(val):
    env_file = __salt__["grains.get"]("vscode-anywhere:tools:env")

    if salt.utils.platform.is_windows():
        sep = ";"
        regex = "^\\s*\\$env\\:PATH\\=[\"\\']?([^\"\\']*?)[\"\\']?$"
    else:
        sep = ":"
        regex = "^\\s*PATH\\=[\"\\']?([^\"\\']*?)[\"\\']?$"

    if os.path.isfile(env_file):
        with salt.utils.files.fopen(env_file, mode="r+") as _f:
            for line in _f.readlines():
                search = re.search(regex, line)

                if search:
                    if len(search.groups()) == 1 and val in search.group(1).split(sep):
                        return True
                    else:
                        return False
        return False
    else:
        raise salt.exceptions.SaltInvocationError(
            "File {} does not exist".format(env_file)
        )


def append_path_env(val):
    env_file = __salt__["grains.get"]("vscode-anywhere:tools:env")
    path = []
    find = False

    if salt.utils.platform.is_windows():
        sep = ";"
        regex = "^\\s*\\$env\\:PATH\\=[\"\\']?([^\"\\']*?)[\"\\']?$"
    else:
        sep = ":"
        regex = "^\\s*PATH\\=[\"\\']?([^\"\\']*?)[\"\\']?$"

    if os.path.isfile(env_file):
        orig_file = open(env_file, mode="r").readlines()
        with salt.utils.files.fopen(env_file, mode="w") as _f:
            for line in orig_file:
                search = re.search(regex, line)
                for v in val.split(sep):
                    if search:
                        find = True
                        if len(search.groups()) == 1 and v not in search.group(1).split(
                            sep
                        ):
                            path.append(v)

                if path and search and len(search.groups()) == 1:
                    s_path = "{}".format(sep).join(path)

                    if salt.utils.platform.is_windows():
                        _f.write(
                            '$env:PATH="{}{}{}"\n'.format(s_path, sep, search.group(1))
                        )
                    else:
                        _f.write('PATH="{}{}{}"\n'.format(s_path, sep, search.group(1)))
                else:
                    _f.write("{}".format(line))

            if find is False:
                if salt.utils.platform.is_windows():
                    _f.write('$env:PATH="{}"'.format(val))
                else:
                    _f.write('PATH="{}"'.format(val))

        new_file = open(env_file, mode="r").readlines()
        differences = __utils__["stringutils.get_diff"](orig_file, new_file)
        return differences
    else:
        raise salt.exceptions.SaltInvocationError(
            "File {} does not exist".format(env_file)
        )


def remove_path_env(val):
    env_file = __salt__["grains.get"]("vscode-anywhere:tools:env")
    path = []

    if salt.utils.platform.is_windows():
        sep = ";"
        regex = "^\\s*\\$env\\:PATH\\=[\"\\']?([^\"\\']*?)[\"\\']?$"
    else:
        sep = ":"
        regex = "^\\s*PATH\\=[\"\\']?([^\"\\']*?)[\"\\']?$"

    if os.path.isfile(env_file):
        orig_file = open(env_file, mode="r").readlines()
        with salt.utils.files.fopen(env_file, mode="w") as _f:
            for line in orig_file:
                search = re.search(regex, line)
                if search:
                    path = search.group(1).split(sep)
                    for v in val.split(sep):
                        if v in path:
                            path.remove(v)

                if path and search and len(search.groups()) == 1:
                    s_path = "{}".format(sep).join(path)

                    if salt.utils.platform.is_windows():
                        _f.write('$env:PATH="{}"\n'.format(s_path))
                    else:
                        _f.write('PATH="{}"\n'.format(s_path))
                else:
                    _f.write("{}".format(line))

        new_file = open(env_file, mode="r").readlines()
        differences = __utils__["stringutils.get_diff"](orig_file, new_file)
        return differences
    else:
        raise salt.exceptions.SaltInvocationError(
            "File {} does not exist".format(env_file)
        )


def cleanup():
    if salt.utils.platform.is_windows():
        raise salt.exceptions.SaltInvocationError("Not yet available on Windows")
    else:
        nix = __salt__["nix.collect_garbage"]()
        brew = __salt__["cmd.run"]("/home/linuxbrew/.linuxbrew/bin/brew cleanup -s")
        if brew == "":
            brew = "Nothing to cleanup"
        return {
            "brew": brew.splitlines(),
            "nix": nix,
        }
        # return "Nix:\n{}\n\nBrew:\n{}".format("\n".join(nix), brew)
