#!/bin/bash

targets=("ipfs" "arweave" "swarm" "s3")
loads=("100 100 K" "100 1 M" "100 10 M" "1 100 M")
loadsArweave=("10 100 K" "100 100 K" "10 1 M" "1 10 M")

COUNTERS=$(cat sequenceCounter)
read -r TARGET_COUNTER LOAD_COUNTER <<< "${COUNTERS}"
TARGET=${targets[${TARGET_COUNTER}]}

if [ ${TARGET} == "arweave" ]; then
    LOAD=${loadsArweave[${LOAD_COUNTER}]}
else
    LOAD=${loads[${LOAD_COUNTER}]}
fi

TARGET_COUNTER=$((++TARGET_COUNTER%${#targets[@]}))

if [ ${TARGET_COUNTER} -eq 0 ]; then
    LOAD_COUNTER=$((++LOAD_COUNTER%${#loads[@]}))
fi
echo "${TARGET_COUNTER} ${LOAD_COUNTER}" > sequenceCounter

systemctl --user start $(systemd-escape --template uploadAndTest@.service "${TARGET} ${LOAD}")