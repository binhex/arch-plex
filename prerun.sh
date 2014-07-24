#!/bin/bash

# check if library exists on /config, if not copy default library
if [ -d "/config/Library" ]; then

	echo "library exists"
	
else
	
	# copy default library to /config and set owner
	cp -R /opt/plexmediaserver/Library /config
	chown -R nobody:users /config/Library
	
fi
