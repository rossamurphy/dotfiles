# What is this repo?
Here are a watered down version of dotfiles for tmux and nvim.

## Why are they here?
- mainly here so I can grab them when I remote into other machines.
- also here in case they are useful to others.

## Why is this README terse?
- unfortunately this is probably as verbose as this readme will get, but if you need help with anything related to the contents of this, please just reach out.

## Quickstart 

### Install nvim 
More [here](https://github.com/neovim/neovim/blob/master/INSTALL.md)

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

###### now the real thing
```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
```

```bash
export PATH="$PATH:/opt/nvim-linux64/bin"
```

Now make it possible to sudo open nvim

```bash
vi .bashrc
```

and add this line
```bash
alias vi='sudo env "PATH=$PATH" nvim'
```
Write and close it.

Now source it

```bash
source .bashrc
```

###### get git 
```bash
sudo apt-get install git
```

######  get packer
```bash
sudo git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.config/nvim/pack/packer/start/packer.nvim
```


### Init the config dir

```bash
git clone https://github.com/rossamurphy/dotfiles 
mkdir ~/.config
cp -a dotfiles/.config/. ~/.config
```

### Set up Packer
```bash
cd ./.config/nvim/lua
sudo nvim
```

```vim
:Ex
# Go the packer.lua file and source it
:so
:PackerInstall
:PackerSync
```


## Optional

### Install pip for python 3 (to install and update pynvim)
```bash
sudo apt-get install python3-pip
```

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



