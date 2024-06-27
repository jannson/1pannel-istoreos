#!/bin/bash

#PANEL_BASE_DIR=/mnt/nvme0n1-4/test/1panel
#PANEL_PORT=10086
#DEFAULT_ENTRANCE="entrance"
#DEFAULT_USERNAME="1panel"
#DEFAULT_PASSWORD="1panel_password"
#PANELVER=v1.10.10-lts

if [ ! -f "/iStorePanel/env" ]; then
  echo "env not found"
  exit 1
fi

source /iStorePanel/env

if which 1panel >/dev/null 2>&1; then
    echo "1Panel Linux 服务器运维管理面板已安装，请勿重复安装"

    systemctl enable unixproxy.service 
    systemctl start unixproxy
    systemctl enable 1panel 
    systemctl start 1panel 
	 
    for b in {1..30}
    do
        sleep 3
        service_status=`systemctl status 1panel 2>&1 | grep Active`
        if [[ $service_status == *running* ]];then
            echo "1Panel 服务启动成功!"
            break;
        else
            echo "1Panel 服务启动出错!"
            exit 1
        fi
    done
    exit 0
fi

cd /app

systemctl enable unixproxy.service 
systemctl start unixproxy

INSTALL_MODE="stable" && \
    ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "armhf" ]; then ARCH="armv7"; fi && \
    if [ "$ARCH" = "ppc64el" ]; then ARCH="ppc64le"; fi && \
    package_file_name="1panel-${PANELVER}-linux-${ARCH}.tar.gz" && \
    package_download_url="https://resource.fit2cloud.com/1panel/package/${INSTALL_MODE}/${PANELVER}/release/${package_file_name}" && \
    echo "Downloading ${package_download_url}" && \
    curl -sSL -o ${package_file_name} "$package_download_url" && \
    tar zxvf ${package_file_name} --strip-components 1 && \
    rm /app/install.sh && \
    cp /app/install.override.sh /app/install.sh && \
    chmod +x /app/install.sh && \
    chmod +x /app/update_app_version.sh && \
    bash /app/install.sh && \
    # cp /app/1panel.service /etc/systemd/system/1panel.service && \
    rm -f /app/*.tar.gz

#systemctl enable 1panel.service
#systemctl start 1panel.service

