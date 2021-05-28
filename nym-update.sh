NYM_VERSION=v0.10.1
sudo journalctl -u nym-mixnode -o cat |grep "Started Nym Mixnode" -A20|tail -20

sleep 3
if [ ! $NYM_NODENAME ]; then
		read -p "Enter node name: " NYM_NODENAME
fi
echo 'Your node name: ' $NYM_NODENAME
sleep 1

sudo systemctl stop nym-mixnode.service
wget https://github.com/nymtech/nym/releases/download/$NYM_VERSION/nym-mixnode_linux_x86_64
chmod +x ./nym-mixnode_linux_x86_64
sudo mv nym-mixnode_linux_x86_64  /usr/bin/nym-mixnode
nym-mixnode upgrade --id $NYM_NODENAME
sudo systemctl start nym-mixnode.service
