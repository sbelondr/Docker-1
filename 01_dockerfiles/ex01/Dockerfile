FROM debian

RUN apt-get update

RUN apt-get install systemd wget bzip2 -y

WORKDIR /root

EXPOSE 9987/udp

EXPOSE 10011

EXPOSE 3033

RUN wget http://dl.4players.de/ts/releases/3.4.0/teamspeak3-server_linux_amd64-3.4.0.tar.bz2

RUN tar xfv teamspeak3-server_linux_amd64-3.4.0.tar.bz2

RUN touch teamspeak3-server_linux_amd64/.ts3server_license_accepted

ENTRYPOINT /root/teamspeak3-server_linux_amd64/ts3server_startscript.sh start && tail -f /dev/null
