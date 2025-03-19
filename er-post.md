# StorageBeat: Towards an evaluation framework for decentralised storage

**TL;DR.** We introduce the beginnings of a framework for systematically evaluating decentralised storage platforms against one another and against traditional, centralised cloud storage services. We discuss introduce summary metrics and methodology for performance measurement, costs, and risk assessment associated with different types of solution, and present a sample application of the framework in a web frontend modelled after L2Beat and WalletBeat. 

The target audience is a sophisticated user (e.g. CTO of web3 company) evaluating storage backends to support higher level services such as a software registry or CMDB.

## Background

* The decentralised storage landscape is highly fragmented.

## Costs

[aata writes]

## Performance

To properly assess performance of a storage service, the user should run benchmarking experiments based on workloads of the type he expects will be needed to assess whether availability and speed meets requirements. Many of the considerations are identical for traditional cloud and decentralised storage solutions, but for decentralised services there are reasons to expect higher variance in benchmark results under repeated trials.

Controls:

* **cache state.** Throughout the lifecycle of a request it may touch numerous layers of cache. These are difficult to control for in performance experiments, especially when they belong to systems outside the control of the experimenter (e.g. a CDN). When data is distributed across a peer-to-peer network, *propagation state* is an artefact of the same issue.
* **location and time. **Environmental factors such as request initiator location and time of day may be significant, particularly for services used by members or staff of globally distributed organisations. 
* **upload configuration.** For benchmarking downloads, the experimenter can control the way (time, location, content) in which the target data was uploaded. Linking downloaded data to specific upload metadata may entail an orchestration problem, especially if multiple initiator locations are used.

Since this is all rather complex, summary statistics such as **latency** (a.k.a. time to first byte) and **steady state throughput** can still be useful for making a quick assessment. While it is not hard to find tools to measure latency and steady state throughput (SST) of download requests, a simple heuristic can be used to estimate these with even with only raw request timings:

* Latency is approximately the time to complete a request for a very small file (e.g. a 1KiB file should fit into a single Ethernet frame, or a 4KiB into a single memory page).
* SST is approximately the ratio of the time to complete a request for a very large file to the file's size. This approximation assumes that for large files, bandwidth usage reaches a steady state, which is expected for high quality data transit services.

Finally, the **error rate** and **timeout rate** (given a fixed time limit) are both important and easy-to-understand measures of availability. For traditional cloud service providers, error code rate limits (specifically server-side HTTP 5xx codes) are usually guaranteed by an SLA which offers account credits as compensation if limits are exceeded.

In our experiments, we used the open-source tool [Artillery](https://github.com/artilleryio/artillery) to collect request completion times for various workloads at different times of day and compute summary statistics. More details are available in our GitHub repo under the [`perf/`](https://github.com/uncloud-registry/StorageBeat/tree/main/perf) directory.

## Risk

A risk framework gives us concrete risk categories and, where possible, metrics to give us an idea how likely it is that something impairs our use of the service in the future. Since risk analysis requires us to consider not only what service ought to be delivered, but also all the reasons that it might not, the risk framework actually comprises the bulk of the work of evaluating storage services.

In terms of the functioning of the storage service itself, we must consider the following questions:

* Will I be able to use the service in the future?
* Will the service function correctly in the future?

If we aren't able to use the service, the service is *unavailable.* 

Unavailability can be **local** to the data being requested, or **global** in that it affects the entire service. It can also be **temporary** or **permanent.**

* **local, recoverable.** Data is subject to errors that the provider's internal systems are able to repair. 
* **local, permanent.** The service has unrecoverably lost access to data. This is known as a **durability failure.**
* **global, temporary.** System is down temporarily and requests time out or report internal errors. Typical explanations for this type of failure are request congestion or general maintenance.
* **global, permanent.** Service has completely ceased to function, for example because the provider discontinued the service.

All four categories of risk can be mitigated by *service diversification*, a core feature of decentralised storage.

The question of *correct functioning* depends heavily on the nature of expectations about what this means.  Some basic expectations are as follows:

* Successfully uploaded content will be available for download for the extent of the contract duration.
* Retrieved content wil be "correct," where for a distributed system correctness is defined by a database *consistency model*.
* There will be no unauthorised access to the services (for example, third parties viewing the data). 

Miscellaneous risk categories:

* **Financial risk.** This includes **price risk** and **currency risk**. In decentralised storage services, both service price and, if fees are priced in a volatile asset, exchange rate can be highly volatile. The *volatility* of these price series is an easily reported (but perhaps less easily interpreted) metric.
* **Counterparty risk.** In the case of centralised services, essentially all listed risks are counterparty risks. Will the counterparty (service provider) exist in the future? Will they discontinue the contracted service? Will they breach their contract, or breach the customer's expectations of the contract?
  Decentralised services mitigate counterparty risk via *provider diversification*.
* **Contract risk.** Risk that the terms of the agreement will not be respected or enforced, or that customer expectations do not reflect the enforced terms. 
  Generally, cloud provider agreements do not actually guarantee that any service will be delivered, but only that some kind of "best effort" will be made. While availability SLAs do provide some contractual benefits in case performance is worse than some threshold, these credits are not worth much if the service is generally unavailable. 

## What now?

* Further research topics
* Call to action