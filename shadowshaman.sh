#!/bin/bash
pkill ssserver
sudo apt install curl -y
clear
ip=$(curl icanhazip.com)
echo -e $"\e[32mWhich IP?\n1) $ip (recommended)\n2) Local IP (e.g 192.168.0.1)"
read local

if [ "$local" == "1" ] ; then
    ip=$(curl icanhazip.com)
elif [ "$local" == "2" ] ; then
	echo -e $"\e[32mWhat is your Local IP?\e[39m"
	read ip
else
    echo -e $"\e[31mWrong input! Exiting.\e[39m"
    exit 1
fi

echo -e $"\e[32mEnter your port. Default \e[31m443\e[39m (enter)"
read port
if [ "$port" == "" ] ; then
    port=443
elif [ "$port" -gt "65535" ] ; then
    echo -e $"\e[31mPort can't be larger than 65535! Exiting\e[39m"
    exit 1
elif [ "$port" == "22" ] ; then
    echo -e $"\e[31mCan't use SSH port! Exiting\e[39m"
    exit 1
fi

echo -e $"\e[32mWhich encryption?\n1) chacha20-ietf-poly1305 (fastest)\n2) xchacha20-ietf-poly1305 (fastest/recommended - ubuntu 18 only!)\n3) chacha20-ietf\n4) chacha20\n5) aes-256-cfb (good standard encryption)\n6) aes-256-gcm\n7) aes-256-ctr"
read mtd
if [ "$mtd" == "1" ] ; then
    method=chacha20-ietf-poly1305
elif [ "$mtd" == "2" ] ; then
	method=xchacha20-ietf-poly1305
elif [ "$mtd" == "3" ] ; then
	method=chacha20-ietf
elif [ "$mtd" == "4" ] ; then
	method=chacha20
elif [ "$mtd" == "5" ] ; then
	method=aes-256-cfb
elif [ "$mtd" == "6" ] ; then
	method=aes-256-gcm
elif [ "$mtd" == "7" ] ; then
	method=aes-256-ctr
else
    echo -e $"\e[31mWrong input! Exiting.\e[39m"
    exit 1
fi

echo -e $"\e[32mYour password?\e[39m"
read password

sudo apt update
sudo apt install -y python python-pip python-m2crypto libsodium-dev
sudo python -m pip install --upgrade pip
sudo pip install --upgrade https://github.com/shadowsocks/shadowsocks/archive/master.zip

cd /usr/bin
SS="shadowsocks-start"
sudo touch $SS

/bin/cat <<EOM >$SS
#!/bin/bash
#shadowsocks start script
sudo ssserver -p $port -s $ip -k $password -m $method -d start
EOM

SStop="shadowsocks-stop"
/bin/cat <<EOM >$SStop
sudo pkill ssserver
EOM

sudo chmod 755 shadowsocks-start
sudo chmod 755 shadowsocks-stop

shadowsocks-start

url=$(echo -n "$method:$password@$ip:$port" | base64)
b64url="ss://$url"

clear
echo -e "===================Shadowshaman=0.1e==================="
echo -e "\nShadowsocks started! \e[32m$ip:$port\e[39m."
echo -e "\nYour URI:\n\e[32m$b64url#$(hostname)\e[39m"
echo -e "Working with shadowsocks windows client and Outline!"
echo -e "\nRun \e[31mshadowsocks-stop \e[39mto stop.\n"
echo -e "You need to manually restart shadowshaman after reboot.\n"
echo -e "========================AYMJND========================="
