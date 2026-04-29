#!/bin/bash
set -e

echo "Activating feature 'neovim-tools'"

# Ensure curl is available
if ! command -v curl > /dev/null 2>&1; then
    apt-get update -y && apt-get install -y --no-install-recommends curl ca-certificates
fi

detect_arch() {
    local arch
    arch="$(uname -m)"
    case "${arch}" in
        x86_64)  echo "amd64" ;;
        aarch64) echo "arm64" ;;
        *)       echo "Unsupported architecture: ${arch}" >&2; exit 1 ;;
    esac
}

resolve_latest() {
    local repo="$1"
    curl -fsSL "https://api.github.com/repos/${repo}/releases/latest" \
        | grep '"tag_name"' \
        | sed -E 's/.*"tag_name":\s*"([^"]+)".*/\1/'
}

ARCH="$(detect_arch)"

# --- neovim ---
install_neovim() {
    local version="${NEOVIMVERSION:-latest}"
    if [ "${version}" = "latest" ]; then
        version="$(resolve_latest neovim/neovim)"
    fi
    echo "Installing neovim ${version}..."

    local nvim_arch
    case "${ARCH}" in
        amd64) nvim_arch="x86_64" ;;
        arm64) nvim_arch="arm64" ;;
    esac

    local url="https://github.com/neovim/neovim/releases/download/${version}/nvim-linux-${nvim_arch}.tar.gz"
    curl -fsSL "${url}" | tar xz -C /usr/local --strip-components=1

    echo "neovim ${version} installed successfully"
}

# --- ripgrep ---
install_ripgrep() {
    local version="${RIPGREPVERSION:-latest}"
    if [ "${version}" = "latest" ]; then
        version="$(resolve_latest BurntSushi/ripgrep)"
    fi
    echo "Installing ripgrep ${version}..."

    local rg_arch
    case "${ARCH}" in
        amd64) rg_arch="x86_64-unknown-linux-musl" ;;
        arm64) rg_arch="aarch64-unknown-linux-gnu" ;;
    esac

    local tmpdir
    tmpdir="$(mktemp -d)"
    local url="https://github.com/BurntSushi/ripgrep/releases/download/${version}/ripgrep-${version}-${rg_arch}.tar.gz"
    curl -fsSL "${url}" | tar xz -C "${tmpdir}"
    cp "${tmpdir}/ripgrep-${version}-${rg_arch}/rg" /usr/local/bin/rg
    chmod +x /usr/local/bin/rg
    rm -rf "${tmpdir}"

    echo "ripgrep ${version} installed successfully"
}

# --- fzf ---
install_fzf() {
    local version="${FZFVERSION:-latest}"
    if [ "${version}" = "latest" ]; then
        version="$(resolve_latest junegunn/fzf)"
    fi
    echo "Installing fzf ${version}..."

    # fzf tags use 'v' prefix but archive filenames use bare version
    local bare_version="${version#v}"

    local fzf_arch
    case "${ARCH}" in
        amd64) fzf_arch="linux_amd64" ;;
        arm64) fzf_arch="linux_arm64" ;;
    esac

    local url="https://github.com/junegunn/fzf/releases/download/${version}/fzf-${bare_version}-${fzf_arch}.tar.gz"
    curl -fsSL "${url}" | tar xz -C /usr/local/bin

    echo "fzf ${version} installed successfully"
}

install_neovim
install_ripgrep
install_fzf

echo "Neovim tools installation complete."
