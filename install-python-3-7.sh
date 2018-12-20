#!/bin/sh

sudo apt-get install -y build-essential libffi-dev
sudo apt-get install libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev
cd /usr/src
sudo wget https://www.python.org/ftp/python/3.7.1/Python-3.7.1.tar.xz
sudo tar xf Python-3.7.1.tar.xz
cd Python-3.7.1
sudo ./configure --enable-optimizations
sudo make altinstall
python3.7 -V
