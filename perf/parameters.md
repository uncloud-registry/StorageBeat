# Design

## Services

* Arweave (via arweave.net gateway)
  Or ArDrive via Turbo?
* Swarm (via local node)
* Pinata over IPFS (via local Kubo node)
* Hetzner S3

## Workloads

* For each workload, sample fresh entropy from `/dev/urandom` to generate all files.

* Workloads are download only.

* Files for a download workload are uploaded 1 hour before running the job.

* Upload takes place from the same device that will run the download. (SUBJECT TO CHANGE)

* File sizes:

  ```
  100K
  1M
  10M
  100M
  1G
  ```

* Request counts:

  ```
  [1, 10, 100, 1000]
  ```

* Maximum workload size = 1G (may increase this later). Therefore the full workload parameter grid is
  ```
  (100K,1)	(100K,10)	(100K,100)	(100K,1000)
  (1M,1)		(1M,10)		(1M,100)	(1M,1000)
  (10M,1)		(10M,10)	(10M,100)
  (100M,1)	(100M,10)
  (1G,1)	// 15 items
  ```

  

* Arweave storage is quite expensive, so we only run tests for a maximum workload size of 10M.

  (See also the docs, which only suggest up to 12MiB will be accepted by nodes: https://docs.arweave.org/developers/arweave-node-server/http-api#transaction-format)
  Parameter grid for Arweave:

  ```
  (100K,1)	(100K,10)	(100K,100)
  (1M,1)		(1M,10)	
  (10M,1)	// 6 items
  ```

* Requests are made concurrently with a spacing of [1s, 10s]

## Deployment

* All workloads are run from one cloud instance in Europe and one in Asia. We use Hetzner Cloud and Fedora 41.
* All workloads are run every hour, triggered by a systemd timer. Data is appended to a log file or sequence of log files.