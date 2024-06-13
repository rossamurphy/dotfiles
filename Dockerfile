FROM debian:latest 

# Set the working directory in the container
WORKDIR /root

# Install dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget sudo gnupg curl build-essential nodejs npm unzip software-properties-common python3-pip python3-venv python3-virtualenv pipx git ruby-full coreutils mosh ufw tmux golang-go ripgrep \
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
    poppler-utils \
    libreoffice \
    pandoc \
    libmagic-dev \
    libgl1 \
    tesseract-ocr \
    libpq-dev

RUN wget --no-check-certificate https://dl.xpdfreader.com/xpdf-tools-linux-4.05.tar.gz && \
    tar -xvf xpdf-tools-linux-4.05.tar.gz && \
    cp xpdf-tools-linux-4.05/bin64/pdftotext /usr/local/bin && \
    rm -rf xpdf-tools-linux-4.05.tar.gz

ENV TESSDATA_PREFIX=/usr/local/share/tessdata

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

# get brew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
     (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /root/.bashrc && \
     eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


# Install Neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz && \
    tar -C /opt -xzf nvim-linux64.tar.gz && \
    rm nvim-linux64.tar.gz && \
    ln -s /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim && \
    echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> /root/.bashrc

ENV PATH="/root/.pyenv/bin:/root/.pyenv/shims:${PATH}"
ENV CFLAGS="-I$(brew --prefix openssl)/include"
ENV LDFLAGS="-L$(brew --prefix openssl)/lib"


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
    # tell tmux to assume utf-8 encoding on font
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





## Clone and set up dotfiles

# note that it clones the dotfiles repo into the volume_data directory
# and then, tells both neovim and tmux to look IN the volume_data directory for their respective config files
# this is because this volume_data directory is a volume which is persisted even after the containers are destroyed
# note that there exists a ./volume_data directory in the same directory as this Dockerfile purely for the purposes of enabling the build of the docker image. the ./volume_data directory is not synced with git. there's no real need to pay attention to it.

RUN git clone https://github.com/rossamurphy/dotfiles /root/dotfiles/ && \
    cp -a /root/dotfiles/.config/ /root/.config/ && \
    chown -R root:root /root/.config



RUN dircolors --print-database > /root/.dir_colors


# Set environment variable for Neovim
ENV XDG_CONFIG_HOME="/root/.config/"
ENV TMUX_CONF="/root/.config/tmux/tmux.conf"
ENV PATH="/opt/nvim-linux64/bin:$PATH"



# set up neovim for this image and install plugins

# RUN nvim --noplugin --headless -c "source /root/.config/nvim/lua/rawdog/init.lua" +q 
# RUN nvim --noplugins --headless -c 'source /root/.config/nvim/lua/rawdog/packer.lua' -c ' autocmd User PackerComplete quitall' -c 'PackerSync'
# RUN nvim --noplugins --headless -c 'source /root/.config/nvim/lua/rawdog/packer.lua' -c 'PackerCompile'

CMD ["bash"]

