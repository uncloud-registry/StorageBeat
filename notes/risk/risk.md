# Availability risk framework


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

An extreme form of durability failure is a failure of the service itself, accompanied by the de facto expiry of all commitments. How do storage clients gain confidence that their service provider will not simply disappear in the future? In practice, clients use information about the provider such as reputation, size metrics, years in operation, or profit reports to make forecasts about the continuation of services.

Evaluation criteria:

* **Platform size.** *number of nodes, total data stored, years of operation, total revenue.* 
  For centralised platforms, typically only *years in operation* is publicly known.
* **Reputation.** Not really quantifiable

### Provider diversity

The risk of provider failure can be diversified by replicating or expanding data across multiple providers. This process is expedited by common APIs and fair egress charges, which can be facilitated by industry cooperation or regulation.[^eu-storage-liquidity]
A distinguishing feature of many decentralised storage platforms is that dispersal across multiple providers happens automatically and is completely transparent to the user.

[^eu-storage-liquidity]: For example an EU working group has developed recommendations in this direction: https://digital-strategy.ec.europa.eu/en/library/study-presenting-assessments-codes-conduct-data-porting-and-cloud-switching

In case of decentralised platforms, **supply market concentration** measures such as *number of controlling entities* or *HH index* are of interest in assessing diversification.

### Gateway diversity

p2p network based platforms in principle offer much higher *provider* or *portal* diversification, since the client always has the option of running their own p2p node and retrieving data from a long list of peers. 

We distinguish portal diversification as meaning that there are multiple access points to the same storage backend. An example would be a web gateway to a p2p storage service such as a blockchain; in the event that the gateway provider becomes unavailable, the client may spin up a node and connect directly to the p2p backend as a fallback. Moreover, fallback is built into the structure of a p2p network itself: if one's current peer list won't provide the desired service, a node can attempt to connect to new peers as a fallback. On the other hand, mirroring content across two tradcloud storage providers is not portal diversification: the data is stored in two separate platforms, and the client must pay twice for capacity rental.

We introduce the evaluation criterion

* **Gateway.** Web, p2p, or web with p2p fallback.

The existence of a p2p backend could be taken as a definition of "decentralised," though as we have observed that is not the whole story.

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

### Cost risk

What if the price of the service goes up a lot after the client has become dependent on it?




> ==TODO: Availability can mean different things to different audiences/consumers. E.g., a CDN may be entrusted with data and be expected to provide reasonable access times independent of the geolocation of an http-requester. Alternatively, for on-chain computations, accessing off-chain data is—without exception—extremely cumbersome. The latter requires the notion of a data oracle.== 
>
> The notion of availability in the on-chain case is multi-dimensional: (1) Is the backend online (in the sense of being connected to the internet), (2) can the backend provider move their data $v$ into a block within reasonable time, so that, e.g., it can be used in an on-chain function call ${\tt f}(v)$. It should be noted that one shouldn't assume that it would become the norm that backend providers are also the same agents that bridge the data to chain. ==It seems much more likely (akin to PBS-type separation of roles) that oracles and bridge providers will compete for customers independent of their backends. (TODO: Is this actually try?  need to think [aata])== Along this line of thought, it seems a notion of logistical/economic "friction-to-chain" can capture the issues outlined above in addition to an economic angle. (E.g., there exist reasonable mechanisms such that paying more could yield higher probabilities of the requested data appearing in, say, the next block, essentially de-risking the request.) In summary availability related risks can occur from:
>
> * block inclusion probabilities
> * utility token price surges
> * chain-native gas price surges
>
> ==TODO: do we need to describe this block inclusion business?==