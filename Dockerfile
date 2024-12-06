# Base image
FROM archlinux:latest

# Set environment variables
ENV TZ=Europe/Vilnius
ENV LANG=en_US.UTF-8
# ENV LC_ALL=en_US.UTF-8

# Update and install dependencies
RUN pacman -Sy --noconfirm && \
    pacman -S --noconfirm \
    tmux \
    neovim \
    git \
    fzf \
    wget \
    curl \
    unzip \
    tar \
    base-devel \
    lazygit \
    starship \
    npm \
    tzdata && \
    pacman -Scc --noconfirm

# Set the timezone
RUN ln -sf /usr/share/zoneinfo/Europe/Vilnius /etc/localtime && \
    echo "Europe/Vilnius" > /etc/timezone

# Set Neovim as default editor
RUN ln -sf /usr/bin/nvim /usr/bin/editor

RUN mkdir -p /root/.config

COPY dotfiles/nvim/.config/nvim /root/.config/nvim
COPY dotfiles/starship/.config/starship.toml /root/.config/starship.toml
COPY dotfiles/tmux/.config/tmux /root/.config/tmux
COPY dotfiles/tmux/.tmux /root/.tmux

RUN echo 'eval "$(starship init bash)"' >> /root/.bashrc

# Work directory
WORKDIR /root

# Default command (bash shell)
CMD ["bash"]
