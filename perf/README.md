# StoragePerf

## Goals

* Define an experimental framework to compare the performance characteristics of both centralised and various types of decentralised storage services on an equal footing.
* Demonstrate the framework by implementing and deploying it against a selection of services.
* Publish statistics for community consumption.

## Rationale

* We will parametrise our experiments by applying various "workloads" to various "services."

  Each `Service` should support an interface that can be tested against a range of `Workload`s. In this way, `Service`s may be considered on an equal footing.
* Published outputs should include throughput statistics with quantile error bars (at, say, 95%).

  We may also fit a simple statistical model (e.g. normal) and publish parameter estimates. Fitting this model should help construct a rationale for choosing the number of trials to run in each experiment.
* We must attempt to control for geographical location. The simplest approach is to run all experiments from the same location.

### Services

* Each `Service` should support a range of data sizes, i.e. support roughly the interface of an object store. Fixed size storage such as a block store is generally not possible to test on equal footing, as different block stores may not support the same sizes of data.
* For simplicity, we won't benchmark file system operations, so a file interface (i.e. directories and directory listings) is not needed. The object store tests are informative for users whose use case employs a filesystem.
* We can only realistically benchmark end-to-end performance of a full storage service. As well as the backend, tests potentially depend on the designs of intermediate layers like gateway caches and client implementations. Hence, the description of the `Service` should acknowledge the full tech stack used.
* The front-end interface of a `Service` that will be invoked directly by our experiments could take several forms:
  1. A web API served over HTTP locally or remotely.
  2. Local invocation of a binary implementing a custom protocol (e.g. IPFS).
  3. A custom communications protocol (e.g. libp2p, 0MQ) integrated at the driver level.

### Workloads

* A `Workload` comprises a number of back-to-back download requests of a certain size, for example 100 requests to retrieve 10MiB.
* Data for workloads is all randomly generated on a per trial basis (as in Bocchi, 2014).
* In the current version, we won't test uploads because of difficulties in making sense of when an upload is "finished" in decentralised storage platforms.
* In the current version, we also don't test concurrent requests.
* For each workload, we will measure time to completion and error rate.
* We may also be interested in more detailed speed metrics such as TTFB and max throughput. Our proposal is to infer this kind of information from the total request times of various workloads.

## Project management

### Tasks

- [ ] Develop rationale and commit to this repo. @awmacpherson
  - [ ] First feedback cycle.
- [ ] Establish experimental design + commit.
- [ ] Implement benchmark suite. @eshavkun
- [ ] Select target services + commit.
- [ ] Obtain quotas + access and share. (How?)
- [ ] Run benchmarks. (Where should we save outputs?)

## Resources

### Bibliography

* Bocchi, E., Mellia, M., & Sarni, S. (2014). Cloud storage service benchmarking: Methodologies and experimentations. 2014 IEEE 3rd International Conference on Cloud Networking (CloudNet), 395–400. https://doi.org/10.1109/CloudNet.2014.6969027

  [Link to PDF](https://infoscience.epfl.ch/record/200923/files/Cloud%20Storage%20Service%20Benchmarking_%20Methodologies%20and%20Experimentations.pdf)

* Drago, I., Bocchi, E., Mellia, M., Slatman, H., & Pras, A. (2013). Benchmarking personal cloud storage. ACM Internet Measurement Conference (ACM IMC 2013), 205–212. https://doi.org/10.1145/2504730.2504762

  [Link to PDF](https://conferences.sigcomm.org/imc/2013/papers/imc092-dragoA.pdf)
