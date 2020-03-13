"""
Support for Zeal (https://zealdocs.org)
"""

import salt.utils.path
import salt.utils.platform
import salt.utils.files
import salt.utils.json
import salt.utils.http
import salt.exceptions
import os
import base64
import pathlib


def __virtual__():
    """
    Only load if Zeal is installed on the system
    """
    if not (salt.utils.platform.is_linux() or salt.utils.platform.is_windows()):
        return (False, "{} platform is not supported".format(__grains__["kernel"]))
    else:
        return True

    # if salt.utils.platform.is_linux():
    #     if salt.utils.path.which(bin) is None:
    #         return (False, "Zeal is not installed.")
    #     else:
    #         return True
    # elif salt.utils.platform.is_windows():
    #     if __salt__["file.access"](_bin(), mode="f"):
    #         return True
    #     else:
    #         return (False, "Zeal is not installed.")
    # else:
    #     return (False, "{} platform is not supported".format(__grains__["kernel"]))


# def _bin():
#     """
#     Returns the Zeal binary path

#     Returns

#         str:
#             path
#     """
#     if salt.utils.platform.is_linux():
#         return salt.utils.path.which(bin)
#     elif salt.utils.platform.is_windows():
#         path = __salt__["reg.read_value"](
#             "HKEY_CURRENT_USER", key="SOFTWARE\\Classes\\dash\\shell\\open\\command"
#         )["vdata"]
#         if path is None:
#             # Portable installation
#             pass
#         else:
#             return path[:-2]


def _get_docsets_path():
    """
    docsets directory path

    Returns

        str:
            path
    """
    if salt.utils.platform.is_windows():
        return os.path.join(
            __salt__["grains.get"]("vscode-anywhere:apps:path"),
            "scoop",
            "persist",
            "zeal",
            "docsets",
        )
    else:
        return os.path.join(
            __salt__["grains.get"]("vscode-anywhere:apps:path"),
            "vscode-anywhere",
            "home",
            ".local",
            "share",
            "Zeal",
            "Zeal",
            "docsets",
        )

        # Note: reg module return path line Unix path with slash (not backslash)
        # path = __salt__["reg.read_value"](
        #     "HKEY_CURRENT_USER", key="Software\\Zeal\\Zeal\\docsets", vname="path"
        # )["vdata"]
        # if path is None:
        #     # Portable installation
        #     pass
        # else:
        #     return path.replace("/", os.path.sep)


def _http_query(url, decode_type="auto", decode=True):
    """
    Wrapper for the http.query Salt lib
    Returns the "dict" object
    """
    req = salt.utils.http.query(url, decode_type=decode_type, decode=decode)
    if req.get("status", 200) == 200:
        return req.get("dict")
    else:
        raise salt.exceptions.CommandExecutionError(
            "failed to fetch url {} => {} ({})".format(
                url, req.get("error", ""), req.get("status")
            )
        )


def _docsets():
    """
    Official docsets

    Returns

        list:
            list of official docsets
    """
    return _http_query("https://api.zealdocs.org/v1/docsets", decode_type="json")


def _docsets_contrib():
    """
    User contribution docsets

    Returns:
        dict:
            dict of docsets
    """
    return _http_query(
        "https://kapeli.com/feeds/zzz/user_contributed/build/index.json",
        decode_type="json",
    )


def _docset(docset):
    """
    Search a docset in the official docsets and returns a dict for the specified docset

    Args

        docset (str):
            name of the docset to search

    Returns

        dict:
            return informations about a docset if present in the official docsets else None
    """
    return _http_query(
        "https://raw.githubusercontent.com/Kapeli/feeds/master/{}.xml".format(docset),
        decode_type="xml",
    )


def _docset_contrib(docset):
    # https://zealusercontributions.herokuapp.com
    """
    Search a docset in the user contribution docsets and returns a dict for the specified docset

    Args

        docset (str):
            name of the docset to search

    Returns

        dict:
            return informations about a docset if present in the docsets user contribution else None
    """
    return _http_query(
        # "https://zealusercontributions.herokuapp.com/docsets/{}.xml".format(docset),
        "https://zealusercontributions.herokuapp.com/api/docsets/{}".format(docset),
        decode_type="xml",
    )


def _docset_url(docset):
    """
    Return an url for the docset tarball

    Args

        docset (str):
            name of the docset to search

    Returns

        str:
            url if exists else None
    """
    try:
        get_docset = _docset(docset)
    except Exception:
        get_docset = None
    urls = (
        [_docset.get("url") for _docset in get_docset if "url" in _docset.keys()]
        if get_docset
        else None
    )
    if urls:
        if urls[0] is None:
            return None
        else:
            return urls[0]
    else:
        get_docset_contrib = _docset_contrib(docset)
        urls_contrib = (
            [
                _docset.get("url")
                for _docset in get_docset_contrib
                if "url" in _docset.keys()
            ]
            if get_docset_contrib
            else None
        )
        if urls_contrib is None or urls_contrib[0].endswith("undefined"):
            return None
        else:
            return urls_contrib[0]


def _docset_remote_info(docset):
    """
    Returns some informations about a docset

    Args

        docset(str):
            name of the docset to search

    Returns

        dict:
            Retruns a dict if found else None
    """
    search = [_docset for _docset in _docsets() if _docset.get("name") == docset]
    if search:
        return search[0]
    else:
        return _docsets_contrib().get("docsets", {}).get(docset, {})


def docset_last_version(docset):
    """
    Search the last version for a docset

    Args

        docset(str):
            name of the docset to search

    Returns

        tuple:
            tuple of string (version, revision)
    """
    docset_info = _docset_remote_info(docset)
    version = dict(enumerate(docset_info.get("versions", []))).get(0)
    if version is None:
        version = docset_info.get("version")
    revision = docset_info.get("revision")
    return (version, revision)


def docset_current_version(docset):
    """
    Get the current version for an installed docset

    Args

        docset (str):
            name of the docset to search

    Returns

        tuple:
            tuple of string (version, revision)
    """
    meta_path = os.path.join(
        _get_docsets_path(), "{}.docset".format(docset), "meta.json"
    )

    if not os.path.isfile(meta_path):
        return (None, None)

    with salt.utils.files.fopen(meta_path) as _f:
        json = salt.utils.json.load(_f)

    return (json.get("version"), json.get("revision"))


def _docset_path(docset):
    """
    Returns the path where the specified docset must be installed

    Args

        docset (str):
            name of the docset to search

    Returns

        str:
            docset path
    """
    return os.path.join(_get_docsets_path(), docset + ".docset")


def is_docset_installed(docset):
    """
    Check if the specified docset is installed

    Args

        docset (str):
            name of the docset to check

    Returns

        bool:
            True if installed else False

    CLI Example:

    .. code-block:: bash

        salt '*' zeal.is_docset_installed <docset name>
    """
    return os.path.isdir(_docset_path(docset))


def is_docset_updated(docset):
    """
    Check if the specified docset is up to date

    Args

        docset (str):
            name of the docset to check

    Returns

        bool:
            True if up to date else False

    CLI Example:

    .. code-block:: bash

        salt '*' zeal.is_docset_updated <docset name>
    """
    if is_docset_installed(docset):
        return docset_current_version(docset) == docset_last_version(docset)
    else:
        return False


def docsets_list():
    """
    List of the installed docsets

      Returns

        list:
            List of docsets

    CLI Example:

    .. code-block:: bash

        salt '*' zeal.docset_list <docset name>
    """
    return [
        docset.replace(".docset", "")
        for docset in os.listdir(_get_docsets_path())
        if os.path.isdir(os.path.join(_get_docsets_path(), docset))
        and docset.endswith(".docset")
    ]


def docset_delete(docset):
    """
    Delete the specified docset

    Args

        docset (str):
            name of the docset to delete

    Returns

        bool:
            True

    CLI Example:

    .. code-block:: bash

        salt '*' zeal.docset_delete <docset name>
    """

    if is_docset_installed(docset):
        salt.utils.files.rm_rf(_docset_path(docset))
    return True


def docset_install(docset):
    """
    Install the specified docset

    Args

        docset (str):
            name of the docset to install

    Returns

        bool:
            True

    CLI Example:

    .. code-block:: bash

        salt '*' zeal.docset_install <docset name>
    """
    if is_docset_installed(docset):
        docset_delete(docset)

    src = _docset_url(docset)

    if src is None:
        raise salt.exceptions.CommandExecutionError(
            "Docset {} does not exist".format(docset)
        )

    tmp_dir = os.path.join(_get_docsets_path(), "_tmp")

    if os.path.exists(tmp_dir):
        salt.utils.files.rm_rf(tmp_dir)
    # os.mkdir(tmp_dir)
    pathlib.Path(tmp_dir).mkdir(parents=True, exist_ok=True)
    __salt__["archive.extract"](src, tmp_dir)
    tmp_docset = dict(
        enumerate(
            [docset for docset in os.listdir(tmp_dir) if docset.endswith("docset")]
        )
    ).get(0)

    if tmp_docset is None:
        raise salt.exceptions.CommandExecutionError(
            "Docset {} is not valid".format(docset)
        )

    salt.utils.files.rename(
        os.path.join(tmp_dir, tmp_docset),
        os.path.join(_get_docsets_path(), "{}.docset".format(docset)),
    )
    salt.utils.files.rm_rf(tmp_dir)

    docset_info = _docset_remote_info(docset)
    icon = docset_info.get("icon")
    icon2x = docset_info.get("icon2x", docset_info.get("icon@2x"))

    if icon is not None:
        b64_icon = base64.b64decode(icon)
        with salt.utils.files.fopen(
            os.path.join(_get_docsets_path(), "{}.docset".format(docset), "icon.png"),
            "bw",
        ) as _f:
            _f.write(b64_icon)

    if icon2x is not None:
        b64_icon2x = base64.b64decode(icon2x)
        with salt.utils.files.fopen(
            os.path.join(
                _get_docsets_path(), "{}.docset".format(docset), "icon@2x.png"
            ),
            "bw",
        ) as _f:
            _f.write(b64_icon2x)

    meta = {}
    version, revision = docset_last_version(docset)

    if version:
        meta["version"] = version
    if revision:
        meta["revision"] = revision
    if docset_info.get("name"):
        meta["name"] = docset_info["name"]
    if docset_info.get("title"):
        meta["title"] = docset_info["title"]
    if docset_info.get("extra"):
        meta["extra"] = docset_info["extra"]

    dump = salt.utils.json.dumps(meta, indent=4, sort_keys=True)
    with salt.utils.files.fopen(
        os.path.join(_get_docsets_path(), "{}.docset".format(docset), "meta.json"), "w"
    ) as _f:
        _f.write(dump)

    return True
