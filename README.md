Plex Media Server
=================

Plex Media Server - https://plex.tv/

Latest stable Plex Media Server release from Arch Linux AUR using Packer to compile.

**Pull image**

```
docker pull binhex/arch-plex
```

**Run container**

```
docker run -d --net="host" --name=<container name> -v <path for media files>:/media -v <path for config files>:/config -v /etc/localtime:/etc/localtime:ro binhex/arch-plex
```

Please replace all user variables in the above command defined by <> with the correct values.

**Access application**

```
http://<host ip>:32400/web
```

Note: You cannot specify the port this docker container uses, it requires full access to the hosts nic and thus the -p flag is ignored.