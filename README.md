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
```bash
sudo apt-get install neovim
```

### Init the config dir

```bash
git clone https://github.com/rossamurphy/dotfiles 
touch ~/.config/
cp -a dotfiles/.config/. ~/.config
```

### Install ruby (neovim likes it)

```bash
sudo apt-get install ruby-full
```



