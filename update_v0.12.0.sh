NYM_VERSION=v0.12.0
NYM_NODE_IP=$(curl api.ipify.org)
NYM_LOCAL_IP=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d '/')

echo 'Your node ip: ' $NYM_NODE_IP
echo 'Your local ip: ' $NYM_LOCAL_IP
echo 'gym version: ' $NYM_VERSION
sleep 6

# sudo journalctl -u nym-mixnode -o cat |grep "Started Nym Mixnode" -A20|tail -20


if [ ! $NYM_NODENAME ]; then
    read -p "Enter node name: " NYM_NODENAME
fi
echo 'Your node name: ' $NYM_NODENAME
sleep 1

sudo rm nym-mixnode
wget https://github.com/nymtech/nym/releases/download/$NYM_VERSION/nym-mixnode
chmod +x ./nym-mixnode
sudo mv nym-mixnode /usr/bin/nym-mixnode

read -p "Enter your-punk-wallet-address: " PUNK_ADDRESS

sudo systemctl stop nym-mixnode.service
echo "nym-mixnode init --id $NYM_NODENAME --host $NYM_LOCAL_IP --announce-host $NYM_NODE_IP --wallet-address $PUNK_ADDRESS"
nym-mixnode init --id $NYM_NODENAME --host $NYM_LOCAL_IP  --announce-host $NYM_NODE_IP --wallet-address $PUNK_ADDRESS
nym-mixnode upgrade --id $NYM_NODENAME

sudo systemctl start nym-mixnode.service
echo "sudo systemctl restart nym-mixnode.service"

nym-mixnode node-details --id $NYM_NODENAME

journalctl -u nym-mixnode -f
