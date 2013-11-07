#!/bin/sh
#
# Synchronize files from PhotoStream to local dir
#
# Author:  Eirik Refsdal <eirikref@gmail.com>
# Version: 2013-11-07

readonly SOURCE_DIR=$HOME"/Library/Application Support/iLifeAssetManagement/assets/sub"
readonly DEST_DIR=$HOME"/PhotoStream"
readonly SYNCTS_FILE=$HOME"/.pssync"
readonly LOCK_FILE=$HOME"/.pssync_lock"
PREV_SYNC_TS="1980-01-01 00:00:00"
THIS_SYNC_TS=0

init()
{
    if [ -f "${LOCK_FILE}" ]; then
        echo "Lock file exists. Exiting."
        exit 1
    else
        touch ${LOCK_FILE}
    fi

    if [ ! -d "${SOURCE_DIR}" ]; then
        echo "Source PhotoStream directory does not exist. Are you sure you" \
             "have installed iPhoto/Aperture and enabled My PhotoStream under" \
             "iCloud Photo Options in in System Preferences?"
    fi

    if [ ! -d "${DEST_DIR}" ]; then
        echo "Making destination directory..."
        mkdir -p ${DEST_DIR}
    fi

    if [ ! -w "${DEST_DIR}" ]; then
        echo "Destionation directory (~/PhotoStream) is not writable. Exiting."
        exit 1
    fi

    if [ -f "${SYNCTS_FILE}" ]; then
        PREV_SYNC_TS=$(cat ${SYNCTS_FILE})
    else
        touch ${SYNCTS_FILE}
    fi

    THIS_SYNC_TS=$(date "+%Y-%m-%d %H:%M:%S")
}

teardown()
{
    if [ -f "${LOCK_FILE}" ]; then
        rm ${LOCK_FILE}
    fi

    echo ${THIS_SYNC_TS} > ${SYNCTS_FILE}
}

sync()
{

    echo "Last sync:    " ${PREV_SYNC_TS}
    echo "Current time: " ${THIS_SYNC_TS}

    printf "Syncing new files... "
    find "${SOURCE_DIR}" -iname "*.JPG" -newerct "${PREV_SYNC_TS}" | while read f
    do
        cp -av "$f" "${DEST_DIR}"
    done
    printf "Done\n"
}

init
sync
teardown
