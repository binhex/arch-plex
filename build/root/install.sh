#!/bin/bash

# exit script if return code != 0
set -e

# build scripts
####

# download build scripts from github
curly.sh -rc 6 -rw 10 -of /tmp/scripts-master.zip -url https://github.com/binhex/scripts/archive/master.zip

# unzip build scripts
unzip /tmp/scripts-master.zip -d /tmp

# move shell scripts to /root
mv /tmp/scripts-master/shell/arch/docker/*.sh /root/

# pacman packages
####

# define pacman packages
pacman_packages=""

# install compiled packages using pacman
if [[ ! -z "${pacman_packages}" ]]; then
	pacman -S --needed $pacman_packages --noconfirm
fi

# aor packages
####

# define arch official repo (aor) packages
aor_packages=""

# call aor script (arch official repo)
source /root/aor.sh

# aur packages
####

# define aur packages
aur_packages="prelink plex-media-server"

# call aur install script (arch user repo)
source /root/aur.sh

# container perms
####

# create file with contets of here doc
cat <<'EOF' > /tmp/permissions_heredoc
# set permissions inside container
chown -R "${PUID}":"${PGID}" /etc/conf.d/plexmediaserver /opt/plexmediaserver/ /home/nobody
chmod -R 775 /etc/conf.d/plexmediaserver /opt/plexmediaserver/ /home/nobody

EOF

# replace permissions placeholder string with contents of file (here doc)
sed -i '/# PERMISSIONS_PLACEHOLDER/{
    s/# PERMISSIONS_PLACEHOLDER//g
    r /tmp/permissions_heredoc
}' /root/init.sh
rm /tmp/permissions_heredoc

# env vars
####

cat <<'EOF' > /tmp/envvars_heredoc
export TRANS_DIR=$(echo "${TRANS_DIR}" | sed -e 's/^[ \t]*//')
if [[ ! -z "${TRANS_DIR}" ]]; then
	echo "[info] TRANS_DIR defined as '${TRANS_DIR}'" | ts '%Y-%m-%d %H:%M:%.S'
else
	echo "[warn] TRANS_DIR not defined,(via -e TRANS_DIR), defaulting to '/config/tmp'" | ts '%Y-%m-%d %H:%M:%.S'
	export TRANS_DIR="/config/tmp"
fi

mkdir -p /config/tmp

EOF

# replace envvar placeholder string with contents of file (here doc)
sed -i '/# ENVVARS_PLACEHOLDER/{
    s/# ENVVARS_PLACEHOLDER//g
    r /tmp/envvars_heredoc
}' /root/init.sh
rm /tmp/envvars_heredoc

# cleanup
yes|pacman -Scc
rm -rf /usr/share/locale/*
rm -rf /usr/share/man/*
rm -rf /usr/share/gtk-doc/*
rm -rf /tmp/*