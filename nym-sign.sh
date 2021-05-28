#!/bin/bash
NYM_NODE_IP=$(curl api.ipify.org)
NYM_LOCAL_IP=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d '/')

if [ ! $NYM_NODENAME ]; then
		read -p "Enter node name: " NYM_NODENAME
fi
echo 'Your node name: ' $NYM_NODENAME
sleep 2

read -p "Enter telegram name: " TELEGRAM_NAME
echo 'Your telegram name: ' $TELEGRAM_NAME
sleep 2

echo "nym-mixnode sign --id $NYM_NODENAME --text @TELEGRAM_NAME"
nym-mixnode sign --id $NYM_NODENAME --text @TELEGRAM_NAME

read -p "Wait for claim finished: " OK
read -p "Wait for create address in https://web-wallet-finney.nymtech.net"
read -p "Wait for faucet finished: " OK
read -p "Wait for bond finished: " OK

echo "nym-mixnode init --id yudishen --host $NYM_LOCAL_IP --announce-host $NYM_NODE_IP"
nym-mixnode init --id yudishen --host $NYM_LOCAL_IP --announce-host $NYM_NODE_IP

sudo systemctl restart nym-mixnode.service
