# Risks and promises in decentralised storage

Briefly, the main risks of any storage service are: 

1. What if I can't upload or retrieve my data? 
2. What if I get served the wrong data?
3. What if someone else sees my data when I don't want them to?

To manage these risks, you want your storage service to have good *availability*, *consistency*, and *privacy* properties, respectively. The major point of departure between centralised and decentralised services is in how customers can gain confidence that these properties will be upheld: in the former case, with reputation and legally enforced contractual obligations, and in the latter, with cryptographic commitments and chain-enforced contractual obligations.

Such properties can be reported in the form of "guarantees," which promise that the provider will pay some penalty or compensation in the event a target is not met (as in a tradcloud uptime SLA or uncloud slashing penalty), or simple "advertisements" (such as the typical "eleven nines" durability metrics reported by many cloud storage providers) that do not have any contractual obligations associated with them. Ideally, such advertisements should at least be *measurable* in the sense that a customer or third party could check the validity of the claims.

As with all computer systems, the risks and guarantees of storage systems can be best understood when software and infrastructure is open source.

## Availability

Availability is the property that the desired services — storage and retrieval — can be exercised successfully in a timely manner from a desired initiator. When evaluating a storage platform for future or continued usage, storage customers may wish to *measure current* availability and *forecast future* availability, or *durability*, of the service.

### Measuring availability

In tradcloud, availability is usually stated in terms of a bound on the rate of certain types of errors in a rolling time interval. Provider obligations include a service-level agreement (SLA) that guarantees, for example, that at most proportion $p\ll 1$ of requests in a monthly rolling window return an internal error.[^sla-example] Missed SLAs are compensated by a service credit, measured as % of monthly fee. The SLAs do not tend to cover timeouts or other types of errors, so that in principle the provider could avoid triggering these clauses by simply failing to respond to requests when an internal error would otherwise occur.

[^sla-example]: For example, see https://aws.amazon.com/s3/sla/

To the best of our knowledge, no decentralised storage platform offers any quantifiable availability SLA. On the other hand, p2p network based platforms in principle offer much higher *provider* or *portal* diversification, since the client always has the option of running their own p2p node and retrieving data from a long list of peers. 

We distinguish portal diversification as meaning that there are multiple access points to the same storage backend. An example would be a web gateway to a p2p storage service such as a blockchain; in the event that the gateway provider becomes unavailable, the client may spin up a node and connect directly to the p2p backend as a fallback. Moreover, fallback is built into the structure of a p2p network itself: if one's current peer list won't provide the desired service, a node can attempt to connect to new peers as a fallback. On the other hand, mirroring content across two tradcloud storage providers is not portal diversification: the data is stored in two separate platforms, and the client must pay twice for capacity rental.

We introduce the following evaluation criteria:

* **Availability SLA.** Contractual; e.g. 99% non-error rate (monthly rolling). Or none.
* **Observed availability.** Can be measured over time and space in terms of error or timeout rate.
* **Access point.** Web, p2p

At time of writing, either of these criteria effectively classifies services into "centralised" or "decentralised."


### Data durability

A data durability failure is nothing more than an availability failure that is considered unrecoverable (or at least, unrecoverable from within the service). That is, a durability failure carries with it an expectation that the lost data will not become available in the future. A prototypical durability failure arises when a provider-side incident causes them to permanently lose access to data, for example because of hardware issues that render the backing storage media unreadable.

In centralised storage, durability is typically reported on the so-called "nines" basis that purports to state the probability of permanently losing any given object over the period of one year.[^backblaze] However, cloud SLAs generally do not provide for any legal or financial backing of these claims, with responsibility for making backups outside the service formally being placed on the user.[^hetzner-durability] 

[^backblaze]: https://www.backblaze.com/blog/cloud-storage-durability/
[^hetzner-durability]: See for example S6 of https://www.hetzner.com/legal/terms-and-conditions/. 

Client-side detection of durability failures at the client side is not a sure thing. Generally, if the client finds he cannot retrieve the data from the provider, he assumes the data is irretrievably lost. In traditional cloud storage, this information is usually known only to the client and provider, that is, there is no systematic way for a third party observer to collect data on durability failures of cloud providers. Anyway, if the reported failure rates are anywhere near accurate, they should be so rare — for example, one in a billion objects lost every 1,000 years — as to make the statistical verification of these probabilities impossible.

In decentralised storage, various cryptographic techniques have emerged that a storage provider can use to prove that they can access some data. The most basic of these is to randomly sample segments of the targeted data and construct and publish inclusion proofs. By expanding the original data with an erasure code, this sampling procedure can be set up so as to establish that the provider had access to the full dataset at the time of proof generation with overwhelming probability.[^DAS]

[^DAS]: https://arxiv.org/abs/1809.09044

Economic incentives can then be applied to pressure the provider to generate such proofs in the future. The presence of such incentives is supposed to drive the formation of a storage provider population with the intention and capability to ensure that data remains accessible, at least to the providers, in the future. In other words, applying incentives to force providers to construct storage proofs over some future schedule gives us confidence that there will be few durability failures. Because these techniques are unique to the decentralised model, the decentralised storage literature tends to place special emphasis on such cryptoeconomic durability methods.[^codex-durability] 

[^durability]: https://docs.codex.storage/learn/whitepaper#_3-decentralized-durability-engines-dde

Evaluation criteria:

* **Extrapolated object loss rate.** 
  For centralised providers, this is a reported threshold in the form of an unbacked, unsubstantiated promise. 
  For decentralised platforms, there are some methods to extrapolate a loss rate from observations of missed storage proofs. 
* **Storage proof properties.** There are several dimensions that may be relevant to clients:
  * What is the probability of detecting missing data?
  * Does the proof system detect compression/deduplication? That is, does it show that the claimed expansion factor is actually preserved in the backend?
  * Track record: does the record of proofs show a Sybil (wash trading) resistant track record of good service?
  * Storage proof type: Sampling + inclusion proof, expansion + sampling, PoRep/PoST (Filecoin), SPoRA (Arweave).
* **Insurance.** What compensation can a storage client receive in case of durability failures?
  Platforms may report the *slashing penalty* associated with a durability failure, which may include some amount that is not necessarily refunded to the uploader. However, it is difficult to deduce concrete predictions about durability from these figures.

### Provider durability

An extreme form of durability failure is a failure of the service itself, accompanied by the de facto expiry of all commitments. How do storage clients gain confidence that their service provider will not simply disappear in the future?

* *Estimating sustainability.* Storage clients may use information about the provider such as reputation, size metrics, years in operation, or profit reports to make forecasts about the continuation of services.
* *Diversification.* The risk of provider failure can be diversified by replicating or expanding data across multiple providers. This process is expedited by common APIs and fair egress charges, which can be facilitated by industry cooperation or regulation.[^eu-storage-liquidity]
  A distinguishing feature of many decentralised storage platforms is that dispersal across multiple providers happens automatically and is completely transparent to the user.

[^eu-storage-liquidity]: For example an EU working group has developed recommendations in this direction: https://digital-strategy.ec.europa.eu/en/library/study-presenting-assessments-codes-conduct-data-porting-and-cloud-switching

Evaluation criteria:

* **Platform size.** *number of nodes, total data stored, years of operation, total revenue.* For centralised platforms, typically only *years in operation* is publicly known.
* In case of decentralised platforms, **supply market concentration** measures such as *number of controlling entities* or *HH index* are of interest in assessing diversification.

### Contract risk

The major contract risk for a consumer of a storage service is that payment is made but the desired service is not provided. We therefore discuss such risks under the general heading of "availability."

Contract risks can manifest in a number of ways, none of which are particularly special to the case of data storage:

* *Contract refusal.* Service provider refuses to enter into a contract.
* *Contract alteration.* Service provider unilaterally adjusts the terms of the contract.
* *Contract breach.* Service provider enters into a contract, but defaults on their commitments — for example, fails to acknowledge or pay indemnity for missed SLA.
* *Provider impairment.* Service provider ceases to function and cannot provide the service. This could be viewed as a kind of ultimate durability failure.

Of these, some are clearly more likely to be of real concern than others. For example, contract refusal is probably a less likely outcome in the case of cloud storage than it is, say, for opening a bank account. Others, such as contract alteration, apply equally to any sort of contract; we do not have anything special to say about this in the setting of data storage.

On the matter of breach of contract and provider impairment, we do have something to say:

* If storage service commitments can be verified by cryptographic or cryptoeconomic means — such as in the case of durability guarantees by storage proof discussed above — then the risk of contract breach by the service provider can be mitigated or transparently insured.
* Decentralised is specifically geared to address the risk of service provider impairment (and to some extent service refusal or general availability problems). Consumers might also use information about the provider such as size, profitability, or years in operation to estimate the durability of the service itself.

## Consistency

In the case of immutable data, the definition of "consistency" is that retrieved data is exactly the same as what was uploaded, a property that can be verified using checksum or other commitments. Content addressing and immutability is widespread in decentralised storage, so these checks are built in at a low level of the infrastructure. Some decentralised storage platforms (Filecoin, Arweave, and more generally the blockspace of any blockchain) only support immutable, content-addressed data. On the other hand, content-addressable centralised storage solutions appear to be uncommon, except when explicitly advertised as associated to some decentralised backend.

For mutable data, we are faced with the general consistency problem in database systems. Naively, one hopes that the data retrieved reflects the *most recent* update pushed to the store. In distributed systems theory this property is known as *strong consistency*, or *strong read-after-write consistency* in S3.[^s3-consistency] It requires a system to achieve global consensus over transaction ordering, and is generally costly or slow to achieve.

[^s3-consistency]: https://aws.amazon.com/blogs/aws/amazon-s3-update-strong-read-after-write-consistency/

In decentralised storage, a few approaches exist to manage mutable data:

* Write it on a blockchain. Users experience the consistency model (and costs) of that blockchain — usually a probabilistic, forkable version of strong consistency where "latest" is defined by a custom blockchain scheduling mechanism.
* In IPNS, data is partitioned into namespaces, each managed by a single node. Because a single node manages each item, consistency issues do not occur.
* EthSwarm supports custom (non content-derived) addressing schemes that allow the construction of "feeds," that is, integer-indexed sequences of strings associated with a common topic. The most recent update is found by attempting retrieval of each element of the sequence in turn until retrieval fails.

In summary, the **consistency model** of a storage service can be divided into checksummed *immutable* services, those offering a traditional consistency model like *strong read-after-write* consistency, and some emerging non-traditional consistency models such as those offered by blockchain/DLT consensus mechanisms.

## Privacy

For this discussion, we consider only privacy in the limited sense of "external actors cannot read the objects a client uploads without permission."

Centralised service providers generally must comply with various standards (ISO etc.) governing privacy. Applicability of standards depend on the type of data, i.e. is it "personal data." Other (legal) rules may compel providers to *reveal* data to authorities.

In decentralised storage, privacy is generally approached with client-side encryption. It is often the responsibility of the user to pre-encrypt data, or at best, this step is integrated into client software. 

With standard encryption methods, read access to files is governed by possession of a single keypair; more complex sharing or access control requires more sophisticated approaches.

## Resources

### Decentralised storage

* IPFS
* Filecoin
* Codex whitepaper. https://docs.codex.storage/learn/whitepaper
* Arweave
  * SPoRA. https://github.com/ArweaveTeam/arweave-standards/blob/master/ans/ANS-103.md
  * Summary. https://2-6-spec.arweave.dev/
* Swarm
  * ACT. https://docs.ethswarm.org/docs/concepts/access-control
* Others: Crust, Walrus, Jackal

### Immutable storage

* AWS S3 Object lock for compliance. 
  https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock.html#object-lock-retention-modes

### Standards relevant to privacy

* ISO 27001
* ISO 27018 https://aws.amazon.com/compliance/data-privacy-faq/
* AICPA SOC [2]. Controls at a service organization relevant to security, availability, processing integrity, confidentiality, or privacy.
  https://d1.awsstatic.com/whitepapers/compliance/AWS_SOC3.pdf
* ISO 22301
* HIPAA (Health Insurance Portability and Accountability Act). Lawful use and disclosure of protected health information in the United States.
* PCI DSS (Payment Card Industry Data Security Standard)

### Cloud SLAs and T&Cs

* S3 SLA. https://aws.amazon.com/s3/sla/
* IBM Cloud SLA. https://www.ibm.com/support/customer/csol/terms/?id=i126-9268&lc=en
* Hetzner T&Cs (see $\S$6 for terms concerning durability failures). https://www.hetzner.com/legal/terms-and-conditions/




> ==TODO: Availability can mean different things to different audiences/consumers. E.g., a CDN may be entrusted with data and be expected to provide reasonable access times independent of the geolocation of an http-requester. Alternatively, for on-chain computations, accessing off-chain data is—without exception—extremely cumbersome. The latter requires the notion of a data oracle.== 
>
> The notion of availability in the on-chain case is multi-dimensional: (1) Is the backend online (in the sense of being connected to the internet), (2) can the backend provider move their data $v$ into a block within reasonable time, so that, e.g., it can be used in an on-chain function call ${\tt f}(v)$. It should be noted that one shouldn't assume that it would become the norm that backend providers are also the same agents that bridge the data to chain. ==It seems much more likely (akin to PBS-type separation of roles) that oracles and bridge providers will compete for customers independent of their backends. (TODO: Is this actually try?  need to think [aata])== Along this line of thought, it seems a notion of logistical/economic "friction-to-chain" can capture the issues outlined above in addition to an economic angle. (E.g., there exist reasonable mechanisms such that paying more could yield higher probabilities of the requested data appearing in, say, the next block, essentially de-risking the request.) In summary availability related risks can occur from:
>
> * block inclusion probabilities
> * utility token price surges
> * chain-native gas price surges
>
> ==TODO: do we need to describe this block inclusion business?==