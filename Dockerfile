FROM debian:latest

# Set the working directory in the container
WORKDIR /root

# Install wget first
RUN apt-get update && apt-get install -y wget

# Download and install gcc-10-base
RUN wget http://mirrors.edge.kernel.org/ubuntu/pool/main/g/gcc-10/gcc-10-base_10-20200411-0ubuntu1_amd64.deb && \
    dpkg -i ./gcc-10-base_10-20200411-0ubuntu1_amd64.deb && \
    rm ./gcc-10-base_10-20200411-0ubuntu1_amd64.deb

# Install dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y sudo gnupg curl build-essential nodejs npm unzip software-properties-common python3-pip python3-venv python3-virtualenv pipx git ruby-full coreutils mosh ufw tmux golang-go ripgrep \
    apt-utils \
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
    kmod \
    pkg-config \
    libxext-dev \
    x11proto-gl-dev \
    pandoc \
    libmagic-dev \
    libgl1 \
    libpq-dev

# Install locales and set up en_GB.UTF-8 (for mosh)
RUN apt-get update && apt-get install -y locales
RUN sed -i '/en_GB.UTF-8/s/^# //' /etc/locale.gen && \
    locale-gen en_GB.UTF-8 && \
    update-locale LANG=en_GB.UTF-8 LC_ALL=en_GB.UTF-8
ENV LANG=en_GB.UTF-8
ENV LC_ALL=en_GB.UTF-8

# get NVIDIA container toolkit ( from https://docs.nvidia.com/ai-enterprise/deployment-guide-vmware/0.1.0/docker.html )
RUN curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list


# get NVIDIA drivers ( from https://github.com/NVIDIA/nvidia-docker/issues/871 )
ARG nvidia_binary_version="470.57.02"
ARG nvidia_binary="NVIDIA-Linux-x86_64-${nvidia_binary_version}.run"
RUN wget -q https://us.download.nvidia.com/XFree86/Linux-x86_64/${nvidia_binary_version}/${nvidia_binary} && \
    chmod +x ${nvidia_binary} && \
    ./${nvidia_binary} --accept-license --ui=none --no-kernel-module --no-questions && \
    rm -rf ${nvidia_binary}


RUN sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list

RUN apt-get update

RUN apt-get install -y nvidia-container-toolkit

# Create a non-root user for Homebrew
RUN useradd -m -s /bin/bash brewuser && \
    echo 'brewuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install Homebrew as non-root user
USER brewuser
WORKDIR /home/brewuser
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
    echo 'eval "$(/home/brewuser/.linuxbrew/bin/brew shellenv)"' >> /home/brewuser/.bashrc && \
    eval "$(/home/brewuser/.linuxbrew/bin/brew shellenv)"

# Switch back to root
USER root
WORKDIR /root

# Make Homebrew available to root
RUN echo 'export PATH="/home/brewuser/.linuxbrew/bin:$PATH"' >> /root/.bashrc && \
    ln -s /home/brewuser/.linuxbrew/bin/brew /usr/local/bin/brew

# Set environment variables for openssl
ENV PATH="/home/brewuser/.linuxbrew/bin:${PATH}"
ENV CFLAGS="-I$(brew --prefix openssl)/include"
ENV LDFLAGS="-L$(brew --prefix openssl)/lib"

# Install Neovim with specific version instead of latest
RUN curl -L -o nvim.tar.gz https://github.com/neovim/neovim/releases/download/v0.11.0/nvim-linux-x86_64.tar.gz && \
    mkdir -p /opt/nvim && \
    tar -xzf nvim.tar.gz -C /opt && \
    rm nvim.tar.gz && \
    ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim && \
    echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> /root/.bashrc

# Clone Packer to the correct location
RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim

ENV PATH="/root/.pyenv/bin:/root/.pyenv/shims:${PATH}"

RUN pipx install poetry && \
    pipx ensurepath

RUN echo 'export PATH="$PATH:/root/.local/bin"' >> /root/.bashrc

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
    echo 'alias python="python3"' >> /root/.bashrc && \
    echo 'alias venvcreate="python -m venv venv"' >> /root/.bashrc && \
    echo 'alias venvactivate="source venv/bin/activate"' >> /root/.bashrc && \
    echo 'alias tks="tmux kill-server"' >> /root/.bashrc && \
    echo 'alias vi="nvim"' >> /root/.bashrc && \
    echo 'alias tmux="tmux -u"' >> /root/.bashrc && \
    echo 'alias reload="source ~/.bashrc"' >> /root/.bashrc && \
    echo 'alias la="ls -a"' >> /root/.bashrc && \
    echo 'alias filesizes="du -h"' >> /root/.bashrc && \
    echo 'alias pfreqs="pip freeze > requirements.txt"' >> /root/.bashrc && \
    echo 'alias vip="nvim --noplugins"' >> /root/.bashrc && \
    echo 'alias ppp="poetry run ptipython"' >> /root/.bashrc && \
    echo 'alias pireqs="pip install -r requirements.txt"' >> /root/.bashrc && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> /root/.bashrc && \
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> /root/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> /root/.bashrc && \
    echo 'export PYTHONBREAKPOINT="pudb.set_trace"' >> /root/.bashrc && \
    echo 'alias ls="ls --color=auto"' >> /root/.bashrc

# google sdk
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && apt-get update -y && apt-get install google-cloud-sdk -y

# aws sdk
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    sudo ./aws/install && \
    rm awscliv2.zip && \
    rm -rf aws/


# Install pyenv and pynvim
RUN mkdir /root/.pyenv && git clone https://github.com/pyenv/pyenv.git /root/.pyenv && \
    cd /root/.pyenv && src/configure && make -C src && \
    pipx install ptipython --include-deps && \
    pipx ensurepath && \
    export PATH="/root/.pyenv/bin:$PATH" && \
    export PATH="/root/.local/bin:$PATH" && \
    pyenv install 3.10.11 && \
    pyenv global 3.10.11

# After your pipx install commands
RUN echo 'export PATH="$PATH:/root/.local/bin"' >> /root/.bashrc && \
    export PATH="$PATH:/root/.local/bin" && \
    pipx ensurepath


# https://github.com/TheR1D/shell_gpt
RUN pip install shell-gpt

## Clone and set up dotfiles
RUN git clone https://github.com/rossamurphy/dotfiles /root/dotfiles/ && \
    cp -a /root/dotfiles/.config/ /root/.config/ && \
    chown -R root:root /root/.config

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install gh -y

# Install tree-sitter CLI
RUN npm install -g tree-sitter-cli

# Install NVM and Node.js 22.14.0
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    nvm install 22.14.0 && \
    nvm use 22.14.0 && \
    nvm alias default 22.14.0

# Add NVM to .bashrc for future sessions
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> /root/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /root/.bashrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /root/.bashrc

RUN dircolors --print-database > /root/.dir_colors

# Set environment variable for Neovim
ENV XDG_CONFIG_HOME="/root/.config/"
ENV TMUX_CONF="/root/.config/tmux/tmux.conf"
ENV PATH="/opt/nvim-linux64/bin:$PATH"

# Add this line to your Dockerfile
# set the password for the ssh service
RUN echo "root:password" | chpasswd

# Install SSH server
# Install SSH server
RUN apt-get update && apt-get install -y openssh-server && \
    mkdir -p /run/sshd

# Generate SSH host keys and ensure SSH is running properly
RUN mkdir -p /etc/ssh && \
    ssh-keygen -A && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "Port 22" >> /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config && \
    echo "X11Forwarding yes" >> /etc/ssh/sshd_config && \
    echo "ListenAddress 0.0.0.0" >> /etc/ssh/sshd_config

# Create a proper start script that keeps the container running
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'echo "Starting SSH daemon..."' >> /start.sh && \
    echo '/usr/sbin/sshd -D &' >> /start.sh && \
    echo 'echo "SSH daemon started with PID $!"' >> /start.sh && \
    echo 'tail -f /dev/null' >> /start.sh && \
    chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
