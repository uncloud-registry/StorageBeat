#!/bin/bash

TARGET="${1:-dryrun}"
FILESIZE="${3:-99}"
[[ ${4} != M ]] && SIZEUNIT=K || SIZEUNIT=M
ARGS=${@}

mkdir -p ~/.config/systemd/user/

sed "s%WORKDIR%$(pwd)%g" uploadAndTest.service.template > ~/.config/systemd/user/uploadAndTest_${TARGET}_${FILESIZE}${SIZEUNIT}.service
sed "s|ARGS|${ARGS}|g" -i ~/.config/systemd/user/uploadAndTest_${TARGET}_${FILESIZE}${SIZEUNIT}.service
sed "s|PARAMS|${TARGET}_${FILESIZE}${SIZEUNIT}|g" uploadAndTest.timer.template > ~/.config/systemd/user/uploadAndTest_${TARGET}_${FILESIZE}${SIZEUNIT}.timer

chmod +x uploadAndTest.sh

