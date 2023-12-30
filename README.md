# My own configuration for Mac

> [!IMPORTANT]
> Before running script install [brew](https://brew.sh/).

To install the whole configs run:

```sh
wget -O main.zip https://github.com/arzamaskov/environment/archive/refs/heads/main.zip && unzip main.zip -d dotfiles && cd dotfiles/environment-main && ./install.sh && cd ~ && rm -rf main.zip dotfiles
```

To install only Neovim configs run:

```sh
wget -O main.zip https://github.com/arzamaskov/environment/archive/refs/heads/main.zip && unzip main.zip -d dotfiles && cd dotfiles/environment-main && ./install_vim.sh && cd ~ && rm -rf main.zip dotfiles
```

## Applications

- appcleaner
- cyberduck
- firefox
- flameshot
- httpie
- itsycal
- kitty
- libreoffice
- numi
- nvalt
- obsidian
- slack
- telegram
- transmission
- tunnelblick
- vlc

## Packages

```
aom apr apr-util aspell autoconf automake bat bison brotli c-ares ca-certificates coreutils cscope curl dnsmasq exercism fontconfig freetype fzf gd gettext giflib git gmp gnu-getopt gnu-sed gnupg gnutls helix highway htop icu4c imath insect jansson jpeg jpeg-turbo jpeg-xl krb5 libassuan libavif libcbor libedit libevent libfido2 libgcrypt libgit2 libgpg-error libiconv libidn2 libksba libnghttp2 libpng libsodium libssh2 libtasn1 libtermkey libtiff libunistring libusb libuv libvmaf libvterm libxml2 libxmlsec1 libyaml libzip little-cms2 lua luajit luv lz4 m4 mailhog mkcert mpdecimal msgpack mysql ncdu ncurses neovim nettle nginx npth nspr nss oath-toolkit oniguruma openexr openldap openssl@1.1 openssl@3 p11-kit pass pass-otp pcre2 pinentry pkg-config protobuf@21 pygments python-certifi python@3.11 python@3.12 qrencode re2c readline ripgrep rtmpdump ruby smartmontools sqlite tree tree-sitter unbound unibilium webp wget xz zlib zstd
```
## Vim configs

Leader key: `Space`

- Open filemanager: `<leader><space>`
- Find files: `<leader>sf`
- Find recently opened files: `<leader>?`
- Find buffers: `<leader>;`
- Find by grep: `<leader>f`
- Find current word by grep: `<leader>F`
- Fuzzy search in current buffer: `<leader>/`
- Find Telescope builtins: `<leader>ss`

- Copy to the system clipboard: `<leader>y`
- Paste from the system clipboard: `<leader>p`
- Split or join current line: `<leader>j`
- Move to the last insertion and insert: `gi`
- Switch to VISUAL using last selection: `gv`
- Lowercase: `gu`
- Uppercase: `gU`

- Toggle undo-tree: `<leader>u`
- Close current buffer: `<leader>q`
- Go to the next buffer: `gn`
- Go to the previous buffer: `gp`
- Go to previous end of word: `ge`

- Open floating diagnostic message: `<leader>e`
- Open document diagnostic list: `<leader>dq`
- Open document diagnostic messages: `<leader>xx`
- Open document symbols: `<leader>ds`
- Format code: `<leader>cf`
- Code actions: `<leader>ca`
- Rename: `<leader>rn`

- Go to definition: `gd`
- Go to declaration: `gD`
- Go to implementation: `gI`
- Go to references: `gr`

- Find git commit: `<leader>gc`
- Search by git status: `<leader>gs`
- Git hunk preview: `<leader>hp`
- Toggle line blame: `<leader>lb`

- Comment line: `gcc`
- Comment blockwise: `gbc`
