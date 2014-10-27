FROM binhex/arch-base:2014101300
MAINTAINER binhex

# additional files
##################

# download packer from aur
ADD https://aur.archlinux.org/packages/pa/packer/packer.tar.gz /root/packer.tar.gz

# add supervisor file for application
ADD plexmediaserver.conf /etc/supervisor/conf.d/plexmediaserver.conf

# install app
#############

# install base devel, install app using packer, set perms, cleanup
RUN pacman -Sy --noconfirm && \
	pacman -S --needed base-devel --noconfirm && \
	cd /root && \
	tar -xzf packer.tar.gz && \
	cd /root/packer && \
	makepkg -s --asroot --noconfirm && \
	pacman -U /root/packer/packer*.tar.xz --noconfirm && \
	packer -S plex-media-server --noconfirm && \
	pacman -Ru base-devel --noconfirm && \
	pacman -Scc --noconfirm && \
	chown -R nobody:users /opt/plexmediaserver /etc/conf.d/plexmediaserver && \
	chmod -R 775 /opt/plexmediaserver /etc/conf.d/plexmediaserver && \	
	rm -rf /archlinux/usr/share/locale && \
	rm -rf /archlinux/usr/share/man && \
	rm -rf /root/* && \
	rm -rf /tmp/*
	
# customize app config file
RUN sed -i 's/cd \${PLEX_MEDIA_SERVER_HOME}; su -c \"\${PLEX_MEDIA_SERVER_HOME}\/Plex\\ Media\\ Server \&\" \${PLEX_MEDIA_SERVER_USER}/cd \${PLEX_MEDIA_SERVER_HOME}; \"\${PLEX_MEDIA_SERVER_HOME}\/Plex Media Server\"/g' /opt/plexmediaserver/start_pms

# add in custom config file
ADD plexmediaserver /etc/conf.d/plexmediaserver

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