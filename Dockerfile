# Start from debian
FROM debian:latest
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Expose ports: 8002 for m2web
EXPOSE 8002

USER root
# Install deps
RUN apt-get update && apt-get install -y openssh-server openssh-client macaulay2 npm nodejs git wget
RUN mkdir -p /var/run/sshd
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

RUN wget -O /etc/apt/sources.list.d/macaulay2.sources https://macaulay2.com/Repositories/Debian/trixie/macaulay2.sources
RUN apt update
RUN apt install macaulay2 macaulay2-common

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

RUN ssh-keygen -t ecdsa -f ~/.ssh/id_ecdsa && cat ~/.ssh/id_ecdsa.pub > ~/.ssh/authorized_keys

# Run both sshd and m2web on startup
ENTRYPOINT [ "/usr/local/bin/start.sh" ]
CMD [ "bash" ]