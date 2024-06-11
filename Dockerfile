FROM debian:latest 

# Set the working directory in the container
WORKDIR /root

# Install dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget sudo gnupg curl build-essential nodejs npm unzip software-properties-common python3-pip python3-venv python3-virtualenv pipx git ruby-full coreutils mosh ufw tmux golang-go ripgrep

# Install Neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz && \
    tar -C /opt -xzf nvim-linux64.tar.gz && \
    rm nvim-linux64.tar.gz && \
    ln -s /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim && \
    echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> /root/.bashrc

# Set environment variables and aliases
RUN echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> /root/.bashrc && \
    echo 'alias vi="nvim"' >> /root/.bashrc && \
    echo 'alias python="python3"' >> /root/.bashrc && \
    echo 'alias venvcreate="python -m venv venv"' >> /root/.bashrc && \
    echo 'alias venvactivate="source venv/bin/activate"' >> /root/.bashrc && \
    echo 'alias tks="tmux kill-server"' >> /root/.bashrc && \
    echo 'alias reload="source ~/.bashrc"' >> /root/.bashrc && \
    echo 'alias la="ls -a"' >> /root/.bashrc && \
    echo 'alias filesizes="du -h"' >> /root/.bashrc && \
    echo 'alias pfreqs="pip freeze > requirements.txt"' >> /root/.bashrc && \
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
    pyenv install 3.11.0 && \
    pyenv global 3.11.0


## Clone and set up dotfiles

# note that it clones the dotfiles repo into the volume_data directory
# and then, tells both neovim and tmux to look IN the volume_data directory for their respective config files
# this is because this volume_data directory is a volume which is persisted even after the containers are destroyed
# note that there exists a ./volume_data directory in the same directory as this Dockerfile purely for the purposes of enabling the build of the docker image. the ./volume_data directory is not synced with git. there's no real need to pay attention to it.

RUN git clone https://github.com/rossamurphy/dotfiles /root/dotfiles/ && \
    cp -a /root/dotfiles/.config/ /root/.config/ && \
    chown -R root:root /root/.config/

# Set environment variable for Neovim
ENV XDG_CONFIG_HOME=/.config/
ENV TMUX_CONF=/.config/tmux/tmux.conf
ENV PATH="/opt/nvim-linux64/bin:$PATH"

# set up neovim for this image and install plugins
# sleep between each aynchronous step to allow the step to complete
# name this step the nvim init step

RUN nvim /.config/nvim/lua/rawdog/init.lua --headless +so +qall
RUN sleep 20
RUN nvim /.config/nvim/lua/rawdog/packer.lua --headless +so +qall
RUN sleep 20
RUN nvim /.config/nvim/lua/rawdog/packer.lua --headless +PackerInstall +qall
RUN sleep 15
RUN nvim /.config/nvim/lua/rawdog/packer.lua --headless +PackerSync +qall
RUN sleep 10
RUN nvim /.config/nvim/lua/rawdog/packer.lua --headless +PackerCompile +qall
RUN sleep 10

# Command to run when the container starts
CMD ["bash"]

