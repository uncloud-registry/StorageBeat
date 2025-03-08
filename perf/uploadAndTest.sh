#!/bin/bash

if [ "$#" -gt 0 ]; then
  TARGET=$1
else
  TARGET=swarm
fi

TESTSCRIPT=StorageBeat.yml
TIMESTAMP=$(date +%s)

mkdir -p tests
rm -f tests/current_payload_${TARGET}.csv

case $TARGET in
  swarm)
    STAMP=$(swarm-cli stamp list --least-used --limit 1 --quiet --hide-usage)
    UPLOAD="swarm-cli upload tests/random_data_file --stamp $STAMP | awk '/hash/ {print \$3}'"
    ;;
  arweave)
    . arweave_env.sh
    UPLOAD="ardrive upload-file --local-path tests/random_data_file -F $ARDRIVE_WALLE -w $ARDRIVE_WALLET --turbo | jq -r '.created[0].dataTxId'"
    ;;
esac


for i in {1..2}; do
  dd if=/dev/urandom of=tests/random_data_file bs=1K count=99
  eval "$UPLOAD" >> tests/current_payload_${TARGET}.csv
done

cp tests/current_payload_${TARGET}.csv tests/payload_${TARGET}_${TIMESTAMP}.csv

systemd-run --user --on-active=60 -d artillery run -o tests/${TIMESTAMP}_${TARGET}_test.json -q -e $TARGET -v '{"payload":"tests/current_payload_'${TARGET}'.csv"}' $TESTSCRIPT  