#!/bin/sh

###############################################################
## SCRIPT SETUP                                              ##
###############################################################

# Setup Build Variables
export MAKEFLAGS="-j4"

# Setup Location Variables
export CWD=$(pwd)
. "${CWD}/config/build.conf"
export WORKDIR="/usr/local/$DistroName"
export LFS=${WORKDIR}/source
export LFS_TGT=$(uname -m)-linux-gnu
export CONFIG_SITE=$LFS/usr/share/config.site
export LC_ALL=POSIX
# More will be needed but this is a start

# Check if user is sudo
if [ $(whoami) != "root" ]; then 
    echo "Run this script as root!"
    echo "Ex: sudo sh $0"
    exit
fi

###############################################################
## BUILD PREPERATIONS                                        ##
###############################################################

# Make Directories
make_working_directories(){
    echo "Creating ${WORKDIR}"
    if [ ${WORKDIR} ]; then
        rm -rf ${WORKDIR}
    fi
    mkdir -pv ${WORKDIR}

    echo "Creating ${WORKDIR} subfolders"
    mkdir -pv ${WORKDIR}/tarfiles
    mkdir -pv ${WORKDIR}/source
    mkdir -pv ${WORKDIR}/iso
    mkdir -pv ${WORKDIR}/system
}

# Make partition
make_and_mount_partition(){
    echo "Creating pool.img in ${WORKDIR}/system/pool.img" 
    truncate ${WORKDIR}/system/pool.img -s 6G
    mkfs ext4 -F ${WORKDIR}/system/pool.img
    mount -o loop ${WORKDIR}/system/pool.img ${WORKDIR}/source
}

# Get from wget-list
get_from_wget_list(){
    cd $LFS/sources
    wget --input-file=${CWD}/src/wget-list --continue --directory-prefix=$LFS/sources
}

###############################################################
## BUILDING PACKAGE LIST                                     ##
###############################################################
build_packages(){
    . ${CWD}/tarlists/${Tarlist}
    build-BinUtils-PASS-1
}

###############################################################
## SYSTEM CONFIGURATIONS                                     ##
###############################################################

###############################################################
## COMPILE ISO                                               ##
###############################################################

###############################################################
## Run Functions                                             ##
###############################################################

# Build Preperations
make_working_directories
make_and_mount_partition
get_from_wget_list

# Toolchain Compile

# Building Package List

# System Configurations

# Compile ISO