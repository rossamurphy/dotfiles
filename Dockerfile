FROM debian:latest 

# Set the working directory in the container
WORKDIR /root

# Install dependencies
RUN apt-get update && apt-get upgrade && \
    apt-get install -y wget sudo gnupg curl build-essential nodejs npm unzip software-properties-common python3-pip python3-venv python3-virtualenv pipx git ruby-full coreutils mosh ufw && \
    # wget http://mirrors.edge.kernel.org/ubuntu/pool/main/g/gcc-10/gcc-10-base_10-20200411-0ubuntu1_amd64.deb && \
    # dpkg -i gcc-10-base_10-20200411-0ubuntu1_amd64.deb && \
    apt-get update && \
    apt-get install -y golang-go ripgrep

# Install Neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz && \
    tar -C /opt -xzf nvim-linux64.tar.gz && \
    rm -rf nvim-linux64.tar.gz && \
    echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc


# Set environment variables and aliases
RUN echo 'export PATH="/opt/nvim-linux64/bin:$PATH"' >> ~/.bashrc && \
    echo 'alias vi="nvim"' >> ~/.bashrc && \
    echo 'alias python="python3"' >> ~/.bashrc && \
    echo 'alias venvcreate="python -m venv venv"' >> ~/.bashrc && \
    echo 'alias venvactivate="source venv/bin/activate"' >> ~/.bashrc && \
    echo 'alias tks="tmux kill-server"' >> ~/.bashrc && \
    echo 'alias reload="source ~/.bashrc"' >> ~/.bashrc && \
    echo 'alias la="ls -a"' >> ~/.bashrc && \
    echo 'alias filesizes="du -h"' >> ~/.bashrc && \
    echo 'alias pfreqs="pip freeze > requirements.txt"' >> ~/.bashrc && \
    echo 'alias pireqs="pip install -r requirements.txt"' >> ~/.bashrc && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# Install pyenv and pynvim
RUN mkdir ~/.pyenv && git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
    cd ~/.pyenv && src/configure && make -C src && \
    pipx install ptipython --include-deps && \
    pipx ensurepath && \
    export PATH="/root/.pyenv/bin:$PATH" && \
    export PATH="/root/.local/bin:$PATH" && \
    pyenv install 3.11.0 && \
    pyenv global 3.11.0

# Clone and set up dotfiles
RUN git clone https://github.com/rossamurphy/dotfiles && \
    mkdir -p ~/.config && \
    cp -a ~/dotfiles/.config/. ~/.config && \
    chown -R root:root ~/ && \
    chown -R root:root ~/.config/nvim

# Set up permissions for Packer and nvim
RUN chown -R root:root ~/.local && \
    chown root ~/.config/nvim/plugin && \
    chown -R root:root ~/


# Command to run when the container starts
CMD ["bash"]


