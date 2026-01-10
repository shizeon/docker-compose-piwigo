#!/bin/bash

source "$(dirname "$(readlink -f "$0")")/sync-album.config"

if [[ -z "$ALBUM_SOURCE" || -z "$ALBUM_DESTINATION" ]]; then
    echo "Error: ALBUM_SOURCE and/or ALBUM_DESTINATION not set" >&2
    exit 1
fi

printf "Syncing album files from %s to %s\n" "$ALBUM_SOURCE" "$ALBUM_DESTINATION"

rsync -rltv --progress --stats --no-perms --no-owner --no-group  --omit-dir-times --chown=:systemd-journal \
   "${ALBUM_SOURCE}/" "${ALBUM_DESTINATION}/"
find $ALBUM_DESTINATION -type d -user shizeon -exec chmod 777 {} \;
find $ALBUM_DESTINATION -type f -user shizeon -exec chmod 666 {} \;

# TODO: Sync removed files from source to destination, do not remove pwg_representation files
