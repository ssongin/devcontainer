# Devcontainer

## Description

Archlinux container with pre installed packages used for development. Uses LazyVim editor. Imports configuration files from [Dotfiles](https://github.com/ssongin/dotfiles) repository. Main purpose to use for ansible under Windows. Although contains development tools for Golang and Java.

## Usage

### Docker compose

> [!IMPORTANT]
> Don't forget to change shared folders and working dir path in docker compose file (user name included).

> [!NOTE]
> Windows files and folders don't have proper owner and access rights. So, command block in docker compose fixes that.

Docker compose example is present [docker-compose.yaml](https://github.com/ssongin/devcontainer/blob/master/docker-compose.yaml) here.

## Packages

### Pacman

All pacman packages are present in [packages.txt](https://github.com/ssongin/devcontainer/blob/master/packages.txt) file.

#### Infrastructure

* ansible
* terraform

#### Kubernetes

* helm
* k9s
* kubectl
* kustomize

#### SDK

* go
* jdk-openjdk
* lua
* luarocks
* maven
* npm
* python-pip
* rust

#### Miscelaneous

* base-devel
* bat
* curl
* eza
* fd
* fzf
* git
* glibc
* lazygit
* neovim
* openssh
* p7zip
* ripgrep
* sshpass
* stow
* tar
* tree-sitter
* tzdata
* unzip
* wget
* yazi
* zoxide
* zsh

#### Network

* dnsutils
* net-tools
* nmap
* tcpdump
* tmux

### Pip

All pip packages are present in [pip.txt](https://github.com/ssongin/devcontainer/blob/master/pip.txt) file.

* pywinrm
* kubernetes
