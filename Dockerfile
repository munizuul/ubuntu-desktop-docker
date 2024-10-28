# Use Ubuntu as the base image
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    ubuntu-desktop \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    novnc \
    net-tools \
    curl \
    wget \
    git \
    sudo \
    python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a new user
ENV USER=ubuntu
ENV HOME=/home/ubuntu
RUN useradd -m -s /bin/bash ${USER} && \
    echo "${USER}:ubuntu" | chpasswd && \
    adduser ${USER} sudo && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Switch to the new user
USER ${USER}
WORKDIR ${HOME}

# Set up VNC
RUN mkdir ${HOME}/.vnc
RUN echo "password" | vncpasswd -f > ${HOME}/.vnc/passwd
RUN chmod 600 ${HOME}/.vnc/passwd

# Create startup script
RUN echo '#!/bin/bash\nxrdb $HOME/.Xresources\nstartxfce4 &' > ${HOME}/.vnc/xstartup
RUN chmod +x ${HOME}/.vnc/xstartup

# Expose VNC port
EXPOSE 5901
EXPOSE 6080

# Start VNC server
CMD vncserver :1 -geometry 1280x800 -depth 24 && \
    /usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 6080
