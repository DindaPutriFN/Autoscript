#!/bin/bash
#
#  |════════════════════════════════════════════════════════════════════════════════════════════════════════════════|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |════════════════════════════════════════════════════════════════════════════════════════════════════════════════|
#
clear
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
echo "Please Wait ...."
REQUIRED_PACKAGES=("curl" "wget" "dnsutils" "git" "screen" "whois" "pwgen" "python" "jq" "fail2ban" "sudo" "gnutls-bin" "mlocate" "dh-make" "libaudit-dev" "build-essential" "dos2unix" "debconf-utils")

for package in "${REQUIRED_PACKAGES[@]}"; do
  if ! dpkg-query -W --showformat='${Status}\n' $package | grep -q "install ok installed"; then
    apt-get -qq install $package -y &>/dev/null
  fi
done
clear
rm -fr /usr/bin/go ; wget https://go.dev/dl/go1.22.0.linux-amd64.tar.gz ; sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz ; rm -fr /root/go1.22.0.linux-amd64.tar.gz ; echo "export PATH="/usr/local/go/bin:$PATH:/rere"" > /root/.bashrc ; cd ; source .bashrc ; go version

#wget -q -O- https://git.io/vQhTU | bash
#source /root/.bashrc

install_slowdns() {
  cd /root
  rm -rf /etc/slowdns
  git clone https://www.bamsoftware.com/git/dnstt.git
  cd dnstt/dnstt-server
  rm -fr go.sum
  go mod tidy
  go build
  mkdir -p /etc/slowdns/
  mv dnstt-server /etc/slowdns/dns-server
  chmod +x /etc/slowdns/dns-server
  /etc/slowdns/dns-server -gen-key -privkey-file /etc/slowdns/server.key -pubkey-file /etc/slowdns/server.pub

  clear
  echo -e "
========================
SlowDNS / DNSTT Settings
========================"
  read -rp "Your Nameserver: " -e Nameserver
  echo -e "$Nameserver" > /etc/slowdns/nsdomain

  rm -f /etc/systemd/system/dnstt.service
  systemctl stop dnstt 2>/dev/null || true
  pkill dns-server 2>/dev/null || true

  cat >/etc/systemd/system/dnstt.service <<END
[Unit]
Description=SlowDNS FN Project Autoscript Service
Documentation=https://t.me/fn_project
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/etc/slowdns/dns-server -udp :5300 -privkey-file /etc/slowdns/server.key $Nameserver 127.0.0.1:22
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

  systemctl daemon-reload
  systemctl enable dnstt
  systemctl start dnstt

  sed -i 's/#AllowTcpForwarding yes/AllowTcpForwarding yes/g' /etc/ssh/sshd_config
  systemctl restart ssh
}

install_firewall() {
  local interface=$(ip route get 8.8.8.8 | awk '/dev/ {print $5}')
  sudo ufw allow 5300/udp
  iptables -I INPUT -p udp --dport 5300 -j ACCEPT &>/dev/null
  iptables -t nat -I PREROUTING -i $interface -p udp --dport 53 -j REDIRECT --to-ports 5300
  iptables-save >/etc/iptables.up.rules
  iptables-restore < /etc/iptables.up.rules
  netfilter-persistent save
  netfilter-persistent reload
}

install_slowdns
install_firewall

rm -rf /root/slowdns.sh
#rm -rf /root/*.sh
clear
echo -e ""
echo -e "Installing Patch SlowDNS Autoscript done..."
echo "done .."
#reboot