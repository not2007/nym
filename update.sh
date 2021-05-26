NYM_VERSION=0.10.1
NYM_NODE_ID=

sudo journalctl -u nym-mixnode -o cat |grep "Started Nym Mixnode" -A20|tail -20

sleep 3
if [ ! $NYM_NODE_ID ]; then
		read -p "Enter node name: " NYM_NODE_ID
fi
echo 'Your node name: ' $NYM_NODE_ID
sleep 1

sudo systemctl stop nym-mixnode.service
wget https://github.com/nymtech/nym/releases/download/v$NYM_VERSION/nym-mixnode_linux_x86_64
chmod +x ./nym-mixnode_linux_x86_64
sudo mv nym-mixnode_linux_x86_64  /usr/bin/nym-mixnode
nym-mixnode upgrade --id $NYM_NODE_ID
sudo systemctl start nym-mixnode.service
