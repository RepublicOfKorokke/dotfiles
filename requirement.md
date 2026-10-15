# Requirement for this conf

## vivid

https://github.com/sharkdp/vivid

```bash
wget "https://github.com/sharkdp/vivid/releases/download/v0.8.0/vivid_0.8.0_amd64.deb"
sudo dpkg -i vivid_0.8.0_amd64.deb
```

```bash
brew install vivid
```

## FZF

```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

## tmux

```
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure
make && sudo make install
```

## nvim

### Debian-based

```
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
tar xzvf nvim-linux64.tar.gz
mv nvim-linux64/ ~/bin/
```

```
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-macos.tar.gz
xattr -c ./nvim-macos.tar.gz (to avoid "unknown developer" warning)
tar xzvf nvim-macos.tar.gz
mv nvim-macos/ ~/bin/
```

## bat

```
wget https://github.com/sharkdp/bat/releases/download/v0.23.0/bat_0.23.0_amd64.deb
sudo dpkg -i bat_0.23.0_amd64.deb
```

```
brew install bat
```

## ripgrep

```
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
sudo dpkg -i ripgrep_13.0.0_amd64.deb
```

```
brew install ripgrep
```

## fd

```
curl -LO https://github.com/sharkdp/fd/releases/download/v8.7.0/fd_8.7.0_amd64.deb
sudo dpkg -i fd_8.7.0_amd64.deb
```

```
brew install fd
```

## nvim LSP / Formatter

mason は使わず、ネイティブ系は Homebrew / uv / rustup、JS/TS 系は bun で管理する。
詳細は [nvim/docs/lsp.md](nvim/docs/lsp.md) を参照。

インストール:

```
nvim/scripts/install-lsp.sh
```
