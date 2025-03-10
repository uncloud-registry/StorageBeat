#!/bin/bash

if [ "$#" -gt 0 ]; then
  TARGET=$1
else
  TARGET=dryrun
fi

. upload_env.sh

TESTSCRIPT=StorageBeat.yml
TIMESTAMP=$(date +%s)

mkdir -p tests
rm -f tests/current_payload_${TARGET}.csv

# $1 is target, $2 is random file id
upload() {
  case $1 in
    swarm)
      STAMP=$(swarm-cli stamp list --least-used --limit 1 --quiet --hide-usage)
      UPLOAD="swarm-cli upload tests/random_data_file_${2} --stamp $STAMP | awk '/hash/ {print \$3}'"
      ;;
    arweave)
      UPLOAD="ardrive upload-file --local-path tests/random_data_file_${2} -F $ARDRIVE_WALLE -w $ARDRIVE_WALLET --turbo | jq -r '.created[0].dataTxId'"
      ;;
    s3)
      # Actual upload
      mc -q cp tests/random_data_file_$2 $S3_PATH/
      # Getting download link
      UPLOAD="mc share download --expire 2h $S3_PATH/random_data_file_${2} | grep Share | sed 's/.*\/\/[^\/]*\///'"
      ;;
    *)
      UPLOAD="echo $1, file random_data_file_${2}"
      ;;
  esac

  eval "$UPLOAD"
}

for i in {1..2}; do
  dd if=/dev/urandom of=tests/random_data_file bs=1K count=99
  #get fileid from first alpha numeric symbols in generated file
  FILEID=$(tr -dc A-Za-z0-9 < tests/random_data_file | head -c 13)
  cp tests/random_data_file tests/random_data_file_${FILEID}
  upload $TARGET $FILEID >> tests/current_payload_${TARGET}.csv
done

cp tests/current_payload_${TARGET}.csv tests/payload_${TARGET}_${TIMESTAMP}.csv

if [ $TARGET != "dryrun" ]; then
  systemd-run --user --on-active=60 -d artillery run -o tests/${TIMESTAMP}_${TARGET}_test.json -q -e $TARGET -v '{"payload":"tests/current_payload_'${TARGET}'.csv"}' $TESTSCRIPT 
else
  echo artillery run -o tests/${TIMESTAMP}_${TARGET}_test.json -q -e $TARGET -v '{"payload":"tests/current_payload_'${TARGET}'.csv"}' $TESTSCRIPT
fi