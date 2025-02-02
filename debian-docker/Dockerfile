FROM debian:buster

ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Asia/Shanghai

WORKDIR /app
COPY sources.list /etc/apt/sources.list
COPY gpt.txt .

RUN apt-get update \
    && apt-get install -y systemd locales \
    && apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common \
    && apt-get install -y wget tar unzip zip curl git gnupg sudo sqlite3 tzdata procps \
    && locale-gen en_US.UTF-8 \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && cat /app/gpt.txt | apt-key add - \
    && add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
    /lib/systemd/system/systemd-update-utmp*

COPY proxy.conf /etc/apt/apt.conf.d/proxy.conf
RUN apt-get update && apt-get install -y docker-ce-cli \
    && curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && rm -f /etc/apt/apt.conf.d/proxy.conf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./reinstall.sh .
COPY ./install.override.sh .
COPY ./update_app_version.sh .
COPY ./unixproxy.amd64 .
COPY ./unixproxy.arm64 .
COPY ./unixproxy.service /etc/systemd/system/

RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "armhf" ]; then ARCH="armv7"; fi && \
    if [ "$ARCH" = "ppc64el" ]; then ARCH="ppc64le"; fi && \
    cp /app/unixproxy.${ARCH} /usr/bin/unixproxy && \ 
    rm -f /app/unixproxy.*

VOLUME /sys/fs/cgroup
VOLUME /var2/run
VOLUME /iStorePanel
WORKDIR /

CMD ["/lib/systemd/systemd"]

