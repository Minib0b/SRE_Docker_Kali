FROM kalilinux/kali-rolling

LABEL maintainer="Alberto Llorens"
LABEL description="Kali Linux con XFCE y XRDP"

ARG USER=kali
ARG PASS=kali

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y kali-tools-forensics iputils-ping && \
    apt-get install -y kali-desktop-xfce xrdp sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash $USER && \
    echo "$USER:$PASS" | chpasswd && \
    adduser $USER sudo

RUN echo '#!/bin/sh' > /etc/xrdp/startwm.sh && \
    echo 'unset DBUS_SESSION_BUS_ADDRESS' >> /etc/xrdp/startwm.sh && \
    echo 'unset XDG_RUNTIME_DIR' >> /etc/xrdp/startwm.sh && \
    echo 'exec startxfce4' >> /etc/xrdp/startwm.sh && \
    chmod +x /etc/xrdp/startwm.sh

RUN sed -i 's/port=3389/port=13389/g' /etc/xrdp/xrdp.ini

EXPOSE 13389

CMD ["/bin/bash", "-c", "rm -f /var/run/xrdp/xrdp.pid /var/run/xrdp/xrdp-sesman.pid && /usr/sbin/xrdp-sesman && exec /usr/sbin/xrdp -n"]
