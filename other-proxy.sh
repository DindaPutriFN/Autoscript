#!/bin/bash

# Variabel
TINC_PORT=655
XMPP_PORT=5222
ADB_PORT=5037
domain=$(cat /etc/xray/domain)

# Update sistem
echo "Updating system..."
#apt update -y
#apt upgrade -y

# Instalasi Tinc
echo "Installing Tinc..."
apt install -y tinc

# Konfigurasi Tinc
echo "Configuring Tinc..."
TINC_DIR="/etc/tinc"
mkdir -p $TINC_DIR/{myvpn,hosts}
cat <<EOL | tee $TINC_DIR/tinc.conf
Name = myvpn
Device = /dev/net/tun
ConnectTo = myvpn
EOL

rm -fr $TINC_DIR/myvpn/tinc.conf
mkdir -p $TINC_DIR/myvpn/
cat <<EOL | tee $TINC_DIR/myvpn/tinc.conf
Name = myvpn
AddressFamily = ipv4
Interface = tinc0
EOL

rm -fr $TINC_DIR/myvpn/hosts/myvpn
mkdir -p $TINC_DIR/myvpn/hosts
cat <<EOL | tee $TINC_DIR/myvpn/hosts/myvpn
Address = 127.0.0.1
Port = $TINC_PORT
EOL

# Instalasi ejabberd (XMPP server)
echo "Installing ejabberd..."
apt install -y ejabberd

# Konfigurasi ejabberd
echo "Configuring ejabberd..."
rm -fr /etc/ejabberd/ejabberd.yml
cat <<EOL | tee /etc/ejabberd/ejabberd.yml > /dev/null
---
hosts:
  - "localhost"
  - "$domain"

listen:
  -
    port: $XMPP_PORT
    module: ejabberd_c2s
EOL

# Instalasi ADB
echo "Installing ADB..."
apt install -y android-tools-adb

# Konfigurasi ADB Serever
adb kill-server
adb start-server

# Instalasi SSLH
echo "Installing SSLH..."
apt -y install sslh
rm -fr /usr/sbin/sslh
wget -O /usr/sbin/sslh "https://github.com/DindaPutriFN/sslh/releases/download/sslh-mod/sslh"
chmod +x /usr/sbin/sslh

# Konfigurasi sslh
rm -f /etc/default/sslh
cat> /etc/default/sslh << END
RUN=yes
DAEMON=/usr/sbin/sslh
DAEMON_OPTS="--listen 0.0.0.0:443 --tls 127.0.0.1:777 --http 127.0.0.1:700 --openvpn 127.0.0.1:1194 --xmpp 127.0.0.1:5222 --tinc 127.0.0.1:655 --adb 127.0.0.1:5037 --ssh 127.0.0.1:3303 --anyprot 127.0.0.1:443 --pidfile /var/run/sslh/sslh.pid -n"
END

# Memprbaiki Pid SSLH
clear
rm -fr /var/run/sslh
mkdir -p /var/run/sslh
touch /var/run/sslh/sslh.pid
chmod +x 777 /var/run/sslh/sslh.pid

# Restart services
echo "Restarting services..."
systemctl daemon-reload
systemctl restart tinc
systemctl restart ejabberd
systemctl restart sslh

# Verifikasi instalasi
echo "Verifying installations..."


echo "Setup complete. Please verify each service individually."
rm -fr /root/*.sh