# StorageBeat: Towards an evaluation framework for decentralised storage

**TL;DR.** We introduce the beginnings of a framework for systematically evaluating decentralised storage platforms against one another and against traditional, centralised cloud storage services. We discuss introduce summary metrics and methodology for performance measurement, costs, and risk assessment associated with different types of solution, and present a sample application of the framework in a web frontend modelled after L2Beat and WalletBeat. 

The target audience is a sophisticated user (e.g. CTO of web3 company) evaluating storage backends to support higher level services such as a software registry or CMDB.

## Background

* The decentralised storage landscape is highly fragmented.
* Early misunderstandings about what existing storage infrastructure, especially IPFS, actually offer persist.
  The most well-known decentralised storage options are targeted only at niche use cases, such as "permanent" storage or archival. Similarly, this fact does not seem to be that widely understood in the Ethereum (or general Web3) community.
* The core offerings of decentralised storage are blockchain based payment and storage contract management, cryptographically verifiabile service, and provider diversity.
* Ethereum would benefit from a systematic methodology for measuring and comparing these features. For example, how diverse is the provider landscape? What exactly does the storage proof system prove? What exactly does "availability" mean? (Despite major effort and investment in the field of *Data Availability,* the community still does not seem to agree on a definition of what it means for data to be *available*.)
* Moreover, to facilitate migration from (or hybrid usage with) traditional cloud services, where possible common metrics or features should be defined for apples-to-apples comparisons.

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

A risk framework gives us concrete risk categories and, where possible, metrics to give us an idea how likely it is that something impairs our use of the service in the future. Since risk analysis requires us to consider not only what service ought to be delivered, but also all the reasons that it might not, the risk framework actually comprises the bulk of the work of evaluating storage services. It is also the largest point of departure in the analysis of centralised versus decentalised services.

In terms of the functioning of the storage service itself, we must consider the following questions:

* Will I be able to use the service in the future?
* Will the service function correctly in the future?

If we aren't able to use the service, the service is *unavailable.*

Unavailability can be **local** to the data being requested, or **global** in that it affects the entire service. It can also be **temporary** or **permanent.** All four of the categories so defined can be mitigated by **service diversification**, a core feature of decentralised storage.

* **Global** outages are generally those that affect some service *gateway*. A single backend service can often be accessed through multiple gateways without the client needing to pay for capacity rental multiple times, offering a cost effective route to diversification. 
  A common example of this is a decentralised storage backend based on a p2p network: often, most accesses will be through a (centralised) web portal for convenience, but in case such is not available, the p2p network is always there as a fallback. The p2p network may also itself be considered a diversified network of gateways.
* **Local** outages are a consequence of data loss. A typical feature of web3 storage systems is that a system of *storage proofs* provides some assurance that data remains available to the service provider.
  A local outage that is thought to be unrecoverable is called a **durability failure**.

The question of *correct functioning* depends heavily on the nature of expectations about what this means.  Some basic expectations are as follows:

* Successfully uploaded content will be available for download for the extent of the contract duration.
* Retrieved content wil be "correct," where for a distributed system correctness is defined by a database *consistency model*.
* There will be no unauthorised access to the services (for example, third parties viewing the data). A major part of this is **privacy**, which pertains not only to unauthorised reads but also to leaking information about authorised usage.

Miscellaneous risk categories:

* **Counterparty risk.** With centralised services, all risks are counterparty risks. 
  Will the counterparty (service provider) exist in the future? Will they discontinue the contracted service? Will they breach their contract, or breach the customer's expectations of the contract?
  Decentralised services mitigate counterparty risk via provider diversification.

* **Contract risk.** Risk that the terms of the agreement will not be respected or enforced, or that customer expectations do not reflect the enforced terms. 

  The availability risks outlined above may occur either 
  Generally, cloud provider agreements do not actually guarantee that any service will be delivered, but only that some kind of "best effort" will be made. While availability SLAs do provide some contractual benefits in case performance is worse than some threshold, these credits are not worth much if the service is generally unavailable. 

* **Financial risk.** This includes **price risk** and **currency risk**. In decentralised storage services, both service price and, if fees are priced in a volatile asset, exchange rate can be highly volatile. In the case of sharp price rises, it may be no longer viable to continue with the contracted service, incurring a *migration penalty*. Similarly, if the fee asset is volatile, the client may need to maintain a balance of the asset as a hedge against future price rises, incurring a currency risk penalty.
  The *volatility* of these price series is an easily reported metric for price and currency risks.

See [`/notes/risk.md`]()

## What now?

* For teams that build or want to build with off-chain storage — what do you need to know? What's missing? What resources have you used?
* For teams building decentralised storage systems — let's work together to further refine these metrics, develop measurement methodologies, and forge a common language!

* Further research topics:
  * Research ways to measure provider *diversity* through clustering, deanonymisation, and geolocation techniques. Encourage larger scale operators to voluntarily declare their addresses in the name of transparency.
  * Develop durability model and systematic measurements of durability on decentralised systems for which it makes sense.
  * More work is needed on consistency and privacy, which we have barely addressed! If you are an expert in one of these fields, please reach out so we can work together to enhance our models.