#---------------------------------*-fish-*-------------------------------------
# =========                 |
# \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
#  \\    /   O peration     |
#   \\  /    A nd           | Copyright (C) 2012 OpenFOAM Foundation
#    \\/     M anipulation  |
#------------------------------------------------------------------------------
# License
#     This file is part of OpenFOAM.
#
#     OpenFOAM is free software: you can redistribute it and/or modify it
#     under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     OpenFOAM is distributed in the hope that it will be useful, but WITHOUT
#     ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#     FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
#     for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with OpenFOAM.  If not, see <http://www.gnu.org/licenses/>.
#
# File
#     etc/config/unset.fish
#
# Description
#     Clear as many OpenFOAM environment settings as possible
#
#------------------------------------------------------------------------------

# The old dirs to be cleaned from the various environment variables
# - remove anything under top-level directory.
# NB: the WM_PROJECT_INST_DIR might not be identical between versions
#
set -l foamOldDirs $WM_PROJECT_INST_DIR $WM_PROJECT_SITE

test -n $WM_PROJECT;
    and set -l foamOldDirs $foamOldDirs $HOME/$WM_PROJECT/$USER_SITE

#------------------------------------------------------------------------------
# unset WM_* environment variables

set -e WM_ARCH
set -e WM_ARCH_OPTION
set -e WM_CC
set -e WM_CFLAGS
set -e WM_COMPILER
set -e WM_COMPILER_LIB_ARCH
set -e WM_COMPILE_OPTION
set -e WM_CXX
set -e WM_CXXFLAGS
set -e WM_DIR
set -e WM_HOSTS
set -e WM_LDFLAGS
set -e WM_LINK_LANGUAGE
set -e WM_MPLIB
set -e WM_NCOMPPROCS
set -e WM_OPTIONS
set -e WM_OSTYPE
set -e WM_PRECISION_OPTION
set -e WM_PROJECT
set -e WM_PROJECT_DIR
set -e WM_PROJECT_INST_DIR
set -e WM_PROJECT_SITE
set -e WM_PROJECT_USER_DIR
set -e WM_PROJECT_VERSION
set -e WM_SCHEDULER
set -e WM_THIRD_PARTY_DIR


#------------------------------------------------------------------------------
# unset FOAM_* environment variables

set -e FOAM_APPBIN
set -e FOAM_APP
set -e FOAM_EXT_LIBBIN
set -e FOAM_CODE_TEMPLATES
set -e FOAM_INST_DIR
set -e FOAM_JOB_DIR
set -e FOAM_LIBBIN
set -e FOAM_MPI
set -e FOAM_RUN
set -e FOAM_SETTINGS
set -e FOAM_SIGFPE
set -e FOAM_SIGNAN
set -e FOAM_SITE_APPBIN
set -e FOAM_SITE_LIBBIN
set -e FOAM_SOLVERS
set -e FOAM_SRC
set -e FOAM_TUTORIALS
set -e FOAM_USER_APPBIN
set -e FOAM_USER_LIBBIN
set -e FOAM_UTILITIES


#------------------------------------------------------------------------------
# unset MPI-related environment variables

set -e MPI_ARCH_PATH
set -e MPI_BUFFER_SIZE
set -e OPAL_PREFIX

#------------------------------------------------------------------------------
# unset Ensight/ParaView-related environment variables

set -e ENSIGHT9_READER
set -e CMAKE_HOME
set -e ParaView_DIR
set -e PV_PLUGIN_PATH


#------------------------------------------------------------------------------
# cleanup environment
# PATH, LD_LIBRARY_PATH, MANPATH

foamClean PATH $foamOldDirs
foamClean LD_LIBRARY_PATH $foamOldDirs
foamClean MANPATH $foamOldDirs

functions -e foamClean
functions -e foamDebug
functions -e foamSource
functions -e prependToVar
set -e cleaned
set -e foamOldDirs

#------------------------------------------------------------------------------
# cleanup aliases

functions -e wmSET
functions -e wm64
functions -e wm32
functions -e wmSP
functions -e wmDP

functions -e wmUNSET

functions -e wmSchedON
functions -e wmSchedOFF
functions -e foamPV

functions -e src
functions -e lib
functions -e run
functions -e foam
functions -e foamsrc
functions -e foamfv
functions -e app
functions -e util
functions -e sol
functions -e tut

functions -e foamApps
functions -e foamSol
functions -e foamTuts
functions -e foamUtils
functions -e foam3rdParty
functions -e foamSite


# ----------------------------------------------------------------- end-of-file
