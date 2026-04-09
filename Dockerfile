# Start from the official SageMath image
FROM debian:latest

# Install and set up OpenSSH server
USER root
RUN apt-get update \
    && apt-get install -y openssh-server macaulay2 npm nodejs git wget \
    && mkdir -p /var/run/sshd \
    && mkdir -p /root/extern \
    && echo 'root:root' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd \
    && cd /opt \
    && git clone https://github.com/pzinn/Macaulay2Web.git \
    && cd /opt/Macaulay2Web \
    && git submodule init \
    && git submodule update \
    && npm install \
    && npm run build \
    && ssh-keygen -t ecdsa -f ~/.ssh/id_ecdsa \
    && cat ~/.ssh/id_ecdsa.pub > ~/.ssh/authorized_keys

# Expose ports: 8002 for m2web
EXPOSE 22 8002

# Copy the startup script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Run both sshd and m2web on startup
ENTRYPOINT [ "/usr/local/bin/start.sh" ]
CMD [ "bash" ]