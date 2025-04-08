# Prerequisites

* Node >22
* Artillery (`npm install -g artillery@latest`)
* Kubo IPFS gateway node (https://docs.ipfs.tech/install/command-line/#install-official-binary-distributions) is running
* Pinata CLI (`curl -fsSL https://cli.pinata.cloud/install | bash`) with Pinata account setup
* Local Swarm node (Bee) is running with account setup and having some stamps
* swarm-cli (`npm install -g @ethersphere/swarm-cli`)
* ardrive-cli (`npm install -g ardrive-cli`)
* Arweave wallet with some credits
* MinIO client (`wget https://dl.min.io/client/mc/release/linux-amd64/mc`) for S3.

# Setup environment
1. Copy `upload_env.sh.template` into `upload_env.sh`
1. Populate values in `upload_env.sh`
1. `chmod +x upload_env.sh`

# Run test once
`./uploadAndTest.sh $TARGET $FILENUM $FILESIZE $SIZEUNIT`
Where 
* `$TARGET` is in (ipfs, swarm, arweave, s3)
* `$FILENUM` is number files to be uploaded and used in test
* `$FILESIZE` is size of each file in KB or MB
* `$SEZEUNIT` is unit used in `$FILESIZE`. Either K or M.

This will upload files into selected target then create a transenient timer ro run a corresponding benchmark in 1 hour.
Both payload and report files are saved in `tests/` directory.

# Setup job to run test periodically
## Using timer for each job
```
./prepareServiceTempl.sh
./setupServiceTempl.sh $TARGET $FILENUM $FILESIZE $SIZEUNIT
```
- OR -
```
./setupService.sh $TARGET $FILENUM $FILESIZE $SIZEUNIT
```
Both methods will schedule a job to run every 24 hours from the moment the script is executed. The difference is that the first method uses template unit files (so there will only be one copy of the file with multiple instances of timers for each workload) while the second method creates a timer and service files for each workload. The first method is cleaner (since there is only one file for all the jobs), the second method gives more control over scheduling. 

## Using sequencer
Alternatively, use a sequencer script that will run a test every 2 hours, each time with a different workload (configured in the script):
```
./prepareServiceTempl.sh
./setupTestSequencer.sh
```
Workload sequence is configured inside `./testSequencer.sh`. Example:
```
targets=("ipfs" "arweave" "swarm" "s3")
loads=("100 100 K" "100 1 M" "100 10 M" "1 100 M")
loadsArweave=("10 100 K" "100 100 K" "10 1 M" "1 10 M")
```
Note that Arweave has different workloads (as per test design [spec](spec.md)). Currently the number of workloads for Arweave and other files must be the same for the script to run correctly.

# Artillery test scripts
There are 3 different test scripts for Artillery:
`StorageBeat.yml` - Default one. Runs all the users (downloads) concurrently with a new user arriving every 2 seconds (can be configured)
`StorageBeatLimit.yml` - Limits the concurrency to maximum 5 downloads at the same time. Generates less load still provding concurency.
`StorageBeatSeq.yml` - No concurrency, all the files are downloaded sequentially by one user

To change the script modify `TESTSCRIPT` variable in `./uploadAndTest.sh`.
To change the rate of users arriving modify the `duration` and `arrivalCount` parameters in `OVERRIDES` variable.
For sequential test `OVERRIDES` variable must be empty.

To run Artiller script by itself:
```
artillery run -e $TARGET -v '{"payload":'$PAYLOAD_CSV'"}' --overrides '{"config":{"phases":[{"duration":'$DURATION',"arrivalCount":'$FILENUM'}]}}' $TESTSCRIPT
```
where `$TARGET` is in (ipfs, swarm, arweave, s3), `$PAYLOAD_CSV` is a relative path to payload CSV file, `$DURATION` is time is seconds for how long Artillery will generate new users (default is 2*FILENUM), `$FILENUM` is number of files to be downloaded (usualy corresponds to the number of entries in payload file). User arrival will be `$FILENUM/$DURATION` users per second. `$TESTSCRIPT` is one of the scripts mentioned above. For `StorageBeatSeq.yml` `--overrides` part should be removed from the command.


