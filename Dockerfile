FROM debian:latest 

# Set the working directory in the container
WORKDIR /root

# Install dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget sudo gnupg btop curl build-essential nodejs npm unzip software-properties-common python3-pip python3-venv python3-virtualenv pipx git ruby-full coreutils mosh ufw tmux golang-go ripgrep \
    libffi-dev \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    liblzma-dev \
    libgdbm-dev \
    libnss3-dev \
    libgdbm-compat-dev \
    ca-certificates \
    libssl1.1

ENV PATH="/root/.pyenv/bin:/root/.pyenv/shims:${PATH}"
ENV CFLAGS="-I$(brew --prefix openssl)/include"
ENV LDFLAGS="-L$(brew --prefix openssl)/lib"

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
     (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /root/.bashrc && \
     eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


# Install Neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz && \
    tar -C /opt -xzf nvim-linux64.tar.gz && \
    rm nvim-linux64.tar.gz && \
    ln -s /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim && \
    echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> /root/.bashrc

RUN pipx install poetry && \
    pipx ensurepath

RUN echo 'export PATH="$PATH:/root/.local/bin"' >> /root/.bashrc

RUN echo 'vi() { \
  local file="$1"; \
  if grep -q "tool.poetry" pyproject.toml; then \
    if [[ -n "$file" ]]; then \
      poetry run nvim "$file"; \
    else \
      poetry run nvim; \
    fi; \
  else \
    if [[ -n "$file" ]]; then \
      nvim "$file"; \
    else \
      nvim; \
    fi; \
  fi; \
}' >> /root/.bashrc


# Get some fonts for icons in nvim
RUN mkdir temp_fonts/ && \
    cd temp_fonts/ && \
    curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz && \
    tar -xf JetBrainsMono.tar.xz -C /root/../usr/local/share/fonts/ && \
    rm -rf JetBrainsMono.tar.xz && \
    cd ~ && \
    rm -rf temp_fonts/


# Set environment variables and aliases
RUN echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> /root/.bashrc && \
    echo 'alias vi="nvim"' >> /root/.bashrc && \
    echo 'alias python="python3"' >> /root/.bashrc && \
    echo 'alias venvcreate="python -m venv venv"' >> /root/.bashrc && \
    echo 'alias venvactivate="source venv/bin/activate"' >> /root/.bashrc && \
    echo 'alias tks="tmux kill-server"' >> /root/.bashrc && \
    # tell tmux to assume utf-8 encoding on font
    echo 'alias tmux="tmux -u"' >> /root/.bashrc && \
    echo 'alias reload="source ~/.bashrc"' >> /root/.bashrc && \
    echo 'alias la="ls -a"' >> /root/.bashrc && \
    echo 'alias filesizes="du -h"' >> /root/.bashrc && \
    echo 'alias pfreqs="pip freeze > requirements.txt"' >> /root/.bashrc && \
    echo 'alias vip="nvim --noplugins"' >> /root/.bashrc && \
    echo 'alias pireqs="pip install -r requirements.txt"' >> /root/.bashrc && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> /root/.bashrc && \
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> /root/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> /root/.bashrc


# Install pyenv and pynvim
RUN mkdir /root/.pyenv && git clone https://github.com/pyenv/pyenv.git /root/.pyenv && \
    cd /root/.pyenv && src/configure && make -C src && \
    pipx install ptipython --include-deps && \
    pipx ensurepath && \
    export PATH="/root/.pyenv/bin:$PATH" && \
    export PATH="/root/.local/bin:$PATH" && \
    pyenv install 3.10.11 && \
    pyenv global 3.10.11





## Clone and set up dotfiles

# note that it clones the dotfiles repo into the volume_data directory
# and then, tells both neovim and tmux to look IN the volume_data directory for their respective config files
# this is because this volume_data directory is a volume which is persisted even after the containers are destroyed
# note that there exists a ./volume_data directory in the same directory as this Dockerfile purely for the purposes of enabling the build of the docker image. the ./volume_data directory is not synced with git. there's no real need to pay attention to it.

RUN git clone https://github.com/rossamurphy/dotfiles /root/dotfiles/ && \
    cp -a /root/dotfiles/.config/ /root/.config/ && \
    chown -R root:root /root/.config




RUN dircolors --print-database > /root/.dir_colors
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



# Set environment variable for Neovim
ENV XDG_CONFIG_HOME="/root/.config/"
ENV TMUX_CONF="/root/.config/tmux/tmux.conf"
ENV PATH="/opt/nvim-linux64/bin:$PATH"



# set up neovim for this image and install plugins

# RUN nvim --noplugin --headless -c "source /root/.config/nvim/lua/rawdog/init.lua" +q 
# RUN nvim --noplugins --headless -c 'source /root/.config/nvim/lua/rawdog/packer.lua' -c ' autocmd User PackerComplete quitall' -c 'PackerSync'
# RUN nvim --noplugins --headless -c 'source /root/.config/nvim/lua/rawdog/packer.lua' -c 'PackerCompile'

CMD ["bash"]

