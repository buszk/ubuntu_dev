# Base image
FROM ubuntu:latest

# Prevent interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openssh-server \
        git \
        python3 \
        python3-pip \
        sudo \
    && rm -rf /var/lib/apt/lists/*


# Ensure ubuntu user exists and set password
RUN id -u ubuntu 2>/dev/null || useradd -ms /bin/bash ubuntu && \
    echo "ubuntu:ubuntu" | chpasswd && \
    usermod -aG sudo ubuntu

# Set up SSH
RUN mkdir /var/run/sshd && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config
EXPOSE 22

# Set up web
EXPOSE 8080

# Default commands
CMD service ssh start && tail -f /dev/null