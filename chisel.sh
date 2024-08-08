#!/bin/bash

# Memastikan skrip dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Menginstall Tools
apt install gzip -y

# Menentukan URL download untuk Chisel versi terbaru (pastikan ini adalah versi yang diinginkan)
CHISEL_URL="https://github.com/jpillora/chisel/releases/latest/download/chisel_linux_amd64.gz"

# Download file Chisel
echo "Downloading Chisel..."
wget -O /tmp/chisel.gz $CHISEL_URL

# Extract file Chisel
echo "Extracting Chisel..."
gunzip -f /tmp/chisel.gz

# Pindahkan file Chisel ke /usr/bin/chisel
echo "Installing Chisel..."
mv /tmp/chisel /usr/bin/chisel

# Memberikan izin eksekusi pada file Chisel
chmod +x /usr/bin/chisel

# Membuat file service systemd untuk Chisel di port 9443 (HTTPS)
echo "Creating systemd service for Chisel SSL (port 9443)..."
cat <<EOF > /etc/systemd/system/chisel-ssl.service
[Unit]
Description=Chisel Server SSL By FN Project
After=network.target

[Service]
ExecStart=/usr/bin/chisel server --port 9443 --key /etc/xray/xray.key --cert /etc/xray/xray.crt --socks5
Restart=always
User=nobody
Group=nogroup

[Install]
WantedBy=multi-user.target
EOF

# Membuat file service systemd untuk Chisel di port 8000 (HTTP)
echo "Creating systemd service for Chisel HTTP (port 8000)..."
cat <<EOF > /etc/systemd/system/chisel-http.service
[Unit]
Description=Chisel Server HTTP By FN Project
After=network.target

[Service]
ExecStart=/usr/bin/chisel server --port 8000 --socks5
Restart=always
User=nobody
Group=nogroup

[Install]
WantedBy=multi-user.target
EOF

# Memuat ulang daemon systemd
echo "Reloading systemd daemon..."
systemctl daemon-reload

# Mengaktifkan dan memulai service Chisel SSL (port 9443)
echo "Enabling and starting Chisel SSL service..."
systemctl enable chisel-ssl.service
systemctl start chisel-ssl.service

# Mengaktifkan dan memulai service Chisel HTTP (port 8000)
echo "Enabling and starting Chisel HTTP service..."
systemctl enable chisel-http.service
systemctl start chisel-http.service

# Membersihkan layar
rm -fr chisel.sh
clear