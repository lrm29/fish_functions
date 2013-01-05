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
removeFromPath PATH $WM_THIRD_PARTY_DIR/platforms/$WM_ARCH$WM_COMPILER/cmake-*
removeFromPath PATH $WM_THIRD_PARTY_DIR/platforms/$WM_ARCH$WM_COMPILER/paraview-*

# determine the cmake to be used
set -e CMAKE_HOME
set -l cmakeVersions cmake-2.8.4 cmake-2.8.3 cmake-2.8.1

for cmakeVersion in $cmakeVersions
    set -l cmake $WM_THIRD_PARTY_DIR/platforms/$WM_ARCH$WM_COMPILER/$cmakeVersion

    if test -r $cmake
        set -x CMAKE_HOME $cmake
        prependPath PATH $CMAKE_HOME/bin
        break
    end
end


#- ParaView version, automatically determine major version
set -x ParaView_VERSION 3.10.1
set -x ParaView_MAJOR detect


# Evaluate command-line parameters for ParaView
for i in $argv
    switch $i
        case 'ParaView*=*'
            eval (echo $i | sed 's/\(.*\)=\(.*\)/set -gx \1 \2/g')
    end
end

switch "$ParaView_VERSION"
    case (echo $ParaView_VERSION | grep -e "[0-9]*")
        set -x ParaView_MAJOR (echo $ParaView_VERSION | sed -e 's/^\([0-9][0-9]*\.[0-9][0-9]*\).*$/\1/')
end

set -l paraviewInstDir $WM_THIRD_PARTY_DIR/ParaView-$ParaView_VERSION
set -x ParaView_DIR $WM_THIRD_PARTY_DIR/platforms/$WM_ARCH$WM_COMPILER/paraview-$ParaView_VERSION

if test -r $ParaView_DIR; or test -r $paraviewInstDir
    prependPath PATH $ParaView_DIR/bin
    prependPath LD_LIBRARY_PATH $ParaView_DIR/lib/paraview-$ParaView_MAJOR $LD_LIBRARY_PATH
    set -x PV_PLUGIN_PATH $FOAM_LIBBIN/paraview-$ParaView_MAJOR

    # add in python libraries if required
    set -l paraviewPython $ParaView_DIR/Utilities/VTKPythonWrapping

    if test -r $paraviewPython
        appendPath PYTHONPATH $paraviewPython $ParaView_DIR/lib/paraview-$ParaView_MAJOR
    end
else
    set -e PV_PLUGIN_PATH
end


# -----------------------------------------------------------------------------
