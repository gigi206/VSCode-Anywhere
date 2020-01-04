.. _module_git:

===
Git
===

.. image:: https://upload.wikimedia.org/wikipedia/commons/e/e0/Git-logo.svg
    :alt: Git
    :height: 250px

About
#####

`Git <https://git-scm.com>`_ is a distributed version-control system for tracking changes in source code
during software development. It is designed for coordinating work among
programmers, but it can be used to track changes in any set of files.

Not that there is already `native component to manage git <https://code.visualstudio.com/docs/editor/versioncontrol>`_
within VSCode. This module extends the capabilities of git by adding some
features.

.. note::

    Git is already installed during the VSCode-Anywhere installation process.
    This module allow you to install additional VSCode extensions.

Prerequisites
#############

No prerequisites required.

VSCode extensions
#################

Hirse.vscode-ungit
******************

`Extension <https://marketplace.visualstudio.com/items?itemName=Hirse.vscode-ungit>`_
to show `ungit <https://github.com/FredrikNoren/ungit>`_ in Visual Studio Code.


.. image:: https://raw.githubusercontent.com/Hirse/vscode-ungit/master/screenshots/ungit.png
    :alt: ungit

.. donjayamanne.githistory
.. ***********************

.. `This extension <https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory>`_
.. allows you to:

.. - View and search git log along with the graph and details.
.. - View a previous copy of the file.
.. - View and search the history
..  - View the history of one or all branches (git log)
..   - View the history of a file
..   - View the history of a line in a file (Git Blame).
..   - View the history of an author
.. - Compare:
..   - Compare branches
..   - Compare commits
..   - Compare files across commits
.. - Miscellaneous features:
..   - Github avatars
..   - Cherry-picking commits
..   - Reverting commits
..   - Create branches from a commits
..   - View commit information in a treeview (snapshot of all changes)
..   - Merge and rebase

.. .. image:: https://raw.githubusercontent.com/DonJayamanne/gitHistoryVSCode/master/images/gitLogv2.gif
    :alt: git log

mhutchie.git-graph
******************

`This extension <https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph>`_
allows you to view a Git Graph of your repository, and easily perform Git
actions from the graph.

.. image:: https://github.com/mhutchie/vscode-git-graph/raw/master/resources/demo.gif
    :alt: git graph

eamodio.gitlens
***************

`GitLens <https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens>`_
supercharges the Git capabilities built into Visual Studio Code.
It helps you to visualize code authorship at a glance via Git blame annotations
and code lens, seamlessly navigate and explore Git repositories, gain valuable
insights via powerful comparison commands, and so much more.

.. image:: https://raw.githubusercontent.com/eamodio/vscode-gitlens/master/images/docs/gitlens-preview.gif
    :alt: Gitens

VSCode settings
###############

No settings.

Software
########

No software required

Docsets
#######

No docsets.

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    git:
        enabled: True

Environment
***********

No environment.

Specific module settings
************************

No Specific settings.
