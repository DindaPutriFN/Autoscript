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
wget "https://raw.githubusercontent.com/scriptvpskita/list-version/main/dns-server" -O /usr/local/bin/dnstt-server
sleep 2
chmod +x /usr/local/bin/dnstt-server
sleep 1
/usr/local/bin/dnstt-server -gen-key -privkey-file /etc/slowdns/server.key -pubkey-file /etc/slowdns/server.pub

# Install Service
echo "           [*] DNSTT Install Service"
clear
cat <<EOF > /etc/systemd/system/dnstt.service
[Unit]
Description=Slowdns DNSTT By FN Project
Wants=network.target
After=network.target
[Service]
ExecStart=/usr/local/bin/dnstt-server -udp :5300 -privkey-file /etc/slowdns/server.key $nameserver 127.0.0.1:109
Restart=always
RestartSec=3
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable dnstt
systemctl restart dnstt
systemctl start dnstt
clear