#!/bin/bash

# script for updating gentoo packages
# Copyright (C) 2007 Reto Gantenbein <reto.gantenbein@linuxmonk.ch>
# SPDX-License-Identifier: GPL-2.0
#************************************************************************************

EMERGE="/usr/bin/emerge"
DEP_REBUILD="/usr/bin/revdep-rebuild"
GLSA_CHECK="/usr/bin/glsa-check"

#************************************************************************************

function print_usage()
{
    ARGS=( "-u" "-s" "-a" "-p" )
    echo "Usage: $0 OPTION"
    echo ""
    echo "Options: ${ARGS[0]}    Check revision updates"
    echo "         ${ARGS[1]}    Check GLSA security updates"
    echo "         ${ARGS[2]}    Check all package updates"
    echo "         ${ARGS[3]}    Only print updates"
    echo ""
    echo "Put packages which you do not want to update "
    echo "into /etc/portage/package.mask!"
    exit 0
}

#************************************************************************************
function emerge_args()
{
    ARGS="-v"
    if [ "${PRINT_ONLY}" -eq 0 ]; then
	ARGS="${ARGS}p"
    else
	ARGS="${ARGS}a"
    fi
    if [ "${NO_DEEP}" -eq 1 ]; then
	ARGS="${ARGS}Du"
    fi
    echo $ARGS
}

#************************************************************************************
function finish()
{
    if [ $1 -eq 0 -a ${PRINT_ONLY} -eq 1 ]; then
	echo -n "Checking library consistency... "
	${DEP_REBUILD} >> /dev/null
	if [ $? -eq 0 ]; then
	    echo "OK!"
	fi
    elif [ $1 -gt 0 ]; then
        echo "!! There was an error when running 'emerge'. Check output!"
    fi
    exit 0
}

#************************************************************************************
function check_number()
{
    if [ $1 -eq 0 ]; then
	echo "--> No packages found for updating!"
        exit 2
    fi
}

#************************************************************************************
function check_glsa()
{
    echo "Gentoo Linux Security Advisories available for:"

    LIST=( $( "${GLSA_CHECK}" -l affected 2> /dev/null | while read LINE
    do
	echo $( echo ${LINE} | cut -d"(" -f2 | cut -d")" -f1 )
    done ) )

    i=0
    PACKAGES=()
    IND_BOUND=$((${#LIST[*]}-1))
    while [ "$i" -lt "${IND_BOUND}" ]; do
	LINE=$( eix -ce ${LIST[$i]} )
        echo "${LINE}" | grep "[U]" >> /dev/null
	if [ "$?" -eq "0" ]; then
	    echo -n " * "
	    echo "${LINE}" | cut -d' ' -f2
	    PACKAGES=( "${PACKAGES[@]}" "${LIST[$i]}" )
        fi
	i=$(($i+1))
    done

    check_number ${#PACKAGES[*]}

    NO_DEEP=0
    "${EMERGE}" "$( emerge_args )" ${PACKAGES[@]}
    finish $?
}

#************************************************************************************

function update_all()
{
    echo "Update all packages:"
    "${EMERGE}" "$( emerge_args )" world
    finish $?
}

#************************************************************************************

function upgrade()
{
    echo "Upgrade package revisions (only within same version):"
    LIST=( $( emerge -up world | grep -G "ebuild[ \t]*U " | while read LINE
    do
	echo $( echo "${LINE}" | cut -d"]" -f2 | cut -d"[" -f1 )
    done ) )

    i=0
    PACKAGES=()
    for PROGRAM in ${LIST[@]}; do
	PKG=$( echo "${PROGRAM}" | sed 's/-[[0-9][0-9]*.*]*//g' )
	VERSIONS=$( "${EMERGE}" -p --nodeps "${PKG}" | grep "${PKG}" )
	OLD_VERSION=$( echo "${VERSIONS}" | cut -d'[' -f3 | cut -d']' -f1 )
        NEW_VERSION=$( echo "${VERSIONS}" | cut -d'/' -f2 | sed -r 's/([a-zA-Z]+[0-9]{0,1}[0-9]{0,1}[_\-\+]*)+\-//g' | cut -d'[' -f1 )
	if [ "x${OLD_VERSION}" == "x" ]; then
	    OLD_VERSION=0
	fi
#	echo "pkg=$PKG, old=$OLD_VERSION, new=$NEW_VERSION"
	if [ $( echo "${OLD_VERSION}" | cut -d'-' -f1 ) == $( echo "${NEW_VERSION}" | cut -d'-' -f1 ) ]; then
	    echo " * ${PKG}"
	    PACKAGES=( "${PACKAGES[@]}" "${PKG}" )
	fi
	i=$(($i+1))
    done

    check_number "${#PACKAGES[*]}"

    NO_DEEP=0
    "${EMERGE}" "$( emerge_args )t" ${PACKAGES[@]}
    finish $?
}

#************************************************************************************

PRINT_ONLY=1
NO_DEEP=1
GLSA=1
UPDATE=1
UPGRADE=1

# parse parameters
if [ "$#" -eq 0 ]; then
    print_usage
fi

while getopts "psau" ARG; do
    case $ARG in
    p)    PRINT_ONLY=0
          echo "Only print action... don't do anything!";;
    s)    GLSA=0;;
    a)    UPDATE=0;;
    u)    UPGRADE=0;;
    \?)   print_usage;;
    esac
done

if [ "${GLSA}" -eq 0 ]; then
    check_glsa
elif  [ "${UPDATE}" -eq 0 ]; then
    update_all
elif  [ "${UPGRADE}" -eq 0 ]; then
    upgrade
fi
