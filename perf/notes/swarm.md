# Upload specifics
* Files are uploaded using swarm-cli
* Least used Stamp is used for each upload

# Download specifics
* Local Bee node is used for downloads

# Notes
1. Local Bee node has quite high RAM consumption. Especially when running parallel downloads. This was discovered when running a test that downloads many large file with virtual users arriving every second (i.e. every second a new dowload is starting). Since there was not enough time for download to finish before the next virtual user arrivel it resulted in many files being downloaded in parrallel leading to a snowball effect. On the machine with low RAM (4GB) this resulted in the Bee node crushing or refusing connections with Out of Memory errors
1. When downloading large files in sequence we had to introduce 30 seconds pause between files otherwise after about 10-15 files there were "connection refused" errors
1. Sometimes download speed drops significantly (to 100 KB/s and less) for no obvious reason (can be network load peaking). After sometime it returns to normal by itself. 
1. Wait time for the first byte if significantly higher than with S3 and Arweave. It can especially be seen on the tests that use small file sizes