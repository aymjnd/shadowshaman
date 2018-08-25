#!/bin/bash
sudo apt install curl -y
clear
netip=$(curl icanhazip.com)
echo -e $"\e[32mWould you like to use your local ip?\n1) $netip (recommended)\n2) Local IP (e.g 192.168.0.1)"
read local

if [ "$local" == "1" ] ; then
    ip=$(curl icanhazip.com)

elif [ "$local" == "2" ] ; then
	echo -e $"\e[32mWhat is your Local IP?\e[39m"
	read ip
else
    echo -e $"\e[31mWrong input! Exiting.\e[39m"
fi

echo -e $"\e[32mEnter your port. Default \e[31m443\e[39m (enter)"
read port
if [ "$port" == "" ] ; then
    port=443
elif [ "$port" -gt "65535" ] ; then
    echo -e $"\e[31mPort can't be larger than 65535! Exiting\e[39m"
    exit 1
elif [ "$port" == "2" ] ; then
    echo -e $"\e[31mCan't use SSH port! Exiting\e[39m"
    exit 1
fi
echo -e $"\e[32mYour password?\e[39m"
read password
method=aes-256-cfb

sudo apt update
sudo apt install -y python python-pip
sudo python -m pip install --upgrade pip
sudo pip install shadowsocks

cd /bin
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

cd
grep -q -F 'nohup /bin/shadowsocks-start >> /dev/null &' /etc/rc.local || echo 'nohup /bin/shadowsocks-start >> /dev/null &' >> /etc/rc.local
shadowsocks-start

url=$(echo "$method:$password@$ip:$port" | base64)
b64url="ss://$url"

clear
echo -e "===================Shadowshaman=0.1b==================="
echo -e "\nShadowsocks started! \e[32m$ip:$port\e[39m."
echo -e "\nShadowsocks uri:\n\e[32m$b64url#shadowshaman\e[39m"
echo -e "\nRun \e[31mshadowsocks-stop \e[39mto stop.\nShadowsocks installed as service and will auto restart on reboot\n"
echo -e "========================AYMJND========================="
