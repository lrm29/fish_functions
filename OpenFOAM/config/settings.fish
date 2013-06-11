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
#     etc/config/settings.fish
#
# Description
#     Startup file for OpenFOAM
#     Sourced from OpenFOAM-<VERSION>/etc/fishrc
#
#------------------------------------------------------------------------------

function prependToVar
    for i in $argv[(seq 2 (count $argv))]
        set -gx $argv[1] $i $$argv[1]
    end
end

# Set environment variables according to system type
set -x WM_ARCH (uname -s)

switch "$WM_ARCH"
    case Linux
        set -g WM_ARCH linux

        # compiler specifics
        switch (uname -m)
            case i686
            case x86_64
                switch "$WM_ARCH_OPTION"
                    case 32
                        set -x WM_COMPILER_ARCH 64
                        set -x WM_CC gcc
                        set -x WM_CXX g++
                        set -x WM_CFLAGS -m32 -fPIC
                        set -x WM_CXXFLAGS -m32 -fPIC
                        set -x WM_LDFLAGS -m32
                    case 64
                        set -x WM_ARCH linux64
                        set -x WM_COMPILER_LIB_ARCH 64
                        set -x WM_CC gcc
                        set -x WM_CXX g++
                        set -x WM_CFLAGS -m64 -fPIC
                        set -x WM_CXXFLAGS -m64 -fPIC
                        set -x WM_LDFLAGS -m64
                    case '*'
                        echo "Unknown WM_ARCH_OPTION $WM_ARCH_OPTION, should be 32 or 64"
                end
            case ia64
                set -x WM_ARCH linuxIA64
                set -x WM_COMPILER I64
            case mips64
                set -x WM_ARCH SiCortex64
                set -x WM_MPLIB MPI
                set -x WM_COMPILER_LIB_ARCH 64
                set -x WM_CC gcc
                set -x WM_CXX g++
                set -x WM_CFLAGS -mabi=64 -fPIC
                set -x WM_CXXFLAGS -mabi=64 -fPIC
                set -x WM_LDFLAGS -mabi=64 -G0
            case ppc64
                set -x WM_ARCH linuxPPC64
                set -x WM_COMPILER_LIB_ARCH 64
                set -x WM_CC gcc
                set -x WM_CXX g++
                set -x WM_CFLAGS -m64 -fPIC
                set -x WM_CXXFLAGS -m64 -fPIC
                set -x WM_LDFLAGS -m64
            case '*'
                echo Unknown processor type (uname -m) for Linux
        end
    case SunOS
        set -x WM_ARCH SunOS64
        set -x WM_MPLIB FJMPI
        set -x WM_COMPILER_LIB_ARCH 64
        set -x WM_CC gcc
        set -x WM_CXX g++
        set -x WM_CFLAGS -mabi=64 -fPIC
        set -x WM_CXXFLAGS -mabi=64 -fPIC
        set -x WM_LDFLAGS -mabi=64 -G0
    case '*'
        # an unsupported operating system
        echo
        echo Your "$WM_ARCH" operating system is not supported by this release
        echo of OpenFOAM. For further assistance, please contact www.OpenFOAM.org
        echo
end

#------------------------------------------------------------------------------

# location of the jobControl directory
set -x FOAM_JOB_DIR $WM_PROJECT_INST_DIR/jobControl

# wmake configuration
set -x WM_DIR $WM_PROJECT_DIR/wmake
set -x WM_LINK_LANGUAGE c++
set -x WM_OPTIONS $WM_ARCH$WM_COMPILER$WM_PRECISION_OPTION$WM_COMPILE_OPTION

# base executables/libraries
set -x FOAM_APPBIN $WM_PROJECT_DIR/platforms/$WM_OPTIONS/bin
set -x FOAM_LIBBIN $WM_PROJECT_DIR/platforms/$WM_OPTIONS/lib

# external (ThirdParty) libraries
set -x FOAM_EXT_LIBBIN $WM_THIRD_PARTY_DIR/platforms/$WM_OPTIONS/lib

# shared site executables/libraries
# similar naming convention as ~OpenFOAM expansion
if test -n "$WM_PROJECT_SITE"
    set -x FOAM_SITE_APPBIN $WM_PROJECT_SITE/$WM_PROJECT_VERSION/platforms/$WM_OPTIONS/bin
    set -x FOAM_SITE_LIBBIN $WM_PROJECT_SITE/$WM_PROJECT_VERSION/platforms/$WM_OPTIONS/lib
else
    set -x FOAM_SITE_APPBIN $WM_PROJECT_INST_DIR/site/$WM_PROJECT_VERSION/platforms/$WM_OPTIONS/bin
    set -x FOAM_SITE_LIBBIN $WM_PROJECT_INST_DIR/site/$WM_PROJECT_VERSION/platforms/$WM_OPTIONS/lib
end

# user executables/libraries
set -x FOAM_USER_APPBIN $WM_PROJECT_USER_DIR/platforms/$WM_OPTIONS/bin
set -x FOAM_USER_LIBBIN $WM_PROJECT_USER_DIR/platforms/$WM_OPTIONS/lib

# dynamicCode templates
# - default location is the "~OpenFOAM/codeTemplates/dynamicCode" expansion
# set -x FOAM_CODE_TEMPLATES $WM_PROJECT_DIR/etc/codeTemplates/dynamicCode

# convenience
set -x FOAM_APP $WM_PROJECT_DIR/applications
set -x FOAM_SRC $WM_PROJECT_DIR/src
set -x FOAM_TUTORIALS $WM_PROJECT_DIR/tutorials
set -x FOAM_UTILITIES $FOAM_APP/utilities
set -x FOAM_SOLVERS $FOAM_APP/solvers
set -x FOAM_RUN $WM_PROJECT_USER_DIR/run

# add wmake to the path - not required for runtime only environment
test -d "$WM_DIR";
    and prependToVar PATH $WM_DIR

# add OpenFOAM scripts to the path
prependToVar PATH $WM_PROJECT_DIR/bin

prependToVar PATH  $FOAM_APPBIN $FOAM_SITE_APPBIN $FOAM_USER_APPBIN

# Make sure to pick up dummy versions of external libraries last
prependToVar LD_LIBRARY_PATH $FOAM_LIBBIN/dummy $FOAM_EXT_LIBBIN $FOAM_LIBBIN $FOAM_SITE_LIBBIN $FOAM_USER_LIBBIN

# Compiler settings
# ~~~~~~~~~~~~~~~~~
set -e gcc_version
set -e gmp_version
set -e mpfr_version
set -e mpc_version
set -e MPFR_ARCH_PATH
set -e GMP_ARCH_PATH

# Location of compiler installation
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if test -z "$foamCompiler"
    set -g foamCompiler system
    echo "Warning in $WM_PROJECT_DIR/etc/config/settings.fish:" ^&1
    echo "    foamCompiler not set, using $foamCompiler" ^&1
end

switch $foamCompiler
    case OpenFOAM or ThirdParty
        switch "$WM_COMPILER"
            case Gcc or Gcc++0x
                set -g gcc_version gcc-4.7.2
                set -g gmp_version gmp-5.0.4
                set -g mpfr_version mpfr-3.1.0
                set -g mpc_version mpc-0.9
                set -g gmpPACKAGE gmp-5.0.4
            case Gcc46 or Gcc46++0x
                set -g gcc_version gcc-4.6.1
                set -g gmp_version gmp-5.0.2
                set -g mpfr_version mpfr-3.0.1
                set -g mpc_version mpc-0.9
                set -g gmpPACKAGE gmp-5.0.2
            case Gcc45 or Gcc45++0x
                set -g gcc_version gcc-4.5.2
                set -g gmp_version gmp-5.0.1
                set -g mpfr_version mpfr-2.4.2
                set -g mpc_version mpc-0.8.1
            case Gcc44 or Gcc44++0x
                set -g gcc_version gcc-4.4.3
                set -g gmp_version gmp-5.0.1
                set -g mpfr_version mpfr-2.4.2
            case Gcc43
                set -g gcc_version gcc-4.3.3
                set -g gmp_version gmp-4.2.4
                set -g mpfr_version mpfr-2.4.1
            case Clang
                # using clang - not gcc
                set -x WM_CC clang
                set -x WM_CXX clang++
                #clang_version=llvm-2.9
                set -g clang_version llvm-svn
            case '*'
                echo
                echo "Warning in $WM_PROJECT_DIR/etc/config/settings.fish:"
                echo "    Unknown OpenFOAM compiler type $WM_COMPILER"
                echo "    Please check your settings"
                echo
        end
        # optional configuration tweaks:
        foamSource config/compiler.fish

        if test -n "$gcc_version"
            set -g gccDir $WM_THIRD_PARTY_DIR/platforms/$WM_ARCH"$WM_COMPILER_ARCH"/$gcc_version
            set -g gmpDir $WM_THIRD_PARTY_DIR/platforms/$WM_ARCH"$WM_COMPILER_ARCH"/$gmp_version
            set -g mpfrDir $WM_THIRD_PARTY_DIR/platforms/$WM_ARCH"$WM_COMPILER_ARCH"/$mpfr_version
            set -g mpcDir $WM_THIRD_PARTY_DIR/platforms/$WM_ARCH"$WM_COMPILER_ARCH"/$mpc_version

            # Check that the compiler directory can be found
            if not test -d "$gccDir"
                echo
                echo "Warning in $WM_PROJECT_DIR/etc/config/settings.fish:"
                echo "    Cannot find $gccDir installation."
                echo "    Please install this compiler version or if you wish to use the system compiler,"
                echo "    change the 'foamCompiler' setting to 'system'"
                echo
            end

            prependToVar MANPATH $gccDir/man
            prependToVar PATH $gccDir/bin

            # add compiler libraries to run-time environment
            # 64-bit needs lib64, but 32-bit needs lib (not lib32)
            test "$WM_ARCH_OPTION" = 64;
                and prependToVar LD_LIBRARY_PATH $gccDir/lib$WM_COMPILER_LIB_ARCH;
                or  prependToVar LD_LIBRARY_PATH $gccDir/lib

            # add gmp/mpfr libraries to run-time environment
            prependToVar LD_LIBRARY_PATH $gmpDir/lib
            prependToVar LD_LIBRARY_PATH $mpfrDir/lib

            # add mpc libraries (not need for older gcc) to run-time environment
            test -n "$mpc_version";
                and prependToVar LD_LIBRARY_PATH $mpcDir/lib

            # used by boost/CGAL:
            set -x MPFR_ARCH_PATH $mpfrDir
            set -x GMP_ARCH_PATH $gmpDir
        end

        set -e gcc_version
        set -e gccDir
        set -e gmp_version
        set -e gmpDir
        set -e mpfr_version
        set -e mpfrDir
        set -e mpc_version
        set -e mpcDir

        if test -n "$clang_version"
            set -l clangDir $WM_THIRD_PARTY_DIR/platforms/$WM_ARCH"$WM_COMPILER_ARCH"/$clang_version

            # Check that the compiler directory can be found
            if not test -d "$clangDir"
                echo
                echo "Warning in $WM_PROJECT_DIR/etc/config/settings.fish:"
                echo "    Cannot find $clangDir installation."
                echo "    Please install this compiler version or if you wish to use the system compiler,"
                echo "    change the 'foamCompiler' setting to 'system'"
                echo
            end

            prependToVar MANPATH $clangDir/share/man
            prependToVar PATH $clangDir/bin
        end
        set -e clang_version
        set -e clangDir
    case system
        # okay, use system compiler
    case '*'
        echo "Warn: foamCompiler=$foamCompiler is unsupported" ^&1
        echo "   treating as 'system' instead" ^&1
end


#
# add c++0x flags for external programs
#
if test -n "$WM_CXXFLAGS"
    switch "$WM_COMPILER"
        case Gcc*++0x
            set -gx WM_CXXFLAGS $WM_CXXFLAGS -std=c++0x
    end
end


# boost and CGAL
# ~~~~~~~~~~~~~~

set -l boost_version boost_1_49_0
set -l cgal_version CGAL-4.0

set -x BOOST_ARCH_PATH $WM_THIRD_PARTY_DIR/platforms/$WM_ARCH$WM_COMPILER/$boost_version
set -x CGAL_ARCH_PATH $WM_THIRD_PARTY_DIR/platforms/$WM_ARCH$WM_COMPILER/$cgal_version

# enabled if CGAL is available
foamPrintDebug "Checking for"
foamPrintDebug "    $cgal_version at $CGAL_ARCH_PATH"
foamPrintDebug "    $boost_version at $BOOST_ARCH_PATH"

if test -d "$CGAL_ARCH_PATH"
    test -d "$BOOST_ARCH_PATH";
        and prependToVar LD_LIBRARY_PATH $BOOST_ARCH_PATH/lib;
        or  set -e BOOST_ARCH_PATH

    prependToVar LD_LIBRARY_PATH $CGAL_ARCH_PATH/lib
else
    set -e BOOST_ARCH_PATH
    set -e CGAL_ARCH_PATH
    set -e MPFR_ARCH_PATH
    set -e GMP_ARCH_PATH
end

set -e boost_version
set -e cgal_version


# Communications library
# ~~~~~~~~~~~~~~~~~~~~~~

set -e MPI_ARCH_PATH
set -e MPI_HOME
set -e FOAM_MPI_LIBBIN

switch "$WM_MPLIB"
    case OPENMPI
        set -x FOAM_MPI openmpi-1.6.3

        # optional configuration tweaks:
        foamSource config/openmpi.fish

        set -x MPI_ARCH_PATH $WM_THIRD_PARTY_DIR/platforms/$WM_ARCH$WM_COMPILER/$FOAM_MPI

        # Tell OpenMPI where to find its install directory
        set -x OPAL_PREFIX $MPI_ARCH_PATH

        prependToVar PATH $MPI_ARCH_PATH/bin
        prependToVar LD_LIBRARY_PATH $MPI_ARCH_PATH/lib
        prependToVar LD_LIBRARY_PATH $MPI_ARCH_PATH/lib$WM_COMPILER_LIB_ARCH
        prependToVar MANPATH $MPI_ARCH_PATH/man
    case SYSTEMOPENMPI
        # Use the system installed openmpi, get library directory via mpicc
        set -x FOAM_MPI openmpi-system

        # Set compilation flags here instead of in wmake/rules/../mplibSYSTEMOPENMPI
        set -x PINC (mpicc --showme:compile)
        set -x PLIBS (mpicc --showme:link)
        set -l libDir (echo "$PLIBS" | sed -e 's/.*-L\([^ ]*\).*/\1/')

        # Bit of a hack: strip off 'lib' and hope this is the path to openmpi
        # include files and libraries.
        set -x MPI_ARCH_PATH (dirname $libDir)

        foamPrintDebug "Using system installed MPI:"
        foamPrintDebug "    compile flags : $PINC"
        foamPrintDebug "    link flags    : $PLIBS"
        foamPrintDebug "    libmpi dir    : $libDir"

        prependToVar LD_LIBRARY_PATH $libDir
    case MPICH
        set -x FOAM_MPI mpich2-1.1.1p1
        set -x MPI_HOME $WM_THIRD_PARTY_DIR/$FOAM_MPI
        set -x MPI_ARCH_PATH $WM_THIRD_PARTY_DIR/platforms/$WM_ARCH$WM_COMPILER/$FOAM_MPI

        prependToVar PATH $MPI_ARCH_PATH/bin
        prependToVar LD_LIBRARY_PATH $MPI_ARCH_PATH/lib
        prependToVar MANPATH $MPI_ARCH_PATH/share/man
    case MPICH-GM
        set -x FOAM_MPI mpich-gm
        set -x MPI_ARCH_PATH /opt/mpi
        set -x MPICH_PATH $MPI_ARCH_PATH
        set -x GM_LIB_PATH /opt/gm/lib64

        prependToVar PATH $MPI_ARCH_PATH/bin
        prependToVar LD_LIBRARY_PATH $MPI_ARCH_PATH/lib
        prependToVar LD_LIBRARY_PATH $GM_LIB_PATH
    case HPMPI
        set -x FOAM_MPI hpmpi
        set -x MPI_HOME /opt/hpmpi
        set -x MPI_ARCH_PATH $MPI_HOME

        prependToVar PATH $MPI_ARCH_PATH/bin

        switch (uname -m)
            case i686
                prependToVar LD_LIBRARY_PATH $MPI_ARCH_PATH/lib/linux_ia32
            case x86_64
                prependToVar LD_LIBRARY_PATH $MPI_ARCH_PATH/lib/linux_amd64
            case ia64
                prependToVar LD_LIBRARY_PATH $MPI_ARCH_PATH/lib/linux_ia64
            case '*'
                echo Unknown processor type (uname -m) for Linux
        end
    case GAMMA
        set -x FOAM_MPI gamma
        set -x MPI_ARCH_PATH /usr
    case MPI
        set -x FOAM_MPI mpi
        set -x MPI_ARCH_PATH /opt/mpi
    case FJMPI
        set -x FOAM_MPI fjmpi
        set -x MPI_ARCH_PATH /opt/FJSVmpi2

        prependToVar PATH $MPI_ARCH_PATH/bin
        prependToVar LD_LIBRARY_PATH $MPI_ARCH_PATH/lib/sparcv9
        prependToVar LD_LIBRARY_PATH /opt/FSUNf90/lib/sparcv9
        prependToVar LD_LIBRARY_PATH /opt/FJSVpnidt/lib
    case QSMPI
        set -x FOAM_MPI qsmpi
        set -x MPI_ARCH_PATH /usr/lib/mpi

        prependToVar PATH $MPI_ARCH_PATH/bin
        prependToVar LD_LIBRARY_PATH $MPI_ARCH_PATH/lib
    case SGIMPI
        set -x FOAM_MPI (echo $MPI_ROOT | sed -e 's#/$##')
        set -x MPI_ARCH_PATH $MPI_ROOT

        if begin; not test -d $MPI_ROOT; or test -z $MPI_ARCH_PATH; end
            echo "Warning in $WM_PROJECT_DIR/etc/config/settings.sh:" 1>&2
            echo "    MPI_ROOT not a valid mpt installation directory or ending in a '/'." 1>&2
            echo "    Please set MPI_ROOT to the mpt installation directory." 1>&2
            echo "    MPI_ROOT currently set to '$MPI_ROOT'" 1>&2
        end

        foamPrintDebug "Using SGI MPT:"
        foamPrintDebug "    MPI_ROOT : $MPI_ROOT"
        foamPrintDebug "    FOAM_MPI : $FOAM_MPI"

        prependToVar PATH $MPI_ARCH_PATH/bin
        prependToVar LD_LIBRARY_PATH $MPI_ARCH_PATH/lib
    case INTELMPI
        set -x FOAM_MPI (echo $MPI_ROOT | sed -e 's#/$##')
        set -x MPI_ARCH_PATH $MPI_ROOT

        if begin; not test -d $MPI_ROOT; or test -z $MPI_ARCH_PATH; end
            echo "Warning in $WM_PROJECT_DIR/etc/config/settings.sh:" 1>&2
            echo "    MPI_ROOT not a valid mpt installation directory or ending in a '/'." 1>&2
            echo "    Please set MPI_ROOT to the mpt installation directory." 1>&2
            echo "    MPI_ROOT currently set to '$MPI_ROOT'" 1>&2
        end

        foamPrintDebug "Using INTEL MPI:"
        foamPrintDebug "    MPI_ROOT : $MPI_ROOT"
        foamPrintDebug "    FOAM_MPI : $FOAM_MPI"

        prependToVar PATH $MPI_ARCH_PATH/bin64
        prependToVar LD_LIBRARY_PATH $MPI_ARCH_PATH/lib64
    case '*'
        set -x FOAM_MPI dummy
end

# add (non-dummy) MPI implementation
# dummy MPI already added to LD_LIBRARY_PATH and has no external libraries
test "$FOAM_MPI" != dummy;
    and prependToVar LD_LIBRARY_PATH $FOAM_LIBBIN/$FOAM_MPI $FOAM_EXT_LIBBIN/$FOAM_MPI


# Set the minimum MPI buffer size (used by all platforms except SGI MPI)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set -q minBufferSize;
    and set -gx MPI_BUFFER_SIZE $minBufferSize
set -l minBufferSize 20000000;
    and set -gx MPI_BUFFER_SIZE $minBufferSize
    
set -gx MPI_BUFFER_SIZE 20000000

#set -q MPI_BUFFER_SIZE;
#    and set -gx MPI_BUFFER_SIZE $minBufferSize

#math "$MPI_BUFFER_SIZE" < "$minBufferSize";
#    and set -gx MPI_BUFFER_SIZE $minBufferSize

set -e foamCompiler
set -e minBufferSize


# ----------------------------------------------------------------- end-of-file
