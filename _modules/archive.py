"""
Support for archive management
"""

# import salt.utils.path
import salt.exceptions
import salt.utils.platform
import os
import tarfile


def __virtual__():
    """
    Load the module archive
    """
    return True


def extract(src, dest):
    """
    Extract an archive

    Args

        src (str):
            path of the archive. source can also be an http link

        dest (str):
            path where to extract the archive

    Returns

        bool:
            True
    """
    if src.startswith("http"):
        # import urllib
        # import platform
        # if platform.version().startswith("2"):
        #     archive = urllib.urlretrieve(src, filename=os.path.basename(src))[0]
        # else:
        #     archive = urllib.request.urlretrieve(src, filename=os.path.basename(src))[0]
        __salt__["cp.get_url"](src, dest=os.path.join(dest, os.path.basename(src)))
        archive = os.path.join(dest, os.path.basename(src))
    else:
        archive = src
    if src.endswith(".tar"):
        tarfile.open(archive, "r:", errorlevel=0).extractall(path=dest)
    elif src.endswith(".tar.bz2") or src.endswith(".tbz2"):
        tarfile.open(archive, "r:bz2", errorlevel=0).extractall(path=dest)
    elif src.endswith(".tar.gz") or src.endswith(".tgz"):
        tarfile.open(archive, "r:gz", errorlevel=0).extractall(path=dest)
    elif src.endswith(".tar.xz") or src.endswith(".txz"):
        tarfile.open(archive, "r:xz", errorlevel=0).extractall(path=dest)
    else:
        raise salt.exceptions.CommandExecutionError(
            "Archive '{}' is not supported".format(os.path.splitext(src)[-1])
        )
    os.remove(archive)
    return True
