for just doing it the docker way

to build locally (build on an m1, for all platforms)
this uses docker buildx under the hood
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t rossamurphy/dotfilesimage:latest --push .
```

to run the image in interactive mode (on an m1)
```bash
docker run --platform linux/amd64 -it rossamurphy/dotfilesimage:latest /bin/bash
```

N.B. the FIRST time you set up nvim on the new host, navigate to the init.lua file (via :Ex) FIRST, and source THAT (by :so), BEFORE sourcing the packer file packer.lua (:so).
Then do :PackerInstall , :PackerSync, and :PackerCompile

to pull and run on a server
```bash
sudo apt-get update
sudo apt-get install -y containerd runc docker.io
sudo systemctl enable docker
sudo systemctl start docker
docker pull rossamurphy/dotfilesimage:latest
# run the container in a privileged fashion with the host volume as the root

# if you run with --rm , then when you stop the container (ctrl-d out of it) it will auto-delete
# docker run --name rmvmcontainer -it --rm --privileged -v /:/host rossamurphy/dotfilesimage /bin/bash

# if you run without --rm , when you stop the container (ctrl-d out of it) it will remain
# if you run docker container ls, you will not see it, because it's stopped
# if you want to start it again, run `docker container start rmvmcontainer`
# and then `docker container attach rmvmcontainer`
# this is preferable because when you auto-delete (remove) a container, you also delete all the data
# that was inside it. however, when you just stop and start, the data persists

docker run --name rmvmcontainer -it --rm --privileged -v /:/host rossamurphy/dotfilesimage /bin/bash

# another way of dealing with this would be to create a volume and use that volume to persist the config data and even re-use it across multiple containers
# for example create a volume called rmvmcontainer_volume
```bash
docker volume create rmvmcontainer_volume
```

and now use docker-compose to start a docker container in detached mode with the volume
```bash
docker-compose up -d
```

you can see the container you just started with
```bash
docker container ls
```

and attach to it by
```bash
docker container attach rmvmcontainer
```

and tear it down (and remove it) by
```bash
docker-compose down
```

now you can see that you've completely torn down and removed the container, however,
if you start it again
```bash
docker-compose up -d
docker container attach rmvmcontainer
```

and then open neovim
```bash
vi
```

notice that you no longer have to run all of your packer set up, because that's persisted in /data (which is a docker volume which has been persisted for longer than the containers).



```
