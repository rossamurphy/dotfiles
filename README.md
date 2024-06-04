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

###### libgcc-s1
```bash
wget http://mirrors.xmission.com/ubuntu/pool/main/g/gcc-10/libgcc-s1_10-20200411-0ubuntu1_amd64.deb
```

Install those
###### gcc-10-base
```bash
sudo dpkg -i ./gcc-10-base_10-20200411-0ubuntu1_amd64.deb
```

###### libgcc-s1
```bash
sudo dpkg -i ./libgcc-s1_10-20200411-0ubuntu1_amd64.deb
```

###### now the real thing
```bash
wget https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.deb
sudo apt install ./nvim-linux64.deb
```

###### get git 
```bash
sudo apt-get install git
```

######  get packer
```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

### Init the config dir

```bash
git clone https://github.com/rossamurphy/dotfiles 
mkdir ~/.config
cp -a dotfiles/.config/. ~/.config
```


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



