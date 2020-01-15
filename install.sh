#!/usr/bin/env bash

# Setup for Ubuntu 16.04 VPS

FRPDIR=$GOPATH/src/github.com/fatedier/frp
SETDIR=$(pwd)

if hash go 2>/dev/null; then
    echo "Go found"
else
    echo "Installing Go..."
    sudo add-apt-repository ppa:longsleep/golang-backports -y 
    sudo apt update
    sudo apt-get install golang-1.12 -y
    echo PATH="$PATH:/usr/lib/go-1.12/bin" | sudo tee /etc/environment
    source /etc/environment
fi

if [ -z "$GOPATH" ]; then
    echo "Set go path in shell rc before continuing..."
    exit
else
    echo "GOPATH set"
fi

if [ ! -d $"frp/cmd" ]; then
    echo "git submodules were not downloaded"
    echo "Downloading frp..."
    git submodule update --init --recursive

fi

echo "Compiling frp..."
mkdir -p $FRPDIR
cp -r frp/* $FRPDIR
cd $FRPDIR && make

echo "Installing frp in /opt..."
sudo mkdir -p /opt/frp
sudo cp -r bin/frp* /opt/frp
sudo cp -r conf/frp*.ini /opt/frp

echo "Installing systemd service files..."
cd $SETDIR
sudo cp systemd/* /etc/systemd/system
sudo systemctl daemon-reload



