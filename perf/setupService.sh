#!/bin/bash

mkdir -p ~/.config/systemd/user/

sed "s%WORKDIR%$(pwd)%g" uploadAndTest.service.template > ~/.config/systemd/user/uploadAndTest.service
cp uploadAndTest.timer ~/.config/systemd/user/uploadAndTest.timer

chmod +x uploadAndTest.sh

