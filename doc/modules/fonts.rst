.. _module_fonts:

=====
Fonts
=====

.. image:: https://github.com/tonsky/FiraCode/raw/master/showcases/all_ligatures.png
    :alt: fonts
.. :height: 250px

About
#####

`Fira Code <https://github.com/tonsky/FiraCode/>`_ is an extension of the Fira
Mono font containing a set of ligatures for common programming multi-character
combinations.

This module installs Fira Code fonts and uses them in VSCode with activated
ligatures.

.. image:: https://code.visualstudio.com/assets/docs/getstarted/tips-and-tricks/font-ligatures-annotated.png
    :alt: VSCode font ligatures

Prerequisites
#############

No prerequisites required.

VSCode extensions
#################

No extension required.

VSCode settings
###############

VSCode settings configuration for ``fonts``.

Global settings
***************

.. code-block:: json

    {
        "editor.fontLigatures": true,
        "editor.fontFamily": "Fira Code"
    }

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

    fonts:
        enabled: True

Environment
***********

No environment.

Specific module settings
************************

fonts
=====

``fonts`` is an array of fonts to install, by default it install Fira Code
fonts.

If you want to change the default fonts, change this array and replace the
``editor.fontFamily`` settings with the downloaded font.

.. code-block:: yaml

    fonts:
        enabled: True
        fonts:
            - https://github.com/tonsky/FiraCode/raw/master/distr/ttf/FiraCode-Bold.ttf
            - https://github.com/tonsky/FiraCode/raw/master/distr/ttf/FiraCode-Light.ttf
            - https://github.com/tonsky/FiraCode/raw/master/distr/ttf/FiraCode-Medium.ttf
            - https://github.com/tonsky/FiraCode/raw/master/distr/ttf/FiraCode-Regular.ttf
            - https://github.com/tonsky/FiraCode/raw/master/distr/ttf/FiraCode-Retina.ttf
