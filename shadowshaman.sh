#!/bin/bash
echo -e $"\e[32mWhich port my nibba? e.g \e[31m443\e[39m"
read port
echo -e $"\e[32mYour password?\e[39m"
read password

sudo apt update
sudo apt install -y python python-pip curl
python -m pip install --upgrade pip
sudo pip install shadowsocks

ip=$(curl icanhazip.com)
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
echo -e "====================Shadowsocks===================="
echo -e "\nShadowsocks started! \e[32m$ip:$port\e[39m."
echo -e "\nCopy this \e[32m$b64url#shadowshaman\e[39m"
echo -e "\nRun \e[31mshadowsocks-stop \e[39mto stop.\nShadowsocks will auto restart on reboot thanked\n"
echo -e "======================AYMJND======================="
