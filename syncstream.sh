#!/bin/sh
#
# Synchronize files from PhotoStream to local dir
#
# Author:  Eirik Refsdal <eirikref@gmail.com>
# Version: 2013-11-07
#
# I love automatically syncing photos from my iPhone to my MacBook Air
# using PhotoStreams, but I'm just not able to get comfortable with
# iPhoto. I want a folder with my photos, where I can manipulate file
# using any means (terminal, iPhoto, Finder, etc.), and having this
# magic, duplicate database only accessible by iPhoto just makes me
# confused.
#
# So I need to:
# 1. Have syncing of my PhotoStream enabled
# 2. Copy files from the internal PhotoStream folder to my own folder
# 3. Do 2) automatically
# 4. Don't copy files older than the last time I synced

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
        # echo $f
        cp "$f" "${DEST_DIR}"
    done
    printf "Done\n"
}

init
sync
teardown
