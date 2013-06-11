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
#     etc/config/aliases.fish
#
# Description
#     Aliases for working with OpenFOAM
#     Sourced from OpenFOAM-<VERSION>/etc/fishrc and/or ~/.fishrc
#
#------------------------------------------------------------------------------

# Change compiled version aliases
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function wmSET -d "Source .fishrc file"
    . $WM_PROJECT_DIR/etc/fishrc $argv
end

function wm64; wmSET WM_ARCH_OPTION=64; end
function wm32; wmSET WM_ARCH_OPTION=32; end
function wmSP; wmSET WM_PRECISION_OPTION=SP; end
function wmDP; wmSET WM_PRECISION_OPTION=DP; end

# clear env
function wmUNSET -d "Clear OpenFOAM from environment"
    . $WM_PROJECT_DIR/etc/config/unset.fish
end

# Toggle wmakeScheduler on/off
#  - also need to set WM_HOSTS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function wmSchedON
    set -gx WM_SCHEDULER $WM_PROJECT_DIR/wmake/wmakeScheduler
end

function wmSchedOFF
    set -e WM_SCHEDULER
end

# Change ParaView version
# ~~~~~~~~~~~~~~~~~~~~~~~
function foamPV
    . $WM_PROJECT_DIR/etc/config/paraview.fish ParaView_VERSION=$argv[1]
    echo "paraview-$ParaView_VERSION  (major: $ParaView_MAJOR)"
end

# Change directory aliases
# ~~~~~~~~~~~~~~~~~~~~~~~~
function src; cd $FOAM_SRC; end;
function lib; cd $FOAM_LIBBIN; end;
function run; cd $FOAM_RUN; end;
function foam; cd $WM_PROJECT_DIR; end;
function foamsrc; cd $FOAM_SRC/$WM_PROJECT; end;
function foamfv; cd $FOAM_SRC/finiteVolume; end;
function app; cd $FOAM_APP; end;
function util; cd $FOAM_UTILITIES; end;
function sol; cd $FOAM_SOLVERS; end;
function tut; cd $FOAM_TUTORIALS; end;

function foamApps; cd $FOAM_APP; end;
function foamSol; cd $FOAM_SOLVERS; end;
function foamTuts; cd $FOAM_TUTORIALS; end;
function foamUtils; cd $FOAM_UTILITIES; end;
function thirdParty; cd $WM_THIRD_PARTY_DIR; end;

if set -q WM_PROJECT_SITE
    function foamSite; cd $WM_PROJECT_SITE; end;
else
    function foamSite; cd $WM_PROJECT_INST_DIR/site; end;
end

function buildCvMesh; eval $FOAM_APP/utilities/mesh/generation/Allwmake; end;

# -----------------------------------------------------------------------------
