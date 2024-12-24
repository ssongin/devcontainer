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
RUN mkdir -p /home/$USERNAME/.config && \
    echo 'eval "$(starship init bash)"' >> /home/$USERNAME/.bashrc

# COPY dotfiles/nvim/.config/nvim /home/$USERNAME/.config/nvim
COPY dotfiles/starship/.config/starship.toml /home/$USERNAME/.config/starship.toml
COPY dotfiles/tmux/.config/tmux /home/$USERNAME/.config/tmux
COPY dotfiles/tmux/.tmux /home/$USERNAME/.tmux

# Clone lazyvim configs for neovim
RUN git clone https://github.com/LazyVim/starter /home/$USERNAME/.config/nvim

# Set ownership of home directory
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME

# Switch to the new user
USER $USERNAME
WORKDIR /home/$USERNAME

# Default command (bash shell)
CMD ["bash"]