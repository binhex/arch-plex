#!/bin/sh

#set env variables
export PLEX_MEDIA_SERVER_USER=nobody
export PLEX_MEDIA_SERVER_HOME=/opt/plexmediaserver
export PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=/var/lib/plex
export PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS=6
export PLEX_MEDIA_SERVER_TMPDIR=/config/tmp

#set env variables (replaces plexmediaserver.sh)
export LANG='en_US.UTF-8'
export LC_ALL=
export LD_LIBRARY_PATH=/opt/plexmediaserver
export TMPDIR=/config/tmp

#set home directory (will auto create library files on start of "Plex Media Server")
export HOME="/config/Library/Application Support"

#kick off main process
exec /opt/plexmediaserver/Plex\ Media\ Server


