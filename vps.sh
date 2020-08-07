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





function bbr_plus(){
cd /root
if [-e "tcp.sh"]; then
./tcp.sh
else
wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" 
chmod u+x tcp.sh 
./tcp.sh
fi
}

function bt(){

clear
green " ===================================="
green " 1. 安装宝塔"
green " 2. 安装lnmp"
green " 3. 返回上一层"
green " 0. 退出"
green " ===================================="
read -p "请输入数字:" num
    case "$num" in
    1)
    cd /root
    if [-e "install.sh"]; then
	bash install.sh
    else
	wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh
    	bash install.sh
    fi
    ;;
    2)
    cd /root
    screen -S lnmp
    wget http://soft.vpser.net/lnmp/lnmp1.6.tar.gz -cO lnmp1.6.tar.gz 
    tar zxf lnmp1.6.tar.gz
    cd lnmp1.6 
    ./install.sh lnmp
    ;;
    3)
    start_menu
    ;;
    0)
    exit 1
    ;;
    *)
    clear
    red "请输入正确数字"
    sleep 1s
    start_menu
    ;;
    esac

}
function install_docker(){

clear
green " ===================================="
green " 1. 安装docker"
green " 2. docker界面安装"
green " 3. docker compose安装"
green " 4. 返回上一层"
green " 0. 退出"
green " ===================================="
read -p "请输入数字:" num
    case "$num" in
    1)
    cd /root
    curl -sSL https://get.docker.com/ | sh
    systemctl start docker
    systemctl enable docker.service
    ;;
    2)
    docker volume create portainer_data
    docker run -d -p 9000:9000 -p 8000:8000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
    ;;
    3)
    curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    docker-compose --version
    ;;
    4)
    start_menu
    ;;
    0)
    exit 1
    ;;
    *)
    clear
    red "请输入正确数字"
    sleep 1s
    install_docker
    ;;
    esac

}

function gcp_root(){
read -p "输入你的root密码(eg: 123456): " rootPwd
echo root:$rootPwd |sudo chpasswd root
sudo sed -i 's/^.*PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sudo sed -i 's/^.*PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
sudo service sshd restart
}

start_menu(){
    clear
    green " ===================================="
    green " 介绍：vps一键部署 "
    green " 系统：debian或者ubuntu"
    green " ===================================="
    echo
    green " 1. update"
    green " 2. 安装curl,screen,unzip,tar"
    green " 3. 安装bbr加速"
    green " 4. 安装lnmp或者宝塔"
    green " 5. 安装docker及界面"
    green " 6. 谷歌云ROOT登录"
    blue " 0. 退出脚本"
    echo
    read -p "请输入数字:" num
    case "$num" in
    1)
    apt-get -y update
    ;;
    2)
    apt-get -y install curl screen unzip tar
    ;;
    3)
    bbr_plus 
    ;;
    4)
    bt
    ;;
    5)
    install_docker
    ;;
    6)
    gcp_root
    ;;
    0)
    exit 1
    ;;
    *)
    clear
    red "请输入正确数字"
    sleep 1s
    start_menu
    ;;
    esac
}

start_menu
