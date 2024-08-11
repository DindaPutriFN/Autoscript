#!/bin/bash

# [ Installer Slowdns By Rerechan02 ]
echo "--------------------------------------------"
echo " Auto Script Installer DNSTT By Rerechan02"
echo "--------------------------------------------"
read -p "Input NameServer Slownds: " nameserver

clear
echo "           [*] Install PACKAGE...."

# Install Package
sleep 2
yes | sudo apt-get install nano -y >/dev/null 2>&1;
yes | sudo apt-get install g++ -y >/dev/null 2>&1;
yes | sudo apt-get install git -y >/dev/null 2>&1;
yes | sudo apt-get install -y iptables -y >/dev/null 2>&1;
yes | sudo apt-get install net-tools-y >/dev/null 2>&1;
yes | apt-get -y install iptables iptables-services -y >/dev/null 2>&1;
yes | apt-get install screen wget gcc build-essential g++ make -y >/dev/null 2>&1;
yes | sudo apt-get install wget -y >/dev/null 2>&1;
yes | apt-get install nload -y >/dev/null 2>&1;
yes | sudo apt-get --purge remove apache2 -y >/dev/null 2>&1;
yes | apt-get install software-properties-common -y >/dev/null 2>&1;
yes | apt install build-essential gcc make -y >/dev/null 2>&1;
clear

# Install Slowdns
echo "           [*] DNSTT"
rm -fr /etc/slowdns
mkdir -p /etc/slowdns
echo "$nameserver" > /etc/slowdns/nsdomain
echo "$nameserver" > /etc/slowdns/nameserver
echo "$nameserver" > /root/nsdomain
apt install git -y >/dev/null 2>&1;
wget -c https://www.dropbox.com/s/vq5k1qixtersd80/dnstt-server?dl=0 -O /usr/local/bin/dnstt-server >/dev/null 2>&1;
sleep 2
chmod +x /usr/local/bin/dnstt-server >/dev/null 2>&1;
sleep 1
/usr/local/bin/dnstt-server -gen-key -privkey-file /etc/slowdns/server.key -pubkey-file /etc/slowdns/server.pub >/dev/null 2>&1;

# Install Service
echo "           [*] DNSTT Install Service"
clear
SERVER_PORT_V2RAY='46210'
cat <<EOF > /etc/systemd/system/dnstt.service
[Unit]
Description=Slowdns DNSTT By FN Project
Wants=network.target
After=network.target
[Service]
ExecStart=/usr/local/bin/dnstt-server -udp :5300 -privkey-file /etc/slowdns/server.key $nameserver 127.0.0.1:$SERVER_PORT_V2RAY
Restart=always
RestartSec=3
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable dnstt
systemctl restart dnstt
systemctl start dnstt

# Install V2ray
bash <(curl -sS https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)>/dev/null 2>&1;
bash <(curl -sS https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh) >/dev/null 2>&1;
cat <<EOF > /usr/local/etc/v2ray/config.json
{"\u006c\u006f\u0067":null,"\u0072\u006f\u0075\u0074\u0069\u006e\u0067":{"\u0072\u0075\u006c\u0065\u0073":[{"\u0069\u006e\u0062\u006f\u0075\u006e\u0064\u0054\u0061\u0067":["\u0061\u0070\u0069"],"\u006f\u0075\u0074\u0062\u006f\u0075\u006e\u0064\u0054\u0061\u0067":"\u0061\u0070\u0069","\u0074\u0079\u0070\u0065":"\u0066\u0069\u0065\u006c\u0064"},{"\u0069\u0070":["\u0067\u0065\u006f\u0069\u0070\u003a\u0070\u0072\u0069\u0076\u0061\u0074\u0065"],"\u006f\u0075\u0074\u0062\u006f\u0075\u006e\u0064\u0054\u0061\u0067":"\u0062\u006c\u006f\u0063\u006b\u0065\u0064","\u0074\u0079\u0070\u0065":"\u0066\u0069\u0065\u006c\u0064"},{"\u006f\u0075\u0074\u0062\u006f\u0075\u006e\u0064\u0054\u0061\u0067":"\u0062\u006c\u006f\u0063\u006b\u0065\u0064","\u0070\u0072\u006f\u0074\u006f\u0063\u006f\u006c":["\u0062\u0069\u0074\u0074\u006f\u0072\u0072\u0065\u006e\u0074"],"\u0074\u0079\u0070\u0065":"\u0066\u0069\u0065\u006c\u0064"}]},"\u0064\u006e\u0073":{"\u0073\u0065\u0072\u0076\u0065\u0072\u0073":["\u0031\u002e\u0031\u002e\u0031\u002e\u0031","\u0031\u002e\u0030\u002e\u0030\u002e\u0031","\u0038\u002e\u0038\u002e\u0038\u002e\u0038","\u0038\u002e\u0038\u002e\u0034\u002e\u0034","\u006c\u006f\u0063\u0061\u006c\u0068\u006f\u0073\u0074"]},"\u0069\u006e\u0062\u006f\u0075\u006e\u0064\u0073":[{"\u006c\u0069\u0073\u0074\u0065\u006e":"\u0031\u0032\u0037\u002e\u0030\u002e\u0030\u002e\u0031","\u0070\u006f\u0072\u0074":46210,"\u0070\u0072\u006f\u0074\u006f\u0063\u006f\u006c":"\u0076\u006d\u0065\u0073\u0073","\u0073\u0065\u0074\u0074\u0069\u006e\u0067\u0073":{"\u0063\u006c\u0069\u0065\u006e\u0074\u0073":[{"\u0069\u0064":"\u0039\u0037\u0036\u0038\u0037\u0064\u0036\u0062\u002d\u0065\u0037\u0036\u0034\u002d\u0034\u0063\u0030\u0062\u002d\u0061\u0066\u0031\u0038\u002d\u0063\u0033\u0066\u0034\u0034\u0036\u0033\u0033\u0061\u0037\u0036\u0062","\u0061\u006c\u0074\u0065\u0072\u0049\u0064":10}],"\u0064\u0069\u0073\u0061\u0062\u006c\u0065\u0049\u006e\u0073\u0065\u0063\u0075\u0072\u0065\u0045\u006e\u0063\u0072\u0079\u0070\u0074\u0069\u006f\u006e":false},"\u0073\u0074\u0072\u0065\u0061\u006d\u0053\u0065\u0074\u0074\u0069\u006e\u0067\u0073":{"\u006e\u0065\u0074\u0077\u006f\u0072\u006b":"\u0077\u0073","\u0073\u0065\u0063\u0075\u0072\u0069\u0074\u0079":"\u006e\u006f\u006e\u0065","\u0077\u0073\u0053\u0065\u0074\u0074\u0069\u006e\u0067\u0073":{"\u0070\u0061\u0074\u0068":"\u002f","\u0068\u0065\u0061\u0064\u0065\u0072\u0073":{}}},"\u0074\u0061\u0067":"\u0069\u006e\u0062\u006f\u0075\u006e\u0064\u002d\u0034\u0036\u0032\u0031\u0030","\u0073\u006e\u0069\u0066\u0066\u0069\u006e\u0067":{"\u0065\u006e\u0061\u0062\u006c\u0065\u0064":true,"\u0064\u0065\u0073\u0074\u004f\u0076\u0065\u0072\u0072\u0069\u0064\u0065":["\u0068\u0074\u0074\u0070","\u0074\u006c\u0073"]}}],"\u006f\u0075\u0074\u0062\u006f\u0075\u006e\u0064\u0073":[{"\u0070\u0072\u006f\u0074\u006f\u0063\u006f\u006c":"\u0066\u0072\u0065\u0065\u0064\u006f\u006d","\u0073\u0065\u0074\u0074\u0069\u006e\u0067\u0073":{}},{"\u0070\u0072\u006f\u0074\u006f\u0063\u006f\u006c":"\u0062\u006c\u0061\u0063\u006b\u0068\u006f\u006c\u0065","\u0073\u0065\u0074\u0074\u0069\u006e\u0067\u0073":{},"\u0074\u0061\u0067":"\u0062\u006c\u006f\u0063\u006b\u0065\u0064"}],"\u0074\u0072\u0061\u006e\u0073\u0070\u006f\u0072\u0074":null,"\u0070\u006f\u006c\u0069\u0063\u0079":{"\u0073\u0079\u0073\u0074\u0065\u006d":{"\u0073\u0074\u0061\u0074\u0073\u0049\u006e\u0062\u006f\u0075\u006e\u0064\u0044\u006f\u0077\u006e\u006c\u0069\u006e\u006b":true,"\u0073\u0074\u0061\u0074\u0073\u0049\u006e\u0062\u006f\u0075\u006e\u0064\u0055\u0070\u006c\u0069\u006e\u006b":true}},"\u0061\u0070\u0069":{"\u0073\u0065\u0072\u0076\u0069\u0063\u0065\u0073":["\u0048\u0061\u006e\u0064\u006c\u0065\u0072\u0053\u0065\u0072\u0076\u0069\u0063\u0065","\u004c\u006f\u0067\u0067\u0065\u0072\u0053\u0065\u0072\u0076\u0069\u0063\u0065","\u0053\u0074\u0061\u0074\u0073\u0053\u0065\u0072\u0076\u0069\u0063\u0065"],"\u0074\u0061\u0067":"\u0061\u0070\u0069"},"\u0073\u0074\u0061\u0074\u0073":{},"\u0072\u0065\u0076\u0065\u0072\u0073\u0065":null,"\u0066\u0061\u006b\u0065\u0044\u006e\u0073":null}
EOF
sleep 5
cd /etc/systemd/system/
rm -r v2ray.service
wget -c https://www.dropbox.com/s/vs8y30ljca2qx9d/v2ray.service?dl=0 -O v2ray.service >/dev/null 2>&1;
chmod +x /etc/systemd/system/v2ray.service
sudo systemctl daemon-reload && sudo systemctl restart v2ray.service >/dev/null 2>&1;

clear
