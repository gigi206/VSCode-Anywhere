#!C:\salt\bin\python.exe
from datetime import datetime
scriptStartTime = datetime.now()
from pprint import pprint  # noqa: E401,E402
from time import gmtime, strftime  # noqa: E402
import salt.client  # noqa: E402
import salt.config  # noqa: E402
import salt.loader  # noqa: E402


# FIXME: colors in powershell terminal
class colors:
    success = "\033[32m"
    changes = "\033[32m"
    fail = "\033[91m"
    bold = "\033[1m"
    reset = "\033[0m"


def message(message, type=None):
    if type == "success":
        print(message)
    elif type == "failed":
        print(message)
    elif type == "changes":
        print(message)
    elif type == "error":
        print(message)
    else:
        print(message)


def result(ret, sls=None, action=None):
    if isinstance(ret, dict):
        jobs = list(ret.values())
    else:
        jobs = [
            {
                "__id__": "unknown",
                "__sls__": "{}.{}".format(sls, action),
                "__run_num__": 0,
                "result": False,
                "changes": {},
                "duration": 0,
                "start_time": datetime.now().strftime("%H:%M:%S.%f"),
                "comment": "the module {}.{} does not exist !".format(sls, action),
            }
        ]

        if __salt__["state.sls_exists"](
            ("salt/{}.{}".format(sls, action)), sls, action
        ):  # FIXME: salt/ to remove
            jobs[0]["comment"] = "something wrong in the module {}.{} !".format(
                sls, action
            )

    for job in jobs:
        if job["result"] is True:
            jobsResult["success"] += 1
        else:
            jobsResult["failed"] += 1

        if len(job["changes"]) > 0:
            jobsResult["changes"] += 1

        jobsResult["duration"] += job["duration"]

        yield job


def manage(sls, action="install"):
    if action not in actions:
        message("{} is not a valid action !".format(action), type="error")
        return

    message("{} {}".format(action, sls), type="header")

    # FIXME: find a way to remove salt/ => C:\\salt\\conf\\minion.d\\VSCode-Anywhere.conf (could be solved with the git mountpoint ???)
    # FIXME: uninstall doesn't work as expected
    jobsStartTime = datetime.now()
    jobs = result(
        __salt__["state.apply"]("salt/{}.{}".format(sls, action)), sls, action
    )
    jobsResult["statesDuration"] += (datetime.now() - jobsStartTime).total_seconds()

    for job in jobs:
        # pprint(job)
        name = "{} ({})".format(job["__id__"], job["__sls__"])
        duration = strftime("%H:%M:%S", gmtime(job["duration"] / 1000))

        if job["result"]:
            if job["changes"]:
                status = "changes"
                comment = "[OK] {} => successful {}ed".format(
                    name, "updat" if action == "update" else action
                )
            else:
                status = "success"
                comment = "[SKIP] {} => already {}ed".format(
                    name, "updat" if action == "update" else action
                )
        else:
            status = "failed"
            comment = "[KO] {} => failed to {}".format(name, action)

        if job["comment"]:
            if len(job["comment"].splitlines()) > 1:
                comment += " ({})\n\t{}".format(
                    duration, "\n\t".join(job["comment"].splitlines())
                )
            else:
                comment += ". {} ({})".format(job["comment"], duration)
        else:
            comment += " ({})".format(duration)

        message(comment, type=status)
        # return jobs


def stat():
    scriptEndTime = datetime.now()
    elapseTime = (scriptEndTime - scriptStartTime).total_seconds()
    loadingTimeGrains = (grainsLoadingEndTime - grainsLoadingStartTime).total_seconds()
    slsTime = jobsResult["duration"] / 1000
    jinjaTime = jobsResult["statesDuration"] - slsTime
    syncTime = (syncLoadingEndTime - syncLoadingStartTime).total_seconds()
    scriptTime = elapseTime - loadingTimeGrains - syncTime - jobsResult["statesDuration"]
    totalJobs = jobsResult["success"] + jobsResult["failed"]
    message(
        "\n{} states = {} success ({} changes) + {} failed".format(
            totalJobs,
            jobsResult["success"],
            jobsResult["changes"],
            jobsResult["failed"],
        )
    )

    message("\nElapse: {:.2f}s =>".format(elapseTime))
    message("  * VSCode-Anywhere script: {:.2f}s".format(scriptTime))
    message("  * Loading grains: {:.2f}s".format(loadingTimeGrains))
    message("  * Sync all: {:.2f}s".format(syncTime))
    message("  * Apply states: {:.2f}s =>".format(jobsResult["statesDuration"]))
    message("    * Jinja: {:.2f}s".format(jinjaTime))
    message("    * SLS: {:.2f}s".format(slsTime))


actions = ["install", "update", "uninstall"]


jobsResult = {
    "success": 0,
    "changes": 0,
    "failed": 0,
    "statesDuration": 0,
    "duration": 0,
}

# saltPath = 'C:\\salt'
# saltConfigPath = os.path.join(saltPath, 'conf', 'minion.d', 'VSCode-anywhere.conf')

saltConfig = "C:\\salt\\conf\\minion.d\\VSCode-Anywhere.conf"
__opts__ = salt.config.minion_config(saltConfig)
__opts__["file_client"] = "local"
message("Loading grains...")
grainsLoadingStartTime = datetime.now()
__grains__ = salt.loader.grains(__opts__)
grainsLoadingEndTime = datetime.now()
__opts__["grains"] = __grains__
__utils__ = salt.loader.utils(__opts__)
__salt__ = salt.loader.minion_mods(opts=__opts__, utils=__utils__)
# __state__ = salt.loader.states(opts=__opts__, utils=__utils__, functions=None, serializers=None)

caller = salt.client.Caller(mopts=__opts__)
# caller = salt.client.Caller(c_path='C:\\salt\\conf\\minion.d\\VSCode-Anywhere.conf')

# ret = list(caller.cmd(fun='state.apply', name='salt/zeal').values())


message("Sync all")
syncLoadingStartTime = datetime.now()
__salt__['saltutil.sync_all']()
syncLoadingEndTime = datetime.now()


# Zeal installation
manage("vscode", "install")
# manage("zeal", "install")
# manage('vscode', 'update')
# manage('vscode', 'uninstall')

stat()
