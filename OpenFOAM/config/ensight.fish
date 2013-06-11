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
#     config/ensight.fish
#
# Description
#     Setup file for Ensight
#     Sourced from OpenFOAM-*/etc/fishrc
#
#------------------------------------------------------------------------------

# fallback value
if not set -q CEI_HOME
    set -gx CEI_HOME /usr/local/ensight/CEI
end

if test -r $CEI_HOME
then
    # special treatment for 32bit OpenFOAM and 64bit Ensight
    test "$WM_ARCH" = linux;
        and test (uname -m) = x86_64;
        and set -gx CEI_ARCH linux_2.6_32

    test "$CEI_HOME/bin/ensight" != "(which ensight)";
        and prependToVar PATH $CEI_HOME/bin

    set -gx ENSIGHT9_INPUT dummy
    set -gx ENSIGHT9_READER $FOAM_LIBBIN
else
    set -e CEI_HOME
end


# -----------------------------------------------------------------------------
