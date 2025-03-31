#!/bin/bash

cp testSequencer.timer ~/.config/systemd/user/
sed "s%WORKDIR%$(pwd)%g" testSequencer.service > ~/.config/systemd/user/testSequencer.service

chmod +x uploadAndTest.sh
chmod +x testSequencer.sh

systemctl --user enable testSequencer.timer
systemctl --user start testSequencer.timer