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

| **Archiving** | **Infrastructure** | **Kubernetes** | **Network**   | **Miscellaneous** | **SDK**     |
|---------------|------------------|----------------|---------------|------------------|-------------|
| p7zip         | ansible           | helm           | curl          | bat              | go          |
| tar           | terraform         | k9s            | dnsutils      | base-devel       | jdk-openjdk |
| unzip         |                  | kubectl        | net-tools     | eza              | lua         |
| wget          |                  | kustomize      | nmap          | fd               | luarocks    |
|               |                  |                | openssh       | fzf              | maven       |
|               |                  |                | sshpass       | git              | npm         |
|               |                  |                | tmux          | glibc            | python-pip  |
|               |                  |                |               | lazygit          | rust        |
|               |                  |                |               | neovim           |             |
|               |                  |                |               | stow             |             |
|               |                  |                |               | tree-sitter      |             |
|               |                  |                |               | tzdata           |             |
|               |                  |                |               | yazi             |             |
|               |                  |                |               | zoxide           |             |
|               |                  |                |               | zsh              |             |

### Pip

All pip packages are present in [pip.txt](https://github.com/ssongin/devcontainer/blob/master/pip.txt) file.

* pywinrm
* kubernetes
