#!/bin/bash

mkdir -p ~/.config/systemd/user/

cp uploadAndTest@.timer ~/.config/systemd/user/
sed "s%WORKDIR%$(pwd)%g" uploadAndTest@.service > ~/.config/systemd/user/uploadAndTest@.service

if [ ! -f ~/.config/environment.d/10-path.conf ]; then
    mkdir -p ~/.config/environment.d
    echo "PATH=${PATH}" > ~/.config/environment.d/10-path.conf
    systemctl --user daemon-reload
fi

chmod +x uploadAndTest.sh
