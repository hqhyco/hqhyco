#!/bin/bash

blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}

function install_xray(){
    mkdir -p /root/xray
    mkdir -p /root/caddy
cat > /root/xray/config.json <<EOF
{
    "inbounds": [
      {
        "port": 10000,
        "listen":"0.0.0.0",
        "protocol": "vless",
        "settings": {
          "clients": [
            {
              "id": "c7347475-0af3-48b6-be99-301a47b3204d",
              "level": 0
            }
          ],
          "decryption": "none"
        },
        "streamSettings": {
          "network": "ws",
          "wsSettings": {
          "path": "/foxzc"
          }
        }
      }
    ],
    "outbounds": [
      {
        "protocol": "freedom",
        "settings": {}
      }
    ]
  }
EOF

read -p "输入网址(eg: www.baidu.com): " xray_site

cat > /root/caddy/Caddyfile <<EOF
# domain name.
$xray_site
{
# Set this path to your site's directory.
    tls {
        ciphers TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256
        curves x25519
        alpn http/1.1 h2
    }
    encode zstd gzip
    reverse_proxy 172.17.0.1:9000
    @v2ray_websocket { 
        path /foxzc
        header Connection *Upgrade* 
        header Upgrade websocket 
    }
    reverse_proxy @v2ray_websocket xray:10000
}
EOF

cat > /root/docker-compose.yml <<EOF
version: "3.7"
services:
  caddy:
    image: caddy
    container_name: caddy2
    restart: always
    links:
      - xray:xray
    ports:
      - 80:80
      - 443:443
    volumes:
      - /root/caddy/Caddyfile:/etc/caddy/Caddyfile
      - /root/caddy/data:/data
      - /root/caddy/www:/usr/share/caddy

  xray:
    image: teddysun/xray
    container_name: xray
    restart: always
    volumes:
      - /root/xray/config.json:/etc/xray/config.json
EOF

docker-compose up -d

green "安装完成！"
}

install_xray
