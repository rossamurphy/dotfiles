# What is this repo?
Here are a watered down version of dotfiles for tmux and nvim.

## Why are they here?
- mainly here so I can grab them when I remote into other machines.
- also here in case they are useful to others.

## Why is this README terse?
- unfortunately this is probably as verbose as this readme will get, but if you need help with anything related to the contents of this, please just reach out.

## Quickstart

### rm edit

#### create the vm
./create-vm.sh (specify the vm name and specs in this script)

#### transfer what you need
scp -i /Users/rossmurphy/.ssh/<VM_NAME> Dockerfile setup.sh rossmurphy@<VM_IP>:~/
##### e.g.
scp -i /Users/rossmurphy/.ssh/dev_machine dev-setup.mk Dockerfile setup.sh rossmurphy@34.147.204.25:~/

#### ssh in
ssh -i /Users/rossmurphy/.ssh/<VM_NAME> rossmurphy@<VM_IP>

##### give it make...
sudo apt-get update
sudo apt-get install -y make


#### run the setup script
<!-- make -f dev-setup.mk all -->
chmod +x ./setup.sh
./setup.sh

#### or, just for specific steps
# Just install Docker
make -f dev-setup.mk install-docker

# Just build the image
make -f dev-setup.mk build-image

# Just run the container
make -f dev-setup.mk run-container


#### now, you can connect with
mosh --ssh="ssh -p 2222" root@34.45.214.18

#### For debian (most GCP machines)

##### Get the dependencies

###### gcc-10-base
```bash
wget http://mirrors.edge.kernel.org/ubuntu/pool/main/g/gcc-10/gcc-10-base_10-20200411-0ubuntu1_amd64.deb
```

Install those
###### gcc-10-base
```bash
sudo dpkg -i ./gcc-10-base_10-20200411-0ubuntu1_amd64.deb
```

and for the rest
```bash
sudo apt update
sudo apt install build-essential
```

and, for the ones STILL not included, go, npm, and unzip:

npm and unzip from here
```bash
sudo apt install -y nodejs npm unzip
```

and now for go
// (source from here https://stackoverflow.com/questions/17480044/how-to-install-the-current-version-of-go-in-ubuntu-precise)
```bash
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update
sudo apt install golang-go
```

###### install ripgrep (for fuzzy finding and telescope)
```bash
sudo apt update
sudo apt-get install ripgrep
```

###### now the real thing (nvim)
```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
```

This may change in future, for more check out the main source [here](https://github.com/neovim/neovim/blob/master/INSTALL.md)

```bash
echo 'export PATH="/opt/nvim-linux64/bin:$PATH"' >> ~/.bashrc
```

and, for ease, set an alias in your .bashrc

```bash
echo 'alias vi="nvim"' >> ~/.bashrc
```

```bash
source ~/.bashrc
```


###### get git
```bash
sudo apt-get install git
```


### Init the config dir

```bash
sudo git clone https://github.com/rossamurphy/dotfiles
sudo mkdir ~/.config
sudo cp -a ~/dotfiles/.config/. ~/.config
```


###### change permissions

In order to open vim and have it auto install the plugins, it needs to be able to run packer in the background.
However, packer is installed to local/share by default, and that's owned by the root, not the user.
so, in order for it to be allowed to do what it needs to do, you need to change the ownership of the folder where packer is.
You can verify that it's not owned by you by doing:

```bash
ls -ld ~/.local/share/nvim/site
ls -ld ~/.config/nvim
```

So, go fix that by doing this
```bash
sudo chown -R $USER:$USER ~/.local/share/nvim
sudo chown -R $USER:$USER ~/.config/nvim
```

(You also needed to change the directory permissions to USER for the .config directory because you sudo copied it)
TODO - I can probably make this smoother

### Set up plugins
```bash
cd ./.config/nvim/lua
vi
```

```vim
:Ex
```
Go to the init.lua file (same directory as packer.lua) and source it
i.e. open it and run
```vim
:so
```
also do the same for the packer.lua file

then, once that's done correctly. install and sync the packages
```vim
:PackerInstall
:PackerSync
```

give yourself control over the directories so you can do stuff like PackerInstall and telecsope fuzzy find
(if you're getting the "ermahgerd writing to a nil value" error when you are doing PackerSync, you are probably going to want to run the below).
```
sudo chown -R "${USER}" ~/.local
sudo chown $USER ~/.config/nvim/plugin
sudo chown -R "${USER}" ~/
```

Install python via pyenv
```bash
cd ~/.pyenv/
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
```

```bash
cd ~/.pyenv && src/configure && make -C src
```

```bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
```

### Install pip for python 3 (to install and update pynvim)
```bash
sudo apt-get install python3-pip
sudo apt-get install python3-venv
sudo apt-get install python3-virtualenv
sudo apt-get install pipx

ptipython set up
```bash
sudo pipx install ptipython --include-deps
<!-- the below should be functionally equivalent -->
sudo pipx ensurepath
echo 'export PATH="/root/.local/bin":$PATH' >> ~/.bashrc
echo 'export PATH="/home/rossmurphy/.local/bin:$PATH"' >> ~/.bashrc
```




```bash
echo 'alias python="python3"' >> .bashrc
echo 'alias venvcreate="python -m venv venv"' >> .bashrc
echo 'alias venvactivate="source venv/bin/activate"' >> .bashrc
echo 'alias tks="tmux kill-server"' >> .bashrc
echo 'alias reload="source ~/.bashrc"' >> .bashrc
echo 'alias la="ls -a"' >> .bashrc
echo 'alias filesizes="du -h"' >> .bashrc
echo 'alias pfreqs="pip freeze > requirements.txt"' >> .bashrc
echo 'alias pireqs="pip install -r requirements.txt"' >> .bashrc
```


For moshing:
https://mosh.org/
```
sudo apt-get install mosh
```

For mosh if you need
```
sudo apt-get install ufw
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow 60000:61000/udp
sudo ufw reload
sudo ufw status
```

if all else fails you may have to update the firewall on your VM provider, e.g. for GCP:

Configure the Firewall Rule:

Name: Give your firewall rule a name, e.g., allow-mosh-udp.
Description: Optionally, add a description, e.g., Allow Mosh UDP ports 60000-61000.
Network: Select the VPC network where your VM resides.
Priority: Leave it as default (1000) unless you have specific priority needs.
Direction of traffic: Choose "Ingress".
Action on match: Select "Allow".
Targets: Choose "All instances in the network" or specify the target instances.
Source IP ranges: Enter 0.0.0.0/0 to allow from any IP (or restrict to your IP range for better security).
Protocols and ports:
Check "Specified protocols and ports".
Select "udp" and enter 60000-61000.


## Optional


### Install / update pynvim

For python 3
```bash
sudo pip3 install pynvim
sudo pip3 install --update pynvim
```


### Install ruby (neovim likes it)

```bash
sudo apt-get install ruby-full
```

Then add neovim support

```bash
sudo gem install neovim
```

### Change the default terminal colours
```bash
sudo apt-get install coreutils
dircolors --print-database > ~/.dir_colors
```
now open the dircolors file you've just created
```bash
vi .dir_colors
```

and make edits to the FILE and DIR codes. there are instructions provided in the file

to reload the file and apply your changes
```bash
eval $(dircolors ~/.dir_colors)
```

