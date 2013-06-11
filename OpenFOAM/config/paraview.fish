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
#     config/paraview.fish
#
# Description
#     Setup file for paraview-3.x
#     Sourced from OpenFOAM-<VERSION>/etc/fishrc or from foamPV alias
#
# Note
#     The env. variables 'ParaView_DIR' and 'ParaView_MAJOR'
#     are required for building plugins
#------------------------------------------------------------------------------

# clean the PATH
foamClean PATH $WM_THIRD_PARTY_DIR/platforms/$WM_ARCH$WM_COMPILER/cmake-*
foamClean PATH $WM_THIRD_PARTY_DIR/platforms/$WM_ARCH$WM_COMPILER/paraview-*

# determine the cmake to be used
set -e CMAKE_HOME
set -l cmakeVersions cmake-2.8.4 cmake-2.8.3 cmake-2.8.1


for cmakeVersion in $cmakeVersions
    set -l cmake $WM_THIRD_PARTY_DIR/platforms/$WM_ARCH$WM_COMPILER/$cmakeVersion

    if test -r $cmake
        set -gx CMAKE_HOME $cmake
        prependToVar PATH $CMAKE_HOME/bin
        break
    end
end


#- ParaView version, automatically determine major version
set -gx ParaView_VERSION 3.12.0
set -gx ParaView_MAJOR detect
# Evaluate command-line parameters for ParaView
for i in $argv
    switch $i
        case 'ParaView*=*'
            eval (echo $i | sed 's/\(.*\)=\(.*\)/set -gx \1 \2/g')
    end
end

switch "$ParaView_VERSION"
    case (echo $ParaView_VERSION | command grep -e "[0-9]*")
        set -gx ParaView_MAJOR (echo $ParaView_VERSION | sed -e 's/^\([0-9][0-9]*\.[0-9][0-9]*\).*$/\1/')
end

set -l paraviewInstDir $WM_THIRD_PARTY_DIR/ParaView-$ParaView_VERSION
set -gx ParaView_DIR $WM_THIRD_PARTY_DIR/platforms/$WM_ARCH$WM_COMPILER/ParaView-$ParaView_VERSION

if begin; test -r $ParaView_DIR; or test -r $paraviewInstDir; end

    foamPrintDebug "    ParaView_DIR         : $ParaView_DIR"
    foamPrintDebug "    ParaView_MAJOR         : $ParaView_MAJOR"
    foamPrintDebug "    ParaView_VERSION         : $ParaView_VERSION"

    set -gx ParaView_INCLUDE_DIR $ParaView_DIR/include/paraview-$ParaView_MAJOR
    if not test -d $ParaView_INCLUDE_DIR; and test -d $ParaView_DIR/include/paraview
        set -gx ParaView_INCLUDE_DIR $ParaView_DIR/include/paraview
    end

    set -l ParaView_LIB_DIR $ParaView_DIR/lib/paraview-$ParaView_MAJOR
    if not test -d $ParaView_LIB_DIR; and test -d $ParaView_DIR/include/paraview
        set ParaView_LIB_DIR $ParaView_DIR/lib/paraview
    end

    prependToVar PATH $ParaView_DIR/bin
    prependToVar LD_LIBRARY_PATH $ParaView_LIB_DIR
    set -gx PV_PLUGIN_PATH $FOAM_LIBBIN/paraview-$ParaView_MAJOR

    foamPrintDebug "Using paraview"
    foamPrintDebug "    ParaView_DIR         : $ParaView_DIR"
    foamPrintDebug "    ParaView_LIB_DIR     : $ParaView_LIB_DIR"
    foamPrintDebug "    ParaView_INCLUDE_DIR : $ParaView_INCLUDE_DIR"
    foamPrintDebug "    PV_PLUGIN_PATH       : $PV_PLUGIN_PATH"

    # add in python libraries if required
    set -l paraviewPython $ParaView_DIR/Utilities/VTKPythonWrapping

    if test -r "$paraviewPython"
        set -gx PYTHONPATH $PYTHONPATH $paraviewPython $ParaView_DIR/lib/paraview-$ParaView_MAJOR
    end
else
    set -e PV_PLUGIN_PATH
end

# -----------------------------------------------------------------------------
