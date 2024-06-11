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

### RECOMMENDED
or, just clone the repo on a linux box, and use vanilla docker build to build it 
```bash
docker build -t rossamurphy/dotfilesimage:latest .
```
if you're happy with the result, push it
```bash
docker push rossamurphy/dotfilesimage:latest
```
note before you do the above you'll need to have logged in
```bash
docker login
```

now if you want to pull your image and run it anywhere
```bash
sudo apt-get update
sudo apt-get install -y containerd runc docker.io
sudo systemctl enable docker
sudo systemctl start docker
docker pull rossamurphy/dotfilesimage:latest
```

it's also useful to create a volume to attach to the container to persist data
```bash
docker volume create rm_volume
```

Now to use the image to run the container, you have a few options

### Run using normal docker run command

#### note here below are reunning the container in a privileged fashion with the host volume as the root

##### if you run with --rm , then when you stop the container (ctrl-d out of it) it will auto-delete
docker run --name rmvm -it --rm --privileged -v /:/host rossamurphy/dotfilesimage:latest /bin/bash

##### if you run without --rm , when you stop the container (ctrl-d out of it) it will remain
docker run --name rmvm -it --rm --privileged -v /:/host rossamurphy/dotfilesimage:latest /bin/bash

### Run using docker-compose

you can also use docker-compose to start your docker container in detached mode (here we are doing so with a volume attached)
so, do this instead of just running it (the docker-compose.yml is in this repo)
```bash
docker-compose up -d
```

you can see the container you just started with
```bash
docker container ls
```

and attach to it by
```bash
docker container attach rmvm
```

and tear it down (and remove it) by
```bash
docker-compose down
```

now you can see that you've completely torn down and removed the container, however,
you can easily use the image to start the container again
```bash
docker-compose up -d
docker container attach rmvm
```

### Setting up neovim plugins
N.B. the FIRST time you create a NEW container, you'll need to install your plugins 
there is a way this can happen automatically in the image but it seems to be more hassle than it's worth
so, run the below in the container:
```bash
nvim --noplugins -c "luafile /root/.config/nvim/plugin_setup.lua"
```

this will do the thing. and now you can open neovim as per normal

and then open neovim as normal
```bash
vi
```

