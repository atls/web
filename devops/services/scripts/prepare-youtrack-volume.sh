#!/bin/sh

VOLUME=$1
VOLUME_PATH=$(readlink -f $VOLUME)
VOLUME_NAME=$(basename $VOLUME_PATH)
VOLUME_DATA=$(sudo file -s $VOLUME_PATH)
MOUNT_POINT="/youtrack"

EMPTY_VOLUME_DATA="$VOLUME_PATH: data"

if [[ $VOLUME_DATA = $EMPTY_VOLUME_DATA ]]; then
  sudo mkfs -t ext4 $VOLUME_PATH
fi

if [ ! -d $MOUNT_POINT ]; then
  sudo mkdir $MOUNT_POINT
  sudo mount $VOLUME_PATH $MOUNT_POINT
  sudo mkdir -p -m 750 /youtrack/data /youtrack/conf /youtrack/logs /youtrack/backups
  sudo chown -R 13001:13001 /youtrack/data /youtrack/conf /youtrack/logs /youtrack/backups
fi
