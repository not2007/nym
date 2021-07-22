NYM_VERSION=v0.11.0
NYM_NODE_IP=$(curl api.ipify.org)
NYM_LOCAL_IP=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d '/')

echo 'Your node ip: ' $NYM_NODE_IP
echo 'Your local ip: ' $NYM_LOCAL_IP
echo 'gym version: ' $NYM_VERSION
sleep 3

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

echo "nym-mixnode upgrade --id $NYM_NODENAME"
nym-mixnode upgrade --id $NYM_NODENAME

echo "nym-mixnode init --id $NYM_NODENAME --host $NYM_LOCAL_IP --announce-host $NYM_NODE_IP"
nym-mixnode init --id $NYM_NODENAME --host $NYM_LOCAL_IP  --announce-host $NYM_NODE_IP

read -p "Enter telegram name: " TELEGRAM_NAME
read -p "Enter your-punk-wallet-address: " PUNK_ADDRESS

echo "nym-mixnode sign --id $NYM_NODENAME --text @your_telegram_username your-punk-wallet-address"
nym-mixnode sign --id $NYM_NODENAME --text "@$TELEGRAM_NAME $PUNK_ADDRESS"

read -p "wait for telegram callback: " OK

sudo systemctl start nym-mixnode.service

echo "sudo systemctl restart nym-mixnode.service"
