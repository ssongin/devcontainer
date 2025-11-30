# Base image
FROM archlinux:base-devel-20251005.0.430597

# Create a new user
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=1000

# Set environment variables
ENV TZ=Europe/Vilnius
ENV LANG=en_US.UTF-8

# Copy the list of applications
COPY packages.txt /tmp/packages.txt
COPY pip.txt /tmp/pip.txt
COPY golang.txt /tmp/golang.txt

SHELL ["/bin/sh", "-o", "pipefail", "-c"]

# Update and install dependencies from file
RUN pacman -Sy --noconfirm && \
  xargs -a /tmp/packages.txt pacman -S --noconfirm && \
  pacman -Scc --noconfirm

RUN pip3 install --no-cache-dir --break-system-packages -r /tmp/pip.txt

# Install Go and Go tools from golang.txt
RUN mkdir -p /go/bin && \
  export GOBIN=/go/bin && export PATH=$PATH:/go/bin && \
  while IFS= read -r tool; do \
    go install "$tool"; \
  done < /tmp/golang.txt && \
  ln -s /go/bin/* /usr/local/bin/

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

# Generate the en_US.UTF-8 locale
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && \
    export LANG=en_US.UTF-8 && \
    export LC_ALL=en_US.UTF-8

# Switch to the new user
USER $USERNAME

# Git configurations
RUN git config --global core.fileMode false
RUN git config --global core.autocrlf input

WORKDIR /home/$USERNAME
RUN git clone  --recurse-submodules --remote-submodules https://github.com/ssongin/dotfiles.git

# Install Zsh and Oh My Zsh
RUN export RUNZSH=no CHSH=no \
    && sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


WORKDIR /home/$USERNAME/dotfiles
RUN stow --target="$HOME" lazyvim
RUN stow --target="$HOME" tmux
RUN stow --adopt --target="$HOME" zsh
RUN rm -fr /home/$USERNAME/.oh-my-zsh/custom
RUN stow --adopt --target="$HOME/.oh-my-zsh" oh-my-zsh

RUN git restore .

RUN export PATH="$HOME/go/bin:$PATH"

WORKDIR /home/$USERNAME

# Default command (Zsh shell)
CMD ["zsh"]