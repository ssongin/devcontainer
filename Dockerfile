# Base image
FROM archlinux:latest

# Create a new user
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=1000

# Set environment variables
ENV TZ=Europe/Vilnius
ENV LANG=en_US.UTF-8

# Copy the list of applications
COPY packages.txt /tmp/packages.txt

# Update and install dependencies from file
RUN pacman -Sy --noconfirm && \
    xargs -a /tmp/packages.txt pacman -S --noconfirm && \
    pacman -Scc --noconfirm

# Set the timezone
RUN ln -sf /usr/share/zoneinfo/Europe/Vilnius /etc/localtime && \
    echo "Europe/Vilnius" > /etc/timezone

# Set Neovim as default editor
RUN ln -sf /usr/bin/nvim /usr/bin/editor

# Add user and group
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID --create-home $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Copy configurations for the user
RUN mkdir -p /home/$USERNAME/.config

# Set ownership of home directory
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME

# Switch to the new user
USER $USERNAME

WORKDIR /home/$USERNAME
RUN git clone https://github.com/ssongin/dotfiles.git

# Install Zsh and Oh My Zsh
RUN yes | sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

WORKDIR /home/$USERNAME/dotfiles
RUN stow --target="$HOME" lazyvim
RUN stow --target="$HOME" tmux
RUN stow --adopt --target="$HOME" zsh
RUN stow --adopt --target="$HOME/.oh-my-zsh" oh-my-zsh

RUN git restore .

WORKDIR /home/$USERNAME

# Default command (Zsh shell)
CMD ["zsh"]
