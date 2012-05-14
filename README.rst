turtle-installer
================

This repo contains a Makefile and supporting code to create an Windows
installer for the different flavors of Turtle, e.g. Turtle-rural, Turtle-urban
or Turtle-flooding.

The Makefile

  - creates an export of a specified flavor and tagged version of Turtle,
  - bootstraps and creates the Turtle buildout environment, and
  - packages the retrieved dependent libraries in the Windows installer.

The Windows installer can than install the dependent libraries and recreate the
buildout environment without access to the internet.

Installation
------------

Installation of the tools is only a ``git clone`` command away::

  git clone git://github.com/lizardsystem/turtle-installer.git

Usage
-----

The actual Makefile you use to create the installer is stored in the wininst
subdirectory, so::

  cd turtle-installer/wininst

To create an installer, you have to specify the flavor of Turtle you want, for
example 'rural' or 'urban' (loose the quotes), and the tag version, for example
0.2 or 3.1::

  make TURTLE_EDITION=rural TAGGED_VERSION=3.1

This make command creates a Windows installer for an export of the specified
version of the Turtle edition. This export is placed in a subdirectory of the
TEMP directory that is named::

  Turtle-$(TURTLE_EDITION)-export

with TURTLE_EDITION the user-supplied flavor of Turtle. When the installer is
build successfully, the Windows installer setup can be found in::

  Turtle-$(TURTLE_EDITION)-export\wininst

named::

  Turtle-$(TURTLE_EDITION)-setup-python2.6.exe

By default, the Makefile creates an installer for Python version 2.6. You can
supply the option ``py25`` to the Makefile to specify that the installer should
be build for Python version 2.5. One can also supply the option ``py24`` but it
is not officially supported. Chances are some of the libraries Turtle depends
on need a more recent Python version.

Prerequisites
-------------

The Windows installer is build using `NSIS <http://nsis.sourceforge.net/Main_Page>`_,
an open source system to create Windows installers. NSIS itself is a Windows
application so this means that the process of creating an installer takes place
under Windows. Currently, we use a Windows 7 VMWare virtual machine to build
the installers.

The Makefile assumes NSIS is installed in::

  C:\Program Files\NSIS

That is, the Makefile looks in that directory for the ``makensis``
executable. That location can easily be modified as it is stored in a variable
of the Makefile.

The Makefile uses Python to bootstrap and create the Turtle buildout
environment. It assumes that Python 2.x is located at ``C:\Python2x``, with x
the minor Python version number. This location can easily be modified as it is
stored in a variable of the Makefile. If you do not need to create an installer
for a specific Python version, that Python version need not be present.

The Makefile itself follows the GNU make format and uses several GNU utilities,
viz. sed and rm. The `Cygwin <http://www.cygwin.com/>`_ environment provides us
with GNU make and these utilities.

Finally, at the moment of writing the Turtle source code is stored in a
Subversion repository. Again the Cygwin environment provides us with the
command-line version of the svn utilities.

The repo that contains this document is a Git repo, officially stored at
https://github.com/lizardsystem/turtle-installer. We use the Git command-line
utilities from `msysgit <https://code.google.com/p/msysgit/>`_.
