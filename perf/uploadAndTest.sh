#!/bin/bash

TESTSCRIPT=StorageBeat.yml
TIMESTAMP=$(date +%s)

mkdir -p tests
rm -f tests/current_payload.csv

STAMP=$(swarm-cli stamp list --least-used --limit 1 --quiet --hide-usage)
for i in {1..2}; do
  dd if=/dev/urandom of=tests/random_data_file bs=1K count=99
  swarm-cli upload tests/random_data_file --stamp $STAMP | awk '/hash/ {print $3}' >> tests/current_payload.csv
done

cp tests/current_payload.csv tests/${TIMESTAMP}_swarm_payload.csv

systemd-run --user --on-active=60 -d artillery run -o tests/${TIMESTAMP}_swarm_test.json -q -e swarm -v '{"payload":"tests/current_payload.csv"}' $TESTSCRIPT  