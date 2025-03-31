#!/bin/bash

ARGS=${@}

systemctl --user enable $(systemd-escape --template uploadAndTest@.timer "${ARGS}")
systemctl --user start $(systemd-escape --template uploadAndTest@.timer "${ARGS}")
systemctl --user start $(systemd-escape --template uploadAndTest@.service "${ARGS}")
