FROM ubuntu:16.04

# Install required packages
RUN apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
	ca-certificates \
	openssh-server \
	wget \
	tzdata \
	curl \
	apt-transport-https \
	openssl \
	openssh-server \
	&& rm -rf /var/lib/apt/lists/* \
	&& sed 's/session\s*required\s*pam_loginuid.so/session optional pam_loginuid.so/g' -i /etc/pam.d/sshd

# Remove MOTD
RUN rm -rf /etc/update-motd.d /etc/motd /etc/motd.dynamic
RUN ln -fs /dev/null /run/motd.dynamic

# Allow to access embedded tools
ENV PATH /opt/gitlab/embedded/bin:/opt/gitlab/bin:/assets:$PATH

# Resolve error: TERM environment variable not set.
ENV TERM xterm

EXPOSE 443 80 22

VOLUME ["/etc/gitlab", "/var/opt/gitlab", "/var/log/gitlab"]

RUN curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash

RUN apt-get -y install gitlab-ce

#COPY gitlab.rb /etc/gitlab/

WORKDIR /root/generateSSL

RUN openssl genrsa -des3 -passout pass:x -out server.pass.key 2048

RUN openssl rsa -passin pass:x -in server.pass.key -out server.key

RUN rm server.pass.key

RUN openssl req -new -key server.key -out server.csr -subj "/C=FR/ST=Ile de France/L=Paris/O=ok/OU=IT Department/CN=ssl"

RUN openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.crt

WORKDIR /etc/gitlab/ssl

WORKDIR /root/generateSSL

RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

CMD echo "letsencrypt['enable'] = false" > /etc/gitlab/gitlab.rb && \
echo "external_url \"https://gitlab.example.com\"" >> /etc/gitlab/gitlab.rb && \
echo "nginx['ssl_certificate'] = \"/etc/gitlab/ssl/server.crt\"" >> /etc/gitlab/gitlab.rb && \
echo "nginx['ssl_certificate_key'] = \"/etc/gitlab/ssl/server.key\"" >> /etc/gitlab/gitlab.rb && \
echo "nginx['redirect_http_to_https'] = true" >> /etc/gitlab/gitlab.rb && \
echo "mattermost_nginx['redirect_http_to_https'] = true" >> /etc/gitlab/gitlab.rb && \
cp /root/generateSSL/server.key /etc/gitlab/ssl/ && \
cp /root/generateSSL/server.crt /etc/gitlab/ssl/ && \
/opt/gitlab/embedded/bin/runsvdir-start & gitlab-ctl reconfigure && \
/usr/sbin/sshd -D
