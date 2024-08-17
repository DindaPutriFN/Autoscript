#!/bin/bash

# Variabel
TINC_PORT=655
XMPP_PORT=5222
ADB_PORT=5037
domain=$(cat /etc/xray/domain)

# Update sistem
echo "Updating system..."
apt update -y
apt upgrade -y

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

cat <<EOL | tee $TINC_DIR/myvpn/tinc.conf
Name = myvpn
AddressFamily = ipv4
Interface = tinc0
EOL

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
wget -O /usr/bin/sslh "https://objects.githubusercontent.com/github-production-release-asset-2e65be/836503438/c81341b2-7a0f-4c96-8866-88f0eb6d6553?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20240817%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20240817T012912Z&X-Amz-Expires=300&X-Amz-Signature=b018edcc24e2918ffd610e298d9bb35fb5efca02b1625267e1ffd42cad56f51e&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=836503438&response-content-disposition=attachment%3B%20filename%3Dsslh&response-content-type=application%2Foctet-stream"

# Konfigurasi sslh
rm -f /etc/default/sslh
cat> /etc/default/sslh << END
RUN=yes
DAEMON=/usr/sbin/sslh
DAEMON_OPTS="--listen 0.0.0.0:443 --tls 127.0.0.1:777 --http 127.0.0.1:700 --openvpn 127.0.0.1:1194 --xmpp 127.0.0.1:5222 --tinc 127.0.0.1:655 --adb 127.0.0.1:5037 --ssh 127.0.0.1:3303 --anyprot 127.0.0.1:443 --pidfile /var/run/sslh/sslh.pid -n"
END

# Restart services
echo "Restarting services..."
systemctl restart tinc
systemctl restart ejabberd
systemctl restart sslh

# Verifikasi instalasi
echo "Verifying installations..."


echo "Setup complete. Please verify each service individually."
rm -fr /root/*.sh