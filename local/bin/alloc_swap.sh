#! /bin/sh

set -e
sudo touch $1
sudo truncate -s 0 $1
# sudo chattr +C $1
sudo fallocate -l $2G $1
sudo chmod 0600 $1
sudo mkswap $1
sudo swapon $1
