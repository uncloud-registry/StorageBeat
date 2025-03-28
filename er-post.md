# StorageBeat: Towards an evaluation framework for decentralised storage

**TL;DR.** We introduce the beginnings of a framework for systematically evaluating decentralised storage platforms against one another and against traditional, centralised cloud storage services. We introduce summary metrics and methodology for performance measurements, costs, and risk assessments associated with different types of solution, and present a sample application of the framework in a web frontend modelled after L2Beat and WalletBeat. 

The target audience is a sophisticated user (e.g. CTO of a web3 or web3-curious company) evaluating storage backends to support higher level services such as a software registry or CMDB.

## Background

* The decentralised storage landscape is highly fragmented.
* Early misunderstandings about what existing storage infrastructure, especially IPFS, actually offer persist.
  The most well-known decentralised storage options are targeted only at niche use cases, such as "permanent" storage or archival. Similarly persistent is this fact does not seem to be that widely understood in the Ethereum (or general Web3) community.
* The core offerings of decentralised storage are blockchain based payment and storage contract management, cryptographically verifiabile service, and provider diversity.
* Ethereum would benefit from a systematic methodology for measuring and comparing these features. For example, how diverse is the provider landscape? What exactly does the storage proof system prove? What exactly does "availability" mean? Despite major effort and investment in the field of *Data Availability,* the community still does not seem to agree on a definition of what it means for data to be *available*.)
* Moreover, to facilitate migration from (or hybrid usage with) traditional cloud services, where possible common metrics or features should be defined for apples-to-apples comparisons.
* This post is an overview of the elements the StorageBeat team feel should enter into an evaluation framework for decentralised storage. More in-depth exposition and technical details on each element can be found in our GitHub repository: https://github.com/uncloud-registry/StorageBeat/tree/main/notes

## Costs

[aata writes]

## Performance

To assess performance of a storage service, the user should run benchmarking experiments based on workloads of the type he expects will be needed to assess whether availability and speed meets requirements. Most of the basic considerations in benchmarking decentralised services are the same as for traditional cloud, and it is beyond the scope of this post to go into the many dimensions of cloud benchmark design and implementation.[^benchmark-book] Instead, apart from a comment on nondeterminism we simply describe the statistics we have chosen for StorageBeat. For further details of the rationale we developed for our experiments, see [`./perf/README.md`](https://github.com/uncloud-registry/StorageBeat/blob/main/perf/README.md).

[^benchmark-book]: For a textbook treatment of the subject, see https://link.springer.com/book/10.1007/978-3-319-55483-9

While **nondeterminism** in the state of external systems is already an issue for tradcloud services, there are reasons to expect qualitative differences in the shapes of distributions of performance metrics in decentralised storage. First, in principle, the provider diversification offered by decentralised storage systems should help reduce variance in performance measurements. On the other hand, the lower barrier to entry for providers on decentralised storage markets probably means the variability for each individual provider is much higher than tradcloud hyperscalers. In practice, we observe higher variance in measurements of the less mature decentralised storage platforms.

Since tracking and reporting performance across many workloads and control scenarios is rather complex, for publicly communicating performance measurements it is helpful to quote simple summary statistics. In our sample website we have quoted estimates of mean **latency** (a.k.a. time to first byte) and **steady state throughput**[^sst-def] (SST). For benchmark portability reasons, we estimate these as the request completion time for a very small file and the mean download speed of a request for a large file, respectively.

Finally, the **error rate** and **timeout rate** (given a fixed time limit) are both important and easy-to-understand measures of availability. For traditional cloud service providers, error code rate limits (specifically server-side HTTP 5xx codes) are usually guaranteed by an SLA which offers account credits as compensation if limits are exceeded.

In our experiments, we used the open-source tool [Artillery](https://github.com/artilleryio/artillery) to collect request completion times for different workloads. More details are available in our GitHub repo under the [`perf/`](https://github.com/uncloud-registry/StorageBeat/tree/main/perf) directory.

[^sst-def]: https://glossary.atis.org/glossary/steady-state-throughput/

## Risk

A risk framework gives us concrete risk categories and, where possible, metrics to give us an idea of how likely it is that something impairs our use of the service in the future. Since risk analysis requires us to consider not only what service ought to be delivered, but also all the reasons that it might not, the risk framework actually comprises the bulk of the work of evaluating storage services. 

It is also the largest point of departure in the analysis of centralised versus decentalised services: the core offering of the latter is a way to mitigate risks through **diversification**.

In terms of the functioning of the storage service itself, we must consider the following questions:

* Will I be able to use the service in the future?
* Will the service function correctly in the future?

### Availability

If we aren't able to use the service, the service is *unavailable.* Unavailability can be local to the data being requested, or global in that it affects the entire service. It can also be temporary or permanent.

The risk of global outages can be mitigated in the following ways:

- **SLA.** A service-level agreement provides an indemnity for some type of service failure. Tradcloud services typically offer compensation for an *error rate* exceeding a certain limit, e.g. 99% in a five minute window.[^s3-sla]

- **Survival.** Global, permanent outages arise when a service provider ceases operations. To mitigate this, estimate the survival probability of each service provider over the desired service period and allocate to providers with higher scores.

- **Diversification** of service providers. 

  * *Backend diversity.* When data is split and distributed among multiple backend storage providers, the risk of correlated failure is reduced. The effect is stronger when providers are diverse along multiple axes (jurisdiction, locality, technology, corporate structure, etc.).
  * *Gateway diversity.* A single backend service can often be accessed through multiple gateways without the need for replicating capacity rental; gateway diversification can therefore be a cost-effective route to risk reduction. For example, one can access many decentralised storage services through a third party web gateway for convenience, but in case such is not available, the p2p network is available as a fallback. The p2p network may also itself be considered a diversified network of gateways.

  We don't have a simple numerical measure that captures diversification, but measuring the entropy of various distributions — such as capacity share per provider — can give a preliminary indication.

Local outages are a consequence of data loss. A typical feature of web3 storage systems is that a system of **storage proofs** provides some assurance that data remains available to the service provider. A local outage that is thought to be unrecoverable is called a **durability failure**.

1. Storage services ought to essentially never lose data. It can therefore be challenging to put a credible number to object loss rate on reasonably stable services.
   Tradcloud services report durability on the "nines" basis, where object loss rate per year is bounded by a power of ten. Though the basic methodology to achieve these numbers is documented,[^backblaze] such reports are not usually backed up by evidence or legal guarantees.[^hetzner-durability]
   In decentralised cloud, the global rate of node failure or data loss can be observed by tracking missed storage proofs. The tradcloud methodology could then be applied to extrapolate the observed rate to a formal probability of losing a replicated or otherwise expanded object distributed over the node population.[^codex]
2. A service provider may publish storage proofs as evidence that they retain access to the data at that point. Attaching explicit incentives to storage proof publication is supposed to foster a population of providers who strive to retain access to client data in the future so that they may claim these incentives. Incentives may be in the form of revenue or the threat of collateral seizure ("slashing").

[^s3-sla]: https://aws.amazon.com/s3/sla/
[^backblaze]: https://www.backblaze.com/blog/cloud-storage-durability/
[^hetzner-durability]: See $\S$6 of https://www.hetzner.com/legal/terms-and-conditions/
[^codex]: https://docs.codex.storage/learn/whitepaper#_3-decentralized-durability-engines-dde

### Correctness

The question of *correct functioning* depends heavily on the details of the service definition.  Some basic expectations are as follows:

* Successfully uploaded content will be available for download for the extent of the contract duration.
* Retrieved content wil be "correct," where for a distributed system correctness is defined by a database *consistency model*. There are various consistency models arising in practice in decentralised storage:
  * For **immutable** storage, consistency simply means that the data retrieved under an address is exactly what was uploaded. In practice, this consistency can be validated with a content commitment (checksum, hash). If storage is **content-addressed**, as is often the case for decentralised storage, then the validation of such commitments is built in to the basic infrastructure.
  * Tradcloud storage offerings typically offer **strong** consistency, which guarantees that retrieved data always reflects the *most recent* update, where recency is understood according to some globally (within the service) defined ordering.
  * Blockchain state, or other decentralised mutable storage offerings such as Swarm feeds, offers a more exotic consistency model that depends on the mechanism by which the system settles on transaction inclusion and ordering. Finding ways to report the consistency properties of such systems is an open area of research.
* There will be no unauthorised access to the services (for example, third parties viewing the data). A major part of this is **privacy**, which pertains not only to unauthorised reads but also to leaking information about authorised usage. Though there is undoubtedly much to say on this subject, we have not investigated it deeply.

### Generic service risk categories

Considerations within these categories apply to all decentralised services, not storage specific.

* **Counterparty risk.** With centralised services, all risks are counterparty risks. Cryptoeconomic incentives, smart contract enforcement, and counterparty diversification allow many counterparty risks to be mitigated on decentralised platforms.
* **Contract risk.** Risk that the terms of the agreement will not be respected or enforced, or that customer expectations do not reflect the enforced terms. For centralised services, they are counterparty risks. For decentralised services, they may be replaced with *smart contract risk* which is a risk of incorrect implementation of the contract semantics.
* **Financial risk.** This includes **price risk** and **currency risk**. In decentralised services, both service price and, if fees are priced in a volatile asset, exchange rate is often highly volatile. In the case of sharp price rises, it may be no longer viable to continue with the contracted service, incurring a migration penalty. Similarly, if the fee asset is volatile, the client may need to maintain a balance of the asset as a hedge against future price rises, incurring a currency risk penalty.
  The *volatility* of these price series is an easily reported metric for price and currency risks.

See [`/notes/risk/`]() for more detailed notes.

## What now?

* For teams that build or want to build with off-chain storage — what do you need to know? What's missing? What resources have you used to gather information?
* For teams building decentralised storage systems — let's work together to further refine these metrics, develop measurement methodologies, and forge a common language.
* What we'd like to see: more hybrid models! Centralised cloud services that provide storage proofs! Decentralised platforms with an availability SLA and (something approaching) strong consistency for mutable data!

* Further research topics:
  * Research ways to measure provider *diversity* through clustering and geolocation techniques. Encourage larger scale operators to voluntarily declare their addresses in the name of transparency.
  * Develop durability model and carry out systematic measurements of durability on decentralised systems for which it makes sense.
  * More work is needed on consistency and privacy, which we have barely addressed! If you are an expert in one of these fields, please reach out so we can work together to enhance our models.