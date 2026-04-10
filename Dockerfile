# Start from the official SageMath image
FROM debian:latest
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Expose ports: 8002 for m2web
EXPOSE 8002

USER root
# Install deps
RUN apt-get update && apt-get install -y openssh-server openssh-client macaulay2 npm nodejs git wget
RUN mkdir -p /var/run/sshd
RUN mkdir -p /root/extern
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

# Install and set up m2web app
WORKDIR /opt
RUN git clone https://github.com/pzinn/Macaulay2Web.git

WORKDIR /opt/Macaulay2Web
RUN git submodule init \
    && git submodule update \
    && npm install \
    && npm run build

# Copy the startup script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

RUN ssh-keygen -t ecdsa -f ~/.ssh/id_ecdsa
RUN cat ~/.ssh/id_ecdsa.pub > ~/.ssh/authorized_keys

# Run both sshd and m2web on startup
ENTRYPOINT [ "/usr/local/bin/start.sh" ]
CMD [ "bash" ]