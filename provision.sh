#!/usr/bin/env bash

wget https://raw.github.com/hak8or/Personal_Doge_Picaxe/master/setup.sh &>>/dev/null
chmod 777 setup.sh &>>/dev/null
su -c "cd /home/vagrant && sudo ./setup.sh vagrant" vagrant
