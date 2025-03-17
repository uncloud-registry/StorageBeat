#!/bin/bash

ARGS=${@}

systemctl --user stop $(systemd-escape --template uploadAndTest@.timer "${ARGS}")
systemctl --user disable $(systemd-escape --template uploadAndTest@.timer "${ARGS}")
