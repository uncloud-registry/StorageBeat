#!/bin/bash

TARGET="${1:-dryrun}"
FILENUM="${2:-2}"
FILESIZE="${3:-99}"
[[ ${4} != M ]] && SIZEUNIT=K || SIZEUNIT=M
ARGS=${@}
BMARK=${TARGET}_${FILENUM}_${FILESIZE}${SIZEUNIT}

mkdir -p ~/.config/systemd/user/

sed "s%WORKDIR%$(pwd)%g" uploadAndTest.service > ~/.config/systemd/user/uploadAndTest_${BMARK}.service
sed "s|ARGS|${ARGS}|g" -i ~/.config/systemd/user/uploadAndTest_${BMARK}.service
sed "s|PARAMS|${BMARK}|g" uploadAndTest.timer > ~/.config/systemd/user/uploadAndTest_${BMARK}.timer

if [ ! -f ~/.config/environment.d/10-path.conf ]; then
    mkdir -p ~/.config/environment.d/10-path.conf
    echo "PATH=${PATH}" > ~/.config/environment.d/10-path.conf
    systemctl --user daemon-reload
fi

chmod +x uploadAndTest.sh

systemctl --user enable uploadAndTest_${BMARK}.timer
systemctl --user start uploadAndTest_${BMARK}.timer

