#!/usr/bin/env bash
# Bootstrap a fresh Ubuntu VM with neovim + tmux + this repo's config.
# Usage: git clone https://github.com/rossamurphy/dotfiles && cd dotfiles && ./create.sh

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
NVIM_VERSION="${NVIM_VERSION:-stable}"  # e.g. "v0.11.0" or "stable"

log() { printf '\n\033[1;34m==>\033[0m %s\n' "$*"; }

if [[ "$(uname -s)" != "Linux" ]]; then
    echo "This script targets Ubuntu/Linux. Detected: $(uname -s)" >&2
    exit 1
fi

SUDO=""
if [[ $EUID -ne 0 ]]; then
    if ! command -v sudo >/dev/null; then
        echo "Need root or sudo." >&2; exit 1
    fi
    SUDO="sudo"
fi

# ---------- apt packages ----------
log "Installing apt packages"
export DEBIAN_FRONTEND=noninteractive
$SUDO apt-get update -y
$SUDO apt-get install -y --no-install-recommends \
    ca-certificates curl wget git unzip xz-utils \
    build-essential pkg-config \
    tmux ripgrep fd-find \
    python3 python3-pip python3-venv \
    nodejs npm \
    locales

# en_GB locale (matches the old Docker setup; harmless if unused)
if ! locale -a | grep -qiE '^en_GB\.utf-?8$'; then
    $SUDO sed -i '/en_GB.UTF-8/s/^# //' /etc/locale.gen || true
    $SUDO locale-gen en_GB.UTF-8 || true
fi

# ---------- neovim ----------
log "Installing neovim ($NVIM_VERSION)"
arch="$(uname -m)"
case "$arch" in
    x86_64|amd64) nvim_asset="nvim-linux-x86_64.tar.gz" ;;
    aarch64|arm64) nvim_asset="nvim-linux-arm64.tar.gz" ;;
    *) echo "Unsupported arch: $arch" >&2; exit 1 ;;
esac

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
curl -fL --retry 3 -o "$tmpdir/nvim.tar.gz" \
    "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${nvim_asset}"
$SUDO rm -rf /opt/nvim /opt/nvim-linux-x86_64 /opt/nvim-linux-arm64
$SUDO tar -C /opt -xzf "$tmpdir/nvim.tar.gz"
$SUDO ln -sfn "/opt/${nvim_asset%.tar.gz}" /opt/nvim
$SUDO ln -sfn /opt/nvim/bin/nvim /usr/local/bin/nvim

# ---------- dotfiles: copy .config ----------
log "Copying .config to $HOME/.config"
mkdir -p "$HOME/.config"
for dir in nvim tmux; do
    src="$SCRIPT_DIR/.config/$dir"
    dst="$HOME/.config/$dir"
    if [[ -d "$src" ]]; then
        if [[ -e "$dst" && ! -L "$dst" ]]; then
            mv "$dst" "$dst.bak.$(date +%s)"
        fi
        cp -a "$src" "$dst"
    fi
done

# ---------- bashrc extras ----------
log "Appending aliases to ~/.bashrc (once)"
marker="# >>> dotfiles create.sh <<<"
if ! grep -Fq "$marker" "$HOME/.bashrc" 2>/dev/null; then
    cat >> "$HOME/.bashrc" <<'EOF'

# >>> dotfiles create.sh <<<
export PATH="/opt/nvim/bin:$HOME/.local/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
alias vi="nvim"
alias vip="nvim --noplugins"
alias tmux="tmux -u"
alias tks="tmux kill-server"
alias reload="source ~/.bashrc"
alias la="ls -a"
alias ls="ls --color=auto"
# <<< dotfiles create.sh >>>
EOF
fi

# ---------- python + node neovim providers ----------
log "Installing nvim language providers (python, node)"
python3 -m pip install --user --upgrade --break-system-packages pynvim 2>/dev/null \
    || python3 -m pip install --user --upgrade pynvim
$SUDO npm install -g neovim tree-sitter-cli 2>/dev/null || true

# ---------- pre-warm lazy.nvim plugins ----------
log "Headless nvim: bootstrapping lazy.nvim plugins (may take a minute)"
/usr/local/bin/nvim --headless "+Lazy! sync" +qa || true

log "Done."
cat <<EOF

Next steps:
  - Start a new shell (or: source ~/.bashrc) so nvim/aliases are on PATH.
  - Run: nvim   (lazy.nvim will finish anything it missed)
  - Run: :checkhealth   inside nvim to verify providers.

EOF
