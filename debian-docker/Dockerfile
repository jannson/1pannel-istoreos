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
    && apt-get install -y wget tar unzip zip curl git gnupg sudo sqlite3 tzdata \
    && locale-gen en_US.UTF-8 \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && cat /app/gpt.txt | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

COPY proxy.conf /etc/apt/apt.conf.d/proxy.conf
RUN apt-get update && apt-get install -y docker-ce-cli \
    && curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && rm -f /etc/apt/apt.conf.d/proxy.conf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
    /lib/systemd/system/systemd-update-utmp*

COPY ./install.override.sh .
COPY ./update_app_version.sh .

ARG PANELVER=$PANELVER

ENV PANELVER=$PANELVER

RUN INSTALL_MODE="stable" && \
    ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "armhf" ]; then ARCH="armv7"; fi && \
    if [ "$ARCH" = "ppc64el" ]; then ARCH="ppc64le"; fi && \
    package_file_name="1panel-${PANELVER}-linux-${ARCH}.tar.gz" && \
    package_download_url="https://resource.fit2cloud.com/1panel/package/${INSTALL_MODE}/${PANELVER}/release/${package_file_name}" && \
    echo "Downloading ${package_download_url}" && \
    curl -sSL -o ${package_file_name} "$package_download_url" && \
    tar zxvf ${package_file_name} --strip-components 1 && \
    rm /app/install.sh && \
    mv -f /app/install.override.sh /app/install.sh && \
    chmod +x /app/install.sh && \
    chmod +x /app/update_app_version.sh && \
    bash /app/install.sh && \
    cp /app/1panel.service /etc/systemd/system/1panel.service && \
    find /app -type f ! -name 'update_app_version.sh' -delete

RUN systemctl enable 1panel.service && systemctl start 1panel.service

WORKDIR /

EXPOSE 10086

VOLUME [ "/sys/fs/cgroup" ]
VOLUME [ /var2/run ]

CMD ["/lib/systemd/systemd"]

