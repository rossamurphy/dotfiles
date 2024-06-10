for just doing it the docker way

to build locally (build on an m1, for all platforms)
this uses docker buildx under the hood
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t dotfiles-setup:latest --push .
```

to run the image in interactive mode
```bash
docker run -it dotfiles-setup:latest /bin/bash
```

to pull and run on a server
```bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
docker pull rossamurphy/dotfiles-setup:latest
```
