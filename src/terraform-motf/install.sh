#!/bin/bash
set -e

echo "Activating feature 'terraform-motf'"

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

install_motf() {
    local version="${VERSION:-latest}"
    if [ "${version}" = "latest" ]; then
        version="$(resolve_latest TechnicallyJoe/terraform-motf)"
    fi
    # tags use 'v' prefix but archive filenames use bare version
    version="v${version#v}"
    local bare_version="${version#v}"

    echo "Installing motf ${version}..."

    local tmpdir
    tmpdir="$(mktemp -d)"
    local url="https://github.com/TechnicallyJoe/terraform-motf/releases/download/${version}/motf_${bare_version}_linux_${ARCH}.tar.gz"
    curl -fsSL "${url}" | tar xz -C "${tmpdir}"
    cp "${tmpdir}/motf" /usr/local/bin/motf
    chmod +x /usr/local/bin/motf
    rm -rf "${tmpdir}"

    echo "motf ${version} installed successfully"
}

install_motf

echo "terraform-motf installation complete."
