FROM binhex/arch-base:2015010200
MAINTAINER binhex

# additional files
##################

# add supervisor file for application
ADD plexmediaserver.conf /etc/supervisor/conf.d/plexmediaserver.conf

# install app
#############

# install base devel, install app using packer, set perms, cleanup
RUN pacman -Sy --noconfirm && \
	pacman -S --needed base-devel --noconfirm && \
	useradd -m -g wheel -s /bin/bash makepkg_user && \
	echo -e "makepkg_password\nmakepkg_password" | passwd makepkg_user && \
	echo "%wheel      ALL=(ALL) ALL" >> /etc/sudoers && \
	echo "Defaults:makepkg_user      !authenticate" >> /etc/sudoers && \
	curl -o /home/makepkg_user/packer.tar.gz https://aur.archlinux.org/packages/pa/packer/packer.tar.gz && \
	cd /home/makepkg_user && \
	tar -xvf packer.tar.gz && \
	su -c "cd /home/makepkg_user/packer && makepkg -s --noconfirm --needed" - makepkg_user && \
	pacman -U /home/makepkg_user/packer/packer*.tar.xz --noconfirm && \
	su -c "packer -S plex-media-server --noconfirm" - makepkg_user && \
	chown -R nobody:users /var/lib/plex /etc/conf.d/plexmediaserver /opt/plexmediaserver/ && \
	chmod -R 775 /var/lib/plex /etc/conf.d/plexmediaserver /opt/plexmediaserver/ && \
	pacman -Ru base-devel --noconfirm && \
	pacman -Scc --noconfirm && \	
	userdel -r makepkg_user && \
	rm -rf /archlinux/usr/share/locale && \
	rm -rf /archlinux/usr/share/man && \
	rm -rf /tmp/*
	
# add custom environment file for application
ADD plexmediaserver.sh /usr/bin/plexmediaserver.sh
RUN chmod +x /usr/bin/plexmediaserver.sh
	
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