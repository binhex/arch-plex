FROM binhex/arch-base:2015030300
MAINTAINER binhex

# additional files
##################

# add custom environment file for application
ADD plexmediaserver.sh /home/nobody/plexmediaserver.sh

# add supervisor file for application
ADD plexmediaserver.conf /etc/supervisor/conf.d/plexmediaserver.conf

# add install bash script
ADD install.sh /root/install.sh

# add packer bash script
ADD packer.sh /root/packer.sh

# install app
#############

# make executable and run bash scripts to install app
RUN chmod +x /root/install.sh /root/packer.sh /home/nobody/plexmediaserver.sh && \
	/bin/bash /root/install.sh
	
# docker settings
#################

# map /config to host defined config path (used to store configuration from app)
VOLUME /config

# map /media to host defined media path (used to read/write to media library)
VOLUME /media

# run supervisor
################

# run supervisor
CMD ["supervisord", "-c", "/etc/supervisor.conf", "-n"]