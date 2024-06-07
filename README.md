# What is this repo?
Here are a watered down version of dotfiles for tmux and nvim.

## Why are they here?
- mainly here so I can grab them when I remote into other machines.
- also here in case they are useful to others.

## Why is this README terse?
- unfortunately this is probably as verbose as this readme will get, but if you need help with anything related to the contents of this, please just reach out.

## Quickstart 



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
sudo apt install ripgrep
```

###### now the real thing (nvim)
```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
```

This may change in future, for more check out the main source [here](https://github.com/neovim/neovim/blob/master/INSTALL.md)

```bash
export PATH="$PATH:/opt/nvim-linux64/bin"
```

and, for ease, set an alias in your .bashrc
```bash
vi ~/.bashrc
```

```bash
alias vi='nvim'
```

write and close and source your .bashrc
```vim
:wq
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

