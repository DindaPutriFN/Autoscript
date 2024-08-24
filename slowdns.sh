#!/bin/bash
#
#  |════════════════════════════════════════════════════════════════════════════════════════════════════════════════|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |════════════════════════════════════════════════════════════════════════════════════════════════════════════════|
#

# Install Tools
apt install iptables -y
apt install wget -y
apt install screen -y

# Clear Screen
clear

# Copy Core SlowDNS
wget -q --no-check-certificate -O /usr/sbin/dns-server "https://raw.githubusercontent.com/potatonc/webmin/master/dns-server"
chmod +x /usr/sbin/dns-server

# Key for Slowdns
skey="79165a5f041150b665db82f16d33be2664749ea5dd0e90c62c1ff99de02a375d"
spub="5bb04eb5c1d8e8ced2feefd2a3b7e4d57cf648dce0d5a225ac62197729336f50"

# Input NameServer
clear
echo -e "
========================
SlowDNS / DNSTT Settings
========================"
read -rp " Your Nameserver : " -e Nameserver
clear

# Delete Old Data
rm -fr /etc/slowdns

# Create New Repo Data
mkdir -p /etc/slowdns

# Save Data
echo "$skey" >> /etc/slowdns/server.key
echo "$spub" >> /etc/slowdns/server.pub
echo "$Nameserver" >> /etc/slowdns/nsdomain


# Run Open Port
iptables -I INPUT -p udp --dport 5300 -j ACCEPT
iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300

# Run SlowDNS
PID_Screen=$(screen -ls | grep -w "slowdns" | awk '{print $1}' | cut -d. -f1)
if [ -n "$PID_Screen" ]; then
    screen -X -S ${PID_Screen} quit
fi
screen -dmS slowdns dns-server -udp :5300 -privkey ${skey} ${Nameserver} 127.0.0.1:111