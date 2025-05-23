#!/bin/bash
is_number() {
    [[ $1 =~ ^[0-9]+$ ]]
}
YELLOW='\033[1;33m'
NC='\033[0m'
if [ "$(whoami)" != "root" ]; then
    echo "Error: This script must be run as root."
    exit 1
fi
cd /root
clear
echo -e "$YELLOW
💚 HTTP CUSTOM UDP INSTALLER 💚      
 ╰┈➤ 💚 Resleeved Net 💚               "
echo -e "$NC
Select an option"
echo "1. Install HTTP CUSTOM UDP"
echo "0. Exit"

read -p "$(echo -e "\033[1;33mSelect a number from 0 to 1: \033[0m")" input

if [[ $input =~ ^[0-9]+$ ]]; then
    selected_option=$input
else
    echo -e "$YELLOW"
    echo "Invalid input. Please enter a valid number."
    echo -e "$NC"
fi
clear
case $selected_option in
    1)
        echo -e "$YELLOW"
        echo "     💚 HTTP CUSTOM UDP AUTO INSTALLATION 💚      "
        echo "        ╰┈➤💚 Installing Binaries 💚           "
        echo -e "$NC"
        apt install -y curl dos2unix neofetch
        source <(curl -sSL 'https://raw.githubusercontent.com/Hyper-21-stack/udp-custom/main/udp-custom-main/module')

time_reboot() {
  print_center -ama "${a92:-System/Server Reboot In} $1 ${a93:-Seconds}"
  REBOOT_TIMEOUT="$1"

  while [ $REBOOT_TIMEOUT -gt 0 ]; do
    print_center -ne "-$REBOOT_TIMEOUT-\r"
    sleep 1
    : $((REBOOT_TIMEOUT--))
  done
  reboot
}

        # Cleanup
        systemctl stop custom-server.service
        systemctl disable custom-server.service
        rm -rf /etc/systemd/system/custom-server.service
        rm -rf /root/udp .config snap .cache .ssh

        # Setup
        mkdir -p /root/udp
        cd /root/udp

        wget https://github.com/Hyper-21-stack/udp-custom/releases/download/V1/custom-linux-amd64
        chmod 755 custom-linux-amd64

        wget -O /root/udp/module 'https://raw.githubusercontent.com/Hyper-21-stack/udp-custom/main/udp-custom-main/module'
        chmod 755 /root/udp/module

        wget -O /root/udp/limiter.sh 'https://raw.githubusercontent.com/Hyper-21-stack/udp-custom/main/udp-custom-main/limiter.sh'
        chmod 755 /root/udp/limiter.sh

        rm -rf /usr/bin/udp
        wget -O /usr/bin/udp 'https://raw.githubusercontent.com/Hyper-21-stack/udp-custom/main/udp-custom-main/udp'
        chmod 755 /usr/bin/udp

        # Create config
        cat <<EOF >/root/udp/config.json
{
"listen": ":443",
"stream_buffer": 16777216,
"receive_buffer": 83886080,
"auth": {
"mode": "passwords"
  }
}
EOF
        chmod 755 /root/udp/config.json

        # Create service
        cat <<EOF >/etc/systemd/system/custom-server.service
[Unit]
Description=UDP Custom by HyperStack

[Service]
User=root
Type=simple
ExecStart=/root/udp/custom-linux-amd64 server -c /root/udp/config.json
WorkingDirectory=/root/udp/
Restart=always
RestartSec=2
StandardOutput=file:/root/udp/custom.log

[Install]
WantedBy=default.target
EOF

        systemctl enable custom-server.service
        systemctl start custom-server.service

        # Install Badvpn
        cd /usr/bin
        rm -rf /etc/systemd/system/udpgw.service /usr/bin/udpgw
        wget https://github.com/Hyper-21-stack/udp-custom/releases/download/V1/udpgw
        chmod 755 udpgw

        cat <<EOF >/etc/systemd/system/udpgw.service
[Unit]
Description=UDPGW Gateway Service by HyperStack
After=network.target

[Service]
Type=forking
ExecStart=/usr/bin/screen -dmS udpgw /bin/udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 1000
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

        systemctl enable udpgw.service
        systemctl start udpgw.service

        echo -e "$YELLOW"
        echo "     💚 P2P SERVICE INITIALIZED 💚     "
        echo "     ╰┈➤💚 Badvpn Activated 💚         "
        echo " ╰┈➤ 💚 HTTP CUSTOM UDP SUCCESSFULLY INSTALLED 💚       "
        echo -e "$NC"
        X
        exit 1
        ;;
    *)
        echo -e "$YELLOW"
        echo "Welcome To Resleeved Net"
        echo -e "$NC"
        exit 1
        ;;
esac
