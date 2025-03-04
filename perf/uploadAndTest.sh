#!/bin/bash

WORKDIR=~/perftest/
TESTSCRIPT=~/storagebeat/StorageBeat/perf/StorageBeat.yml
TIMESTAMP=$(date %s)

cd $WORKDIR
rm -f current_payload.csv

STAMP=$(swarm-cli stamp list --least-used --limit 1 --quiet --hide-usage)
for i in {1..2}; do
  dd if=/dev/urandom of=./random_data_file bs=1K count=99
  swarm-cli upload random_data_file --stamp $STAMP | awk '/hash/ {print $3}' >> current_payload.csv
done

cp current_payload.csv ${TIMESTAMP}_swarm_payload.csv

systemd-run --user --on-active=60 artillery run -o ${TIMESTAMP}_swarm_test.txt -q -e swarm -v '{"payload":"current_payload.csv"}' $TESTSCRIPT  