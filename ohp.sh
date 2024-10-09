#!/bin/bash
# Open Http Puncher

# Download File Ohp

cd /usr/bin
wget -O ohp "https://raw.githubusercontent.com/DindaPutriFN/FN-API/main/ohp"
chmod +x /usr/bin/ohp

# Installing Service
# SSH OHP Port 8181
cat > /etc/systemd/system/ssh-ohp.service << END
[Unit]
Description=SSH OHP Redirection Service
Documentation=t.me/fn_project
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/ohp -port 8181 -proxy 127.0.0.1:8888 -tunnel 127.0.0.1:22
Restart=on-failure
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target
END

# Dropbear OHP 8282
cat > /etc/systemd/system/dropbear-ohp.service << END
[Unit]]
Description=Dropbear OHP Redirection Service
Documentation=https://t.me/fn_project
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/ohp -port 8282 -proxy 127.0.0.1:8888 -tunnel 127.0.0.1:143
Restart=on-failure
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target
END

# OpenVPN OHP 8383
cat > /etc/systemd/system/openvpn-ohp.service << END
[Unit]]
Description=OpenVPN OHP Redirection Service
Documentation=t.me/fn_project
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/ohp -port 8383 -proxy 127.0.0.1:8888 -tunnel 127.0.0.1:1194
Restart=on-failure
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target
END

sudo iptables -A INPUT -p tcp --dport 8181 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8282 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8383 -j ACCEPT
sudo ufw allow 8383/tcp
sudo ufw allow 8181/tcp
sudo ufw allow 8282/tcp

# Daemon
systemctl daemon-reload

# Enable
systemctl enable ssh-ohp
systemctl enable dropbear-ohp
systemctl enable openvpn-ohp

# Firewall
sudo iptables -A INPUT -p tcp --dport 8181 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8282 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8383 -j ACCEPT
sudo ufw allow 8383/tcp
sudo ufw allow 8181/tcp
sudo ufw allow 8282/tcp

# Restart
systemctl restart openvpn-ohp
systemctl restart dropbear-ohp
systemctl restart ssh-ohp
clear