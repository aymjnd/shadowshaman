#!/bin/bash

echo -e $"\e[32mWould you like to use your local ip? e.g 192.168.0.1 [y/N]\e[39m"
read local

if [ "$local" == "y" ] || [ "$local" == "Y" ] ; then
	echo -e $"\e[32mWhat is your local ip?\e[39m"
	read ip
elif [ "$local" == "n" ] || [ "$local" == "N" ] ; then
	ip=$(curl icanhazip.com)
else
	ip=$(curl icanhazip.com)
fi

echo -e $"\e[32mWhich port my nibba? e.g \e[31m443\e[39m"
read port
echo -e $"\e[32mYour password?\e[39m"
read password

sudo apt update
sudo apt install -y python python-pip curl
python -m pip install --upgrade pip
sudo pip install shadowsocks

method=aes-256-cfb
cd /bin
SS="shadowsocks-start"
touch $SS

/bin/cat <<EOM >$SS
#!/bin/bash
#shadowsocks start script
sudo ssserver -p $port -s $ip -k $password -m $method -d start
EOM

SStop="shadowsocks-stop"
/bin/cat <<EOM >$SStop
pkill ssserver
EOM

chmod 755 shadowsocks-start
chmod 755 shadowsocks-stop

cd
grep -q -F 'nohup /bin/shadowsocks-start >> /dev/null &' /etc/rc.local || echo 'nohup /bin/shadowsocks-start >> /dev/null &' >> /etc/rc.local
shadowsocks-start
url=$(echo "$method:$password@$ip:$port" | base64)
b64url="ss://$url"
clear
echo -e "===================Shadowshaman=0.1a==================="
echo -e "\nShadowsocks started! \e[32m$ip:$port\e[39m."
echo -e "\nCopy this for easy connect:\n\e[32m$b64url#shadowshaman\e[39m"
echo -e "\nRun \e[31mshadowsocks-stop \e[39mto stop.\nShadowsocks installed as service and will auto restart on reboot\n"
echo -e "========================AYMJND========================="
