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

# COPY dotfiles/nvim/.config/nvim /home/$USERNAME/.config/nvim
# COPY dotfiles/starship/.config/starship.toml /home/$USERNAME/.config/starship.toml
COPY dotfiles/tmux/.config/tmux /home/$USERNAME/.config/tmux
COPY dotfiles/tmux/.tmux /home/$USERNAME/.tmux

# Clone lazyvim configs for Neovim
RUN git clone https://github.com/LazyVim/starter /home/$USERNAME/.config/nvim

# Install Zsh and Oh My Zsh
RUN curl -Lo install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh && \
    RUNZSH=no sh install.sh && \
    rm install.sh && \
    chsh -s /bin/zsh $USERNAME

# Set up Oh My Zsh plugins and themes
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/$USERNAME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/zsh-users/zsh-autosuggestions.git /home/$USERNAME/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://github.com/romkatv/powerlevel10k.git /home/$USERNAME/.oh-my-zsh/custom/themes/powerlevel10k

# Set up .zshrc configuration
RUN echo 'export ZSH="$HOME/.oh-my-zsh"' > /home/$USERNAME/.zshrc && \
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> /home/$USERNAME/.zshrc && \
    echo 'plugins=(git zsh-syntax-highlighting zsh-autosuggestions)' >> /home/$USERNAME/.zshrc && \
    echo 'source $ZSH/oh-my-zsh.sh' >> /home/$USERNAME/.zshrc 

# Set ownership of home directory
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME

# Switch to the new user
USER $USERNAME
WORKDIR /home/$USERNAME

# Default command (Zsh shell)
CMD ["zsh"]
