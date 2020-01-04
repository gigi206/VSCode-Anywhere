"""
Support for scoop (https://scoop.sh)
"""

import salt.utils.platform
import salt.exceptions
import salt.utils.json
from glob import glob
import os
from ctypes import (
    WinDLL,
    POINTER,
    c_ubyte,
    Structure,
    addressof,
    Union,
    WinError,
    c_buffer,
    byref,
)
from ctypes.wintypes import DWORD, LPCWSTR, HANDLE, LPVOID, BOOL, WCHAR, USHORT, ULONG


def __virtual__():
    """
    Only works on Windows systems
    """
    if salt.utils.platform.is_windows():
        return True
    else:
        return (False, "Module scoop: module only works on Windows systems.")


# def bootstrap():
#     # https://www.tenforums.com/tutorials/54585-change-powershell-script-execution-policy-windows-10-a.html
#     # HKEY_CURRENT_USER\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell
#     # Get-ExecutionPolicy -List
#     # Set-ExecutionPolicy RemoteSigned -scope CurrentUser -Force

#     __salt__['reg.set_value']('HKEY_CURRENT_USER', 'SOFTWARE\\Microsoft\\PowerShell\\1\\ShellIds\\Microsoft.PowerShell', 'RemoteSigned')
#     __salt__['environ.setenv']({'SCOOP': '{}\\scoop'.format(__salt__['grains.get']('vscode-anywhere:apps_dir'))}, update_minion=True, permanent=True)
#     return __salt__['cmd.run_all']("Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')", shell='powershell')


def apps_dir():
    """
    Path where applications are installed

    Args

        None

    Returns

        string:
            applications path
    """
    return os.path.join(
        __salt__["grains.get"]("vscode-anywhere:apps:path"), "scoop", "apps"
    )


def bucket_dir():
    """
    Path where buckets are stored

    Args

        None

    Returns

        string:
            buckets path
    """
    return os.path.join(
        __salt__["grains.get"]("vscode-anywhere:apps:path"), "scoop", "buckets"
    )


def _readlink(path):
    # Read https://eklausmeier.wordpress.com/2015/10/27/working-with-windows-junctions-in-python/
    """
    Read the target link

    Args

        link (string):
            link to read the target

    Returns

        string:
            target of the link
    """
    kernel32 = WinDLL("kernel32")
    LPDWORD = POINTER(DWORD)
    UCHAR = c_ubyte

    GetFileAttributesW = kernel32.GetFileAttributesW
    GetFileAttributesW.restype = DWORD
    GetFileAttributesW.argtypes = (LPCWSTR,)  # lpFileName In

    INVALID_FILE_ATTRIBUTES = 0xFFFFFFFF
    FILE_ATTRIBUTE_REPARSE_POINT = 0x00400

    CreateFileW = kernel32.CreateFileW
    CreateFileW.restype = HANDLE
    CreateFileW.argtypes = (
        LPCWSTR,  # lpFileName In
        DWORD,  # dwDesiredAccess In
        DWORD,  # dwShareMode In
        LPVOID,  # lpSecurityAttributes In_opt
        DWORD,  # dwCreationDisposition In
        DWORD,  # dwFlagsAndAttributes In
        HANDLE,
    )  # hTemplateFile In_opt

    CloseHandle = kernel32.CloseHandle
    CloseHandle.restype = BOOL
    CloseHandle.argtypes = (HANDLE,)  # hObject In

    INVALID_HANDLE_VALUE = HANDLE(-1).value
    OPEN_EXISTING = 3
    FILE_FLAG_BACKUP_SEMANTICS = 0x02000000
    FILE_FLAG_OPEN_REPARSE_POINT = 0x00200000

    DeviceIoControl = kernel32.DeviceIoControl
    DeviceIoControl.restype = BOOL
    DeviceIoControl.argtypes = (
        HANDLE,  # hDevice In
        DWORD,  # dwIoControlCode In
        LPVOID,  # lpInBuffer In_opt
        DWORD,  # nInBufferSize In
        LPVOID,  # lpOutBuffer Out_opt
        DWORD,  # nOutBufferSize In
        LPDWORD,  # lpBytesReturned Out_opt
        LPVOID,
    )  # lpOverlapped Inout_opt

    FSCTL_GET_REPARSE_POINT = 0x000900A8
    IO_REPARSE_TAG_MOUNT_POINT = 0xA0000003
    IO_REPARSE_TAG_SYMLINK = 0xA000000C
    MAXIMUM_REPARSE_DATA_BUFFER_SIZE = 0x4000

    class GENERIC_REPARSE_BUFFER(Structure):
        _fields_ = (("DataBuffer", UCHAR * 1),)

    class SYMBOLIC_LINK_REPARSE_BUFFER(Structure):
        _fields_ = (
            ("SubstituteNameOffset", USHORT),
            ("SubstituteNameLength", USHORT),
            ("PrintNameOffset", USHORT),
            ("PrintNameLength", USHORT),
            ("Flags", ULONG),
            ("PathBuffer", WCHAR * 1),
        )

        @property
        def PrintName(self):
            arrayt = WCHAR * (self.PrintNameLength // 2)
            offset = type(self).PathBuffer.offset + self.PrintNameOffset
            return arrayt.from_address(addressof(self) + offset).value

    class MOUNT_POINT_REPARSE_BUFFER(Structure):
        _fields_ = (
            ("SubstituteNameOffset", USHORT),
            ("SubstituteNameLength", USHORT),
            ("PrintNameOffset", USHORT),
            ("PrintNameLength", USHORT),
            ("PathBuffer", WCHAR * 1),
        )

        @property
        def PrintName(self):
            arrayt = WCHAR * (self.PrintNameLength // 2)
            offset = type(self).PathBuffer.offset + self.PrintNameOffset
            return arrayt.from_address(addressof(self) + offset).value

    class REPARSE_DATA_BUFFER(Structure):
        class REPARSE_BUFFER(Union):
            _fields_ = (
                ("SymbolicLinkReparseBuffer", SYMBOLIC_LINK_REPARSE_BUFFER),
                ("MountPointReparseBuffer", MOUNT_POINT_REPARSE_BUFFER),
                ("GenericReparseBuffer", GENERIC_REPARSE_BUFFER),
            )

        _fields_ = (
            ("ReparseTag", ULONG),
            ("ReparseDataLength", USHORT),
            ("Reserved", USHORT),
            ("ReparseBuffer", REPARSE_BUFFER),
        )
        _anonymous_ = ("ReparseBuffer",)

    def islink(path):
        result = GetFileAttributesW(path)
        if result == INVALID_FILE_ATTRIBUTES:
            raise WinError()
        return bool(result & FILE_ATTRIBUTE_REPARSE_POINT)

    def readlink(path):
        reparse_point_handle = CreateFileW(
            path,
            0,
            0,
            None,
            OPEN_EXISTING,
            FILE_FLAG_OPEN_REPARSE_POINT | FILE_FLAG_BACKUP_SEMANTICS,
            None,
        )
        if reparse_point_handle == INVALID_HANDLE_VALUE:
            raise WinError()
        target_buffer = c_buffer(MAXIMUM_REPARSE_DATA_BUFFER_SIZE)
        n_bytes_returned = DWORD()
        io_result = DeviceIoControl(
            reparse_point_handle,
            FSCTL_GET_REPARSE_POINT,
            None,
            0,
            target_buffer,
            len(target_buffer),
            byref(n_bytes_returned),
            None,
        )
        CloseHandle(reparse_point_handle)
        if not io_result:
            raise WinError()
        rdb = REPARSE_DATA_BUFFER.from_buffer(target_buffer)
        if rdb.ReparseTag == IO_REPARSE_TAG_SYMLINK:
            return rdb.SymbolicLinkReparseBuffer.PrintName
        elif rdb.ReparseTag == IO_REPARSE_TAG_MOUNT_POINT:
            return rdb.MountPointReparseBuffer.PrintName
        raise ValueError("not a link")

    return readlink(path)


# def _readlink(link):
#     """
#     Read the target link

#     Args

#         link (string):
#             link to read the target

#     Returns

#         string:
#             target of the link
#     """
#     readlink = os.path.join(
#         __salt__["grains.get"]("vscode-anywhere:apps:path"),
#         "scoop",
#         "msys2",
#         "current",
#         "usr",
#         "bin",
#         "readlink.exe",
#     )
#     cygpath = os.path.join(
#         __salt__["grains.get"]("vscode-anywhere:apps:path"),
#         "scoop",
#         "msys2",
#         "current",
#         "usr",
#         "bin",
#         "cygpath.exe",
#     )

#     if not os.path.exists(link):
#         raise salt.exceptions.CommandExecutionError(
#             "Failed to resolved link {} => link does not exist".format(link)
#         )

#     ret = __salt__["cmd.run_all"]("{} {}".format(readlink, link))
#     if ret["retcode"] == 0 or not ret["stderr"]:
#         target = ret["stdout"]
#     else:
#         raise salt.exceptions.CommandExecutionError(
#             "Failed to resolved link {} => {}".format(link, ret["stderr"])
#         )

#     ret = __salt__["cmd.run_all"]("{} -w {}".format(cygpath, target))
#     if ret["retcode"] == 0 or not ret["stderr"]:
#         return ret["stdout"]
#     else:
#         raise salt.exceptions.CommandExecutionError(
#             "Failed to resolved link {} => {}".format(link, ret["stderr"])
#         )


def _pkg_path(pkg):
    """
    Path the of a specified application

    Args

        pkg (string):
            name of the application

    Returns

        string:
            path of the specified application
    """
    pkg_path = os.path.join(apps_dir(), pkg)
    if os.path.isdir(pkg_path):
        return pkg_path
    else:
        raise salt.exceptions.CommandExecutionError(
            "Package {} is not installed".format(pkg)
        )


def _pkg_current_path(pkg):
    """
    Path of the current version of a specified application

    Args

        pkg (string):
            name of the application

    Returns

        string:
            path of the current version of the specified application
    """
    pkg_path = os.path.join(apps_dir(), pkg, "current")
    if os.path.isdir(pkg_path):
        return pkg_path
    else:
        raise salt.exceptions.CommandExecutionError(
            "Package {} is not installed".format(pkg)
        )


def pkg_current_version(pkg):
    """
    Version of an application

    Args

        pkg (string):
            application to check

    Returns

        string:
            version of the current application
    """
    return os.path.basename(_readlink(_pkg_current_path(pkg)))


def pkg_installed_versions(pkg):
    """
    List of packages that have an update

    Args

        pkg (string):
            name of the application

    Returns

        list:
            versions of the application
    """
    versions = os.listdir(_pkg_path(pkg))
    versions.remove("current")
    return versions


def pkg_get_available():
    """
    List of applications that could be installed

    Args

        None

    Returns

        list:
            available applications
    """
    return sorted(
        set(
            [
                pkg.split(".")[0].split("\\")[-1]
                for pkg in glob("{}/*/bucket/*.json".format(bucket_dir()))
            ]
        )
    )


def pkg_get_installed():
    """
    List of the installed applications

    Args

        None

    Returns

        list:
            applicationsinstalled
    """
    return os.listdir(apps_dir())


def pkg_install(
    pkg,
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

        pkg (string):
            name of the application to install

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

    Returns

        dict:
            int:
                retcode

            str:
                stderr

            str:
                stdout
"""
    cmd = [path, "install"]

    if version:
        pkg += "@" + str(version)

    if globally:
        cmd.append("-g")

    if independent:
        cmd.append("-i")

    if nocache:
        cmd.append("-k")

    if skip:
        cmd.append("-s")

    if arch:
        cmd.extend(["-a", arch])

    cmd.append(pkg)

    ret = __salt__["cmd.run_all"](cmd, python_shell=False)
    return ret


def pkg_remove(pkg, version=None, globally=None, purge=None, path="scoop.cmd"):
    """
    Remove an application

    Args

        pkg (string):
            name of the application to uninstall

        version (string):
            specific version to uninstall (all by default)

        globally (bool):
            install the app globally if True (default is None)

        purge (bool):
            remove all persistent data (default is None)

    Returns

        dict:
            int:
                retcode

            str:
                stderr

            str:
                stdout
    """
    cmd = [path, "uninstall"]

    if version:
        pkg += "@" + str(version)

    if globally:
        cmd.append("-g")

    if purge:
        cmd.append("-p")

    cmd.append(pkg)

    ret = __salt__["cmd.run_all"](cmd, python_shell=False)
    return ret


def pkg_latest(
    pkg=None,
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

        pkg (string):
            name of the application to upgrade

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

    Returns

        dict:
            int:
                retcode

            str:
                stderr

            str:
                stdout
    """
    cmd = [path, "update"]

    if force:
        cmd.append("-f")

    if globally:
        cmd.append("-g")

    if independent:
        cmd.append("-i")

    if nocache:
        cmd.append("-k")

    if skip:
        cmd.append("-s")

    if quiet:
        cmd.append("-q")

    if pkg:
        cmd.append(pkg)

    ret = __salt__["cmd.run_all"](cmd, python_shell=False)
    return ret


def pkg_cleanup(pkg, globally=None, cache=None, path="scoop.cmd"):
    """
    Cleanup an application by removing old versions

    Args

        pkg (string):
            name of the application to cleanup

        globally (bool):
            cleanup globally an application (default is None)

        cache (bool):
            remove outdated download cache

    Returns

        dict:
            int:
                retcode

            str:
                stderr

            str:
                stdout
    """
    cmd = [path, "cleanup"]

    if globally:
        cmd.append("-g")

    if cache:
        cmd.append("-k")

    cmd.append(pkg)

    ret = __salt__["cmd.run_all"](cmd, python_shell=False)
    return ret


def is_pkg_installed(pkg):
    """
    Check if an application is installed

    Args

        pkg (string):
            name of the application to check

    Returns

        bool:
            Return True if application is installed else False
    """
    try:
        return os.path.isdir(os.path.join(_pkg_path(pkg)))
    except Exception:
        return False


def pkg_last_version(pkg):
    """
    Last available version for an application

    Args

        pkg (string):
            name of the application to check

    Returns

        string:
            last available version of the specified application
    """
    found = [
        p
        for p in glob("{}/*/bucket/*.json".format(bucket_dir()))
        if p.endswith("\\{}.json".format(pkg))
    ]
    if found:
        with salt.utils.files.fopen(found[0]) as _f:
            json = salt.utils.json.load(_f)
            return json.get("version")
    else:
        raise salt.exceptions.CommandExecutionError(
            "Package {} is not available".format(pkg)
        )


def is_pkg_latest(pkg):
    """
    Check if the current version of an aplication is the latest version

    Args

        pkg (string):
            name of the application to check

    Returns

        bool:
            True if the current application is the latest version else False
    """
    if pkg_current_version(pkg) == pkg_last_version(pkg):
        return True
    else:
        return False


def pkg_hold(pkg, path="scoop.cmd"):
    """
    Hold an application to disable updates

    Args

        pkg (string):
            application to hold

    Returns

        dict:
            int:
                retcode

            str:
                stderr

            str:
                stdout
    """
    cmd = [path, "hold"]
    cmd.append(pkg)
    ret = __salt__["cmd.run_all"](cmd, python_shell=False)
    return ret


def pkg_unhold(pkg, path="scoop.cmd"):
    """
    Unhold an application to enable updates

    Args

        pkg (string):
            application to unhold

    Returns

        dict:
            int:
                retcode

            str:
                stderr

            str:
                stdout
    """
    cmd = [path, "unhold"]
    cmd.append(pkg)
    ret = __salt__["cmd.run_all"](cmd, python_shell=False)
    return ret


def is_pkg_locked(pkg):
    """
    Check if an aplication is locked

    Args

        pkg (string):
            name of the application to check

    Returns

        bool:
            True if the application is locked else False
    """
    install_json = os.path.join(_pkg_current_path(pkg), "install.json")
    with salt.utils.files.fopen(install_json) as _f:
        json = salt.utils.json.load(_f)
        if bool(json.get("hold")) or bool(json.get("url")):
            return True
        else:
            return False


def is_pkg_holded(pkg):
    """
    Check if an aplication is hold

    Args

        pkg (string):
            name of the application to check

    Returns

        bool:
            True if the application is hold else False
    """
    install_json = os.path.join(_pkg_current_path(pkg), "install.json")
    with salt.utils.files.fopen(install_json) as _f:
        json = salt.utils.json.load(_f)
        if bool(json.get("hold")):
            return True
        else:
            return False


def bucket_latest(
    force=None,
    globally=None,
    independent=None,
    nocache=None,
    skip=None,
    quiet=None,
    path="scoop.cmd",
):
    """
    Update all buckets to the latest versions

    Args

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

    Returns

        dict:
            int:
                retcode

            str:
                stderr

            str:
                stdout
    """
    return pkg_latest(
        pkg=None,
        force=force,
        globally=globally,
        independent=independent,
        nocache=nocache,
        skip=skip,
        quiet=quiet,
        path=path,
    )


def bucket_list(path="scoop.cmd"):
    """
    Installed buckets

    Args

        None

    Returns

        List:
            List of the installed buckets
    """
    cmd = [path, "bucket", "list"]
    ret = __salt__["cmd.run"](cmd, python_shell=False).splitlines()
    return ret


def bucket_known(path="scoop.cmd"):
    """
    Available buckets

    Args

        None

    Returns

        List:
            List of the available buckets
    """
    cmd = [path, "bucket", "known"]
    ret = __salt__["cmd.run"](cmd, python_shell=False).splitlines()
    return ret


def bucket_add(bucket, path="scoop.cmd"):
    """
    Add a bucket

    Args

        bucket (string):
            name of the bucket to add

    Returns

        dict:
            int:
                retcode

            str:
                stderr

            str:
                stdout
    """
    cmd = [path, "bucket", "add"]
    cmd.append(bucket)
    ret = __salt__["cmd.run_all"](cmd, python_shell=False)
    return ret


def bucket_rm(bucket, path="scoop.cmd"):
    """
    Remove an installed bucket

    Args

        bucket (string):
            name of the bucket to remove

    Returns

        dict:
            int:
                retcode

            str:
                stderr

            str:
                stdout
    """
    cmd = [path, "bucket", "rm"]
    cmd.append(bucket)
    ret = __salt__["cmd.run_all"](cmd, python_shell=False)
    return ret


def cache_clean(pkg="*", path="scoop.cmd"):
    """
    Clean cache

    Args

        pkg (string):
            name of the application to clean cache (default is '*' that means all applications)

    Returns

        dict:
            int:
                retcode

            str:
                stderr

            str:
                stdout
    """
    cmd = [path, "cache", "rm"]
    cmd.append(pkg)
    ret = __salt__["cmd.run_all"](cmd, python_shell=False)
    return ret
