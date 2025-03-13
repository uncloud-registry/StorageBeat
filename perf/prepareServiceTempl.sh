#!/bin/bash

mkdir -p ~/.config/systemd/user/

cp uploadAndTest@.timer ~/.config/systemd/user/
sed "s%WORKDIR%$(pwd)%g" uploadAndTest@.service > ~/.config/systemd/user/uploadAndTest@.service

chmod +x uploadAndTest.sh
