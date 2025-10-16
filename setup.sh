#!/bin/bash
# Ubuntu GUI + noVNC + Cloudflare Tunnel
# Author: ChatGPT + Samsul Maulana 😎

export USER=root
apt update -y
apt install -y xfce4 xfce4-goodies tightvncserver novnc websockify wget curl unzip

mkdir -p ~/.vnc
echo "123456" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

cat <<'EOF' > ~/.vnc/xstartup
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

vncserver :1
websockify --web=/usr/share/novnc/ 6080 localhost:5901 &

# Install cloudflared
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
dpkg -i cloudflared-linux-amd64.deb

# Jalankan tunnel
cloudflared tunnel --url http://localhost:6080 --no-autoupdate
