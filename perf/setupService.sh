#!/bin/bash

mkdir -p ~/.config/systemd/user/

sed "s%WORKDIR%$(pwd)%g" uploadAndTest.service.template > ~/.config/systemd/user/uploadAndTest${1}.service
sed "s%TARGET%${1}%g" -i ~/.config/systemd/user/uploadAndTest${1}.service
cp uploadAndTest.timer ~/.config/systemd/user/uploadAndTest${1}.timer

chmod +x uploadAndTest.sh

