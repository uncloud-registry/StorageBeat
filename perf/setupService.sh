#!/bin/bash

TARGET="${1:-dryrun}"
FILESIZE="${3:-99}"
[[ ${4} != M ]] && SIZEUNIT=K || SIZEUNIT=M
ARGS=${@}
BMARK=${TARGET}_${FILESIZE}${SIZEUNIT}

mkdir -p ~/.config/systemd/user/

sed "s%WORKDIR%$(pwd)%g" uploadAndTest.service.template > ~/.config/systemd/user/uploadAndTest_${BMARK}.service
sed "s|ARGS|${ARGS}|g" -i ~/.config/systemd/user/uploadAndTest_${BMARK}.service
sed "s|PARAMS|${BMARK}|g" uploadAndTest.timer.template > ~/.config/systemd/user/uploadAndTest_${BMARK}.timer

chmod +x uploadAndTest.sh

