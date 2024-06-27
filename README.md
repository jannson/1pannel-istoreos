# 1pannel-istoreos

## TODO

* https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-debian-10
* https://www.linuxbuzz.com/how-to-configure-proxy-for-apt-command/
* https://github.com/okxlin/docker-1panel/blob/main/Dockerfile
* https://forum.openwrt.org/t/timezone-etc-tz-not-updated-correctly/77002/6
* zoneinfo-asia
* ln -sf /usr/share/zoneinfo/Asia/Shanghai /tmp/localtime


## TODO2

```

docker run --restart=unless-stopped -d \
    --cgroupns=host \
	--cap-add SYS_ADMIN \
    --tmpfs /tmp \
	--network host \
	-v /sys/fs/cgroup:/sys/fs/cgroup \
    -v /var/run:/var2/run \
	-v /mnt:/mnt:rslave \
	-e TZ=Asia/Shanghai \
    --dns=172.17.0.1 \
    --dns=223.5.5.5 \
	--name istorePanel istorepanel:0.2
	
	
v1.10.10-lts

export app=/mnt/nvme0n1-4/test/debian-docker

INSTALL_MODE="stable" && \
    ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "armhf" ]; then ARCH="armv7"; fi && \
    if [ "$ARCH" = "ppc64el" ]; then ARCH="ppc64le"; fi && \
    package_file_name="1panel-${PANELVER}-linux-${ARCH}.tar.gz" && \
    package_download_url="https://resource.fit2cloud.com/1panel/package/${INSTALL_MODE}/${PANELVER}/release/${package_file_name}" && \
    echo "Downloading ${package_download_url}" && \
    curl -sSL -o ${package_file_name} "$package_download_url" && \
    tar zxvf ${package_file_name} --strip-components 1 && \
    rm /${app}/install.sh && \
    mv -f /${app}/install.override.sh /${app}/install.sh && \
    chmod +x /${app}/install.sh && \
    chmod +x /${app}/update_app_version.sh && \
    bash /${app}/install.sh && \
    cp /${app}/1panel.service /etc/systemd/system/1panel.service

```
