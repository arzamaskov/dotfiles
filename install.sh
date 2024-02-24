#!/usr/bin/env bash
set -euo pipefail

# Constants
GREEN='\033[32m'
RED='\033[31m'
NC='\033[0m'  # No Color

packages="aom apr apr-util aspell autoconf automake bat bison brotli c-ares ca-certificates coreutils cscope curl dnsmasq exercism fontconfig freetype fzf gd gettext giflib git gmp gnu-getopt gnu-sed gnupg gnutls helix highway htop icu4c imath insect jansson jpeg jpeg-turbo jpeg-xl krb5 libassuan libavif libcbor libedit libevent libfido2 libgcrypt libgit2 libgpg-error libiconv libidn2 libksba libnghttp2 libpng libsodium libssh2 libtasn1 libtermkey libtiff libunistring libusb libuv libvmaf libvterm libxml2 libxmlsec1 libyaml libzip little-cms2 lua luajit luv lz4 m4 mailhog mkcert mpdecimal msgpack mysql ncdu ncurses neovim nettle nginx npth nspr nss oath-toolkit oniguruma openexr openldap openssl@1.1 openssl@3 p11-kit pass pass-otp pcre2 pinentry pkg-config protobuf@21 pygments python-certifi python@3.11 python@3.12 qrencode re2c readline ripgrep rtmpdump ruby smartmontools sqlite tree tree-sitter unbound unibilium webp wget xz zlib zstd"

casks="appcleaner cyberduck firefox flameshot httpie itsycal kitty libreoffice numi nvalt obsidian slack telegram transmission tunnelblick vlc"

echo -e "Installing packages..."
for package in $packages; do
    echo "Installing $package"
    if ! brew list "$package" > /dev/null 2>&1; then
        brew install "$package" || { echo -e "${RED}ERROR${NC}: Failed to install ${package}."; exit 1; };
    fi
done

for cask in $casks; do
    echo "Installing $cask"
    if ! brew list "$cask" > /dev/null 2>&1; then
        brew install --cask "$cask" || { echo -e "${RED}ERROR${NC}: Failed to install ${package}."; exit 1; };
    fi
done
echo -e "${GREEN}Done.${NC}"

local config_dirs="$HOME/.config $HOME/.zsh_functions $HOME/.local/bin $HOME/Develop/environment"
local zsh_functions_dir="$HOME/.zsh_functions"
local local_bin_dir="$HOME/.local/bin"
local develop_env_dir="$HOME/Develop/environment"

echo -e "Copying configs..."
mkdir -p ${zsh_functions_dir} ${local_bin_dir}
cp -R "${develop_env_dir}/zsh_functions/"* "${zsh_functions_dir}/"
cp -R "${develop_env_dir}/bin/"* "${local_bin_dir}/"
cp "${develop_env_dir}/zshrc" "$HOME/.zshrc"
cp "${develop_env_dir}/ripgreprc" "$HOME/.ripgreprc"
cp "${develop_env_dir}/rgignore" "$HOME/.rgignore"
cp "${develop_env_dir}/gitconfig" "$HOME/.gitconfig"
cp "${develop_env_dir}/tool-versions" "$HOME/.tool-versions"

cd $config_dir;
mkdir -p bat git kitty nvim
cp "${develop_env_dir}/gitignore" "$CONFIG_DIR/git/ignore"
cp "${develop_env_dir}/batconfig" "$CONFIG_DIR/bat/config"
cp "${develop_env_dir}/kittyconf" "$CONFIG_DIR/kitty/kitty.conf"
cp -R "${develop_env_dir}/nvim/"* "$CONFIG_DIR/nvim/"
echo -e "${GREEN}Done.${NC}"


echo -e "Installing asdf..."
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
cd ~/.asdf
git checkout "$(git describe --abbrev=0 --tags)"
echo -e "${GREEN}Done.${NC}"

echo -e "Installing asdf plugins..."
asdf plugin-add yarn
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin-add ruby
asdf plugin-add php https://github.com/asdf-community/asdf-php.git
asdf plugin-add racket https://github.com/vic/asdf-racket.git
asdf install
echo -e "${GREEN}Done.${NC}"

echo -e "Installing Oh-My-Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo -e "${GREEN}Done.${NC}"
