# StoragePerf

## Goals

* Define an experimental framework to compare the performance characteristics of both centralised and various types of decentralised storage services on an equal footing.
* Demonstrate the framework by implementing and deploying it against a selection of services.
* Publish statistics for community consumption.

## Project management

### Tasks

- [x] Develop rationale and commit to this repo. @awmacpherson
  - [x] First feedback cycle.
- [x] Establish experimental design + commit.
- [ ] Implement benchmark suite. @eshavkun
  - [ ] Tidy up source directory. Put scripts, yaml, units, templates etc. into their own subdirectories.
- [x] Select target services + commit.
- [x] Obtain quotas + access and share.
- [ ] Run benchmarks + collect results.
  - [x] Prepare shared directory `/var/perf/` on experiment runner.
  - [ ] Generate usable 1x100M samples (at least 30)
  - [ ] Why are some tests showing up on Artillery Cloud but not in the shared directory?
  - [ ] Evaluate whether individual download times can be extracted from the 50x100M sequential workloads (and if so, extract them).
- [ ] Documentation.
  - [ ] Technical notes on integration with each of the four target services. (Implementation details + log.)
  - [ ] Evaluation of results. @mac

## Design rationale

We address the following questions:

1. What measurements do we take? Can we use estimation as a substitute for measurement?
   Do we test fast failure? Time to error? Do we distinguish types of errors?
   Should we measure per request time? Throughput at different points within a single request?
2. What are the hypotheses and what statistical tests do we need to carry out?
3. What controls are needed?
   Do we control for time of day/week? Traffic?
   Geolocation?
   Can we control for the state of remote caches?
4. What is the structure of a workload? 
   How broad a range of workloads can we parametrise?
   How are workloads scheduled? Do we allow concurrent requests? 

We will parametrise our trials by applying various "workloads" to various "services."

Each `Service` should support a common interface that can be tested against a range of `Workload`s. In this way, `Service`s may be considered on an equal footing.

### Services

* Each `Service` should support a range of data sizes, i.e. support roughly the interface of an object store. Fixed size storage such as a block store is generally not possible to test on equal footing, as different block stores may not support the same sizes of data.

* We won't benchmark file system operations, so a file interface (i.e. directories and directory listings) is not needed. The object store tests are informative for users whose use case employs a filesystem.

* We can only realistically benchmark end-to-end performance of a full storage service. As well as the backend, tests potentially depend on the designs of intermediate layers like gateway caches and client implementations. Hence, the description of the `Service` should acknowledge the full tech stack used.

* The front-end interface of a `Service` that will be invoked directly by our experiments could take several forms:
  1. A web API served over HTTP locally or remotely.
  2. Local invocation of a binary implementing a custom protocol (e.g. IPFS).
  3. A custom communications protocol (e.g. libp2p, 0MQ) integrated at the driver level.
  
  All of the services we will test in v1 are accessible via an HTTP API.

### Workloads

A `Workload` consists of a number of scheduled download requests of specified sizes.

* Data for workloads is all randomly generated on a per trial basis (as in Bocchi, 2014).
* In the current version, we won't test uploads because of difficulties in making sense of when an upload is "finished" in decentralised storage platforms.
* For each workload, we will measure time to completion and error rate.
* We may also be interested in more detailed speed metrics such as TTFB and max throughput. Our proposal is to infer this kind of information from the total request times of various workloads.

**Schedules.** To be fully general, a workload should be able to consist of any number of requests for any number of different files, on an arbitrary schedule, with any number of repetitions, from any geographic location to any endpoint. 

Defining fully general schedules is a weighty task, so we restrict to considering schedules that are:

* Triggered at a certain time of day and day of the week (to control for seasonality);
* All requests are for unique data;
* All requests are of the same size;
* Requests arrive at a constant rate;
* Requests have the same origin.

By default, requests and the ensuing sessions are allowed to be concurrent. We do not use the end of a session (e.g. by a completed download) as an event trigger.

```rust
struct Workload { 
    requests: u64;
    request_size: u64;
    request_spacing: TimeDelta
}
```



## Controls

When designing experiments, we should try to control for environmental factors as much as possible. Controls that can be implemented by the experiment designer include:

* *Client configuration, gateway, service tier.* Perhaps obvious, but experiments must take care to control for the service and client configuration. For tradcloud providers, service configuration includes the data of which service tier is selected. In decentralised cloud, the experimenter must specify which gateway is used, whether third party or self-hosted.
* *Location and time.* Environmental factors such as request initiator location and time of day may be significant for performance. Location and time controlled metrics may be important for services used by members of globally distributed teams.
* *Upload configuration.* For benchmarking downloads, the experimenter can control the way (time, location, content) in which the target data was uploaded. Linking downloaded data to specific upload metadata may entail an orchestration problem, especially if multiple initiator locations are used.

### Geolocation

In (Bocchi, 2014), the authors expend some efforts to figure out where in the world service endpoints are located and the routes that packets travel to reach them. Round trip times (RTT) are tested and plotted. 

As they point out:

> Storage providers strongly encourage users to select the closest end-point to their location in order to reduce data latency and to offload the public Internet.

For a CTO interested in running a service available to a geo-distributed userbase, it is not reasonable to expect all users to be positioned close to a single server; the CTO is interested in the *full range* of performance possibilities in all locations in which the service will be accessed.

For general decentralised storage services, the download performance may well depend on where the content was uploaded. This is especially true if content or metadata does not reach a "stable" state of propagation across the p2p network, independent of upload location. (Note: uploading and downloading from different locations requires some coordination between distinct nodes that wouldn't otherwise be needed.)

### Seasonality

In case of seasonal effects (essentially exogenous traffic, but possibly also node liveness), samples should be taken at all times of day and all days of the week. To illustrate this, in our demo we run workloads at each hour of the day.

### Cache state

It is difficult to control for the state of remote caches, but we can try to reason about it in terms of known cache policies and then try to run workloads over a range that spans cache condition boundaries.

* LRU cache. Objects remain in cache until it is full, after which oldest objects are excised. Caches may be tracked per user or global.
  To trigger an LRU cache boundary, additional traffic must be generated on different objects on the same node. This approach may not make much sense for a decentralised storage protocol.
* Time based. Objects that haven't been accessed for a certain amount of time are excised. To trigger, upload data and wait different amounts of time before testing download.

On a p2p network, the extent of information propagation could be regarded as a kind of cache state. Upload location (more precisely, peer list of the upload node) and time since upload may be a significant factor.

## Analysis

### Measurements

The most basic measurements we can make are:

* Time to complete a workload;
* Failure rate, or more specifically, rate of each possible request outcome (success, HTTP error code, timeout...).

There are other, more fine-grained quantities that we might try to measure or estimate — for example, time to first byte, or time to complete each request in a workload. 

* If a workload is meant to simulate multiple users interacting with the service in one session, time to complete requests arriving at different stages of the workload might be useful to simulate the user experience of being at different stages of a demand spike.
  Measuring this is no more difficult than measuring full workload length, but there are more parameters to keep track of.
* Time to first byte might be relevant to understanding how to configure connection timeouts. One might consider it relevant for assessing the performance on workloads with small request size, but that is even better assessed by actually running the workloads of interest.

Generally, when deciding whether to attempt measurement or estimation, there are some tradeoffs to consider.

* Measurement may not be practical with the available tools;
* Even if available, subtle differences in the way that measurement is done can make results incomparable or unreproducible.

### Failure modes

How do we test *failed* downloads? How do we determine if a download has failed? Should we track different failure conditions?

The assumption that all tests make HTTP requests provides a useful framework for defining failure modes.

* If we are testing HTTP endpoints, then it is up to us to fix HTTP client settings such as timeout and retries since these can affect when and sometimes whether a request is deemed to have failed (in the case of no response).
  On the other hand, a response with 400+ code would generally be interpreted as a type of failure.
* To assess failure modes, it may be useful to set up tests where the *expected* result is failure, e.g. requesting a blob we know not to be available.

### Estimation

For values that we decide not to attempt to measure --- for example, because of limitations in the available tooling --- we can instead attempt to estimate using the measurements we did make.

*Time to complete each request.* If we have a total of $n$ requests arriving at a rate of one per $k$ seconds, and the $i$th request completes in $t_i$ seconds, then the total time $T$ to workload completion is
$$
\max\{t_i+ik \mid i =1,\ldots,n \}.
$$
By running the workload with different numbers of requests, we can fit a parametric model to the numbers $t_i$. But who cares: we had to detect when each request terminated, which is tantamount to measuring each $t_i$, in order to measure $T$ anyway.

*Time to first byte.* This is just the limit of small request size.

*Plotting throughput over time.* Similarly, suppose we run $N$ trials that each make a single request for $B_n$ bytes and complete in time $t_n$. Working in continuous time, if $s(t)$ denotes the throughput in bytes per second at time $t$, then we have
$$
B_n = \int_0^{t_n}s(t)dt.
$$
If we assume $s$ belongs to some $k$-parameter family of functions $f(\theta_1,\ldots,\theta_k; t)$, then we ought to be able to fit $s$ by judiciously choosing $k$ values of $B_n$ to use as interpolation points.

### Statistical inference

A typical engineering approach to these benchmarks might be to running test a number of times and compute the sample mean, perhaps as well as outliers, sample variance, and quantiles. To determine if download speeds satisfy some desired property, plot visualisations of the results and eyeball it.

Given the decision variable "the service we will use for task Z," in some cases a more rigorous approach to statistical inference may be justified. For example, if the service based on this backend will offer a performance SLA, our CTO may wish to perform a hypothesis test to establish that the backend satisfies the SLA on 99% of workloads within some range.

To do statistical inference, we would need to:

1. Pick a reference family of distributions (prior distribution, if using Bayesian methods) for the retrieval time. (As a first guess, gamma distribution seems applicable?)
2. Formulate a hypothesis, e.g. "pulls satisfy SLA with at least 95% probability" and use standard methods to set up a hypothesis test. 
3. Use statistical power analysis to determine the number of samples to take.

Since it may not be reasonable to expect our CTO to have a statistician on team to design this statistical apparatus, we should aim to propose standard approaches and rules of thumb that can be mechanically applied to the problem.

## Resources

### Bibliography

* Bocchi, E., Mellia, M., & Sarni, S. (2014). Cloud storage service benchmarking: Methodologies and experimentations. 2014 IEEE 3rd International Conference on Cloud Networking (CloudNet), 395–400. https://doi.org/10.1109/CloudNet.2014.6969027

  [Link to PDF](https://infoscience.epfl.ch/record/200923/files/Cloud%20Storage%20Service%20Benchmarking_%20Methodologies%20and%20Experimentations.pdf)

* Drago, I., Bocchi, E., Mellia, M., Slatman, H., & Pras, A. (2013). Benchmarking personal cloud storage. ACM Internet Measurement Conference (ACM IMC 2013), 205–212. https://doi.org/10.1145/2504730.2504762

  [Link to PDF](https://conferences.sigcomm.org/imc/2013/papers/imc092-dragoA.pdf)
  Contains discussion of cloud storage capabilities and architecture.
