#!/bin/bash
NYM_NODE_IP=$(curl https://api.ipify.org)
NYM_LOCAL_IP=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d '/')
NYM_VERSION=v0.10.1

sudo sed -i '/DefaultLimitNOFILE/c DefaultLimitNOFILE=65535' /etc/systemd/*.conf
sudo systemctl daemon-reexec 

sudo apt update < "/dev/null"
sudo apt install curl -y < "/dev/null"
wget -O bigsirlogo https://chinapeace.github.io/logo.sh
chmod +x bigsirlogo
./bigsirlogo
sleep 3
if [ ! $NYM_NODENAME ]; then
		read -p "Enter node name: " NYM_NODENAME
fi
echo 'Your node name: ' $NYM_NODENAME
sleep 1
echo 'export NYM_NODENAME='$NYM_NODENAME >> $HOME/.bashrc
source $HOME/.bashrc
sudo apt install make clang pkg-config libssl-dev build-essential git -y < "/dev/null"
sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env
cd $HOME
rustup update

#git clone https://github.com/nymtech/nym.git
#cd nym
#git pull
#git checkout tags/$NYM_VERSION
#cargo build --release
#sudo mv $HOME/nym/target/release/nym-mixnode /usr/bin

wget https://github.com/nymtech/nym/releases/download/$NYM_VERSION/nym-mixnode_linux_x86_64
chmod +x ./nym-mixnode_linux_x86_64
sudo mv $HOME/nym-mixnode_linux_x86_64 /usr/bin/nym-mixnode

nym-mixnode init --id $NYM_NODENAME --host $NYM_LOCAL_IP --announce-host $NYM_NODE_IP
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
sudo systemctl restart systemd-journald
sudo tee <<EOF >/dev/null /etc/systemd/system/nym-mixnode.service
[Unit]
Description=Nym Mixnode ($NYM_VERSION)

[Service]
User=$USER
ExecStart=/usr/bin/nym-mixnode run --id '$NYM_NODENAME'
KillSignal=SIGINT
Restart=on-failure
RestartSec=30
StartLimitInterval=350
StartLimitBurst=10

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable nym-mixnode
sudo systemctl stop nym-mixnode
sudo systemctl start nym-mixnode
sudo systemctl status nym-mixnode
sudo journalctl -u nym-mixnode -n 100 -o cat
sudo journalctl -u nym-mixnode -o cat |grep "Started Nym Mixnode" -A20|tail -20 >> $HOME/nym-mixnode_info.log
cat $HOME/nym-mixnode_info.log

#journalctl -u nym-mixnode -f
