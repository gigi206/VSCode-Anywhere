.. _faq:

===
FAQ
===

Installation failed
###################

VSCode-Anywhere does not support spaces in the install directory path.

Some states failing
###################

Simply run again the install or update script. VSCode-Anywhere will compute
what is missing on your system.

.. note::

    If the problem persists, you can open an issue.

VSCode-Anywhere is very slow when installing, locks up the CPU, or shows access denied errors
#############################################################################################

It's likely that your antivirus or anti-malware program is doing a realtime
scan as files are being extracted.

Please see Antivirus and Anti-Malware problems for more information and possible workarounds.

.. note::

    It is advised to put the installation directory in the white list of your
    antivirus or anti-malware program.

Language is only detected at the 2nd run
########################################

VSCode-Anywhere detect the OS locale and set it automatically inside VSCode.

There is a bug inside VSCode and the language is only detected in the **2nd**
run.

.. note::

    VSCode-Anywhere auto-detects and configure for you the following languages:
    ``en``, ``fr``, ``es``, ``de``, ``it``, ``ja``, ``ru``, ``hu``, ``ko``,
    ``bg``, ``tr``, ``pt_br``, ``zh_cn`` and ``zh_tw``.
