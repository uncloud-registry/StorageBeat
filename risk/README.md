# Risks and promises in decentralised storage

Briefly, the main risks of any storage service are: 

1. What if I can't retrieve my data? 
2. What if I get served the wrong data?
3. What if someone else sees my data when I don't want them to?

To manage these risks, you want your storage service to have good *availability*, *consistency*, and *privacy* properties, respectively. The major point of departure between centralised and decentralised services is in how customers can gain confidence that these properties will be upheld: in the former case, with reputation and legally enforced contractual obligations, and in the latter, with cryptographic commitments and chain-enforced contractual obligations.

Such properties can be reported in the form of "guarantees," which promise that the provider will pay some penalty or compensation in the event a target is not met (as in a tradcloud uptime SLA or uncloud slashing penalty), or simple "advertisements" (such as the typical "eleven nines" durability metrics reported by many cloud storage providers) that do not have any contractual obligations associated with them. Ideally, such advertisements should at least be *measurable* in the sense that a customer or third party could check the validity of the claims.

As with all computer systems, the risks and guarantees of storage systems can be best understood when software and infrastructure is open source.

## Consistency

For mutable data, defining "safety" is basically as complex as the general consistency problem in database systems. Naively, one hopes that the data retrieved reflects the *most recent* update pushed to the store. In distributed systems theory this property is known as *strong consistency*, or *strong read-after-write consistency* in S3 (https://aws.amazon.com/blogs/aws/amazon-s3-update-strong-read-after-write-consistency/). It requires a system to achieve global consensus over transaction ordering, and is generally costly or slow to achieve.

In decentralised storage, a few approaches exist to manage mutable data:

* Write it on a blockchain. Users experience the consistency model (and costs) of that blockchain — usually a probabilistic version of strong consistency where "latest" is defined by a custom blockchain scheduling mechanism (not time ordering).
* In IPNS, data is partitioned into namespaces, each managed by a single node. Because a single node manages each item, consistency issues do not occur.
* EthSwarm supports custom (non content-derived) addressing schemes that allow the construction of "feeds," that is, integer-indexed sequences of strings associated with a common topic. The most recent update is found by attempting retrieval of each element of the sequence in turn until retrieval fails.

In the case of immutable data, the definition of "safety" is that retrieved data is exactly the same as what was uploaded, a property that can be verified using checksum or other commitments. Content addressing and immutability is widespread in decentralised storage, so these checks are built in at a low level of the infrastructure. Some decentralised storage platforms (Filecoin, Arweave, and more generally the blockspace of any blockchain) only support immutable, content-addressed data.

## Availability

* Handled by SLAs in the case of tradcloud providers.
* SLAs for object storage typically measure percentage of requests that fail in a specified way (e.g. "Internal Error" response) within a five minute window. Missed SLAs are compensated by a service credit, measured as % of monthly fee.
* SLAs do not cover other types of error or timeouts, nor do they guarantee correctness of the retrieved data.

Access portal:

* Accessed via remote gateway or directly on p2p network?
* Can I access it over p2p as a fallback? (E.g. Pinata, Ardrive yes, Storj maybe no). "Escape hatch."
* **Gateway type:** local, remote (centralised), p2p fallback

### Durability

A durability failure is nothing more than an availability failure that is considered unrecoverable (or at least, unrecoverable from within the service). Typically, a durability failure stems from a provider-side incident that causes them to permanently lose access to data, for example because of hardware issues that render the backing storage media unreadable.

In centralised storage, durability is typically reported on a "nines" basis that purports to state the probability of permanently losing any given object over the period of one year (https://www.backblaze.com/blog/cloud-storage-durability/). However, cloud SLAs generally do not provide for any legal or financial backing of these claims, with responsibility for making backups outside the service formally being placed on the user (see for example S6 of https://www.hetzner.com/legal/terms-and-conditions/). 

Even detecting durability failures at the client side is not a sure thing; generally, if the client finds he cannot retrieve the data from the provider, he assumes the data is irretrievably lost. In traditional cloud storage, this information is usually known only to the client and provider, that is, there is no systematic way for a third party observer to collect data on durability failures of cloud providers. Anyway, if the reported failure rates are anywhere near accurate, they should be so rare (for example, one in a billion objects lost every 1,000 years) as to make the statistical verification of these probabilities impossible.

In decentralised storage, various cryptographic techniques have emerged that a storage provider can use to prove that they can access some data. The most basic of these is to randomly sample segments of the targeted data and form Merkle inclusion proofs. By expanding the original data with an erasure code, this sampling procedure can be set up so as to establish that the provider had access to the data at the time of proof generation with overwhelming probability.[^DAS]

[^DAS]: https://arxiv.org/abs/1809.09044

Economic incentives can then be applied to pressure the provider to generate such proofs in the future. The presence of such incentives is supposed to drive the formation of a storage provider population with the intention and capability to ensure that data remains accessible (at least to the providers) in the future. In other words, applying incentives to force providers to construct storage proofs over some future schedule allows us to limit durability failures. As a result of these techniques, the decentralised storage literature tends to place special emphasis on such cryptoeconomic durability methods (https://docs.codex.storage/learn/whitepaper#_3-decentralized-durability-engines-dde).

#### What aspects of storage proofs do we care about?

* Probability to detect failures (for plain sampling, this is non-negligible).
* Detect compression/deduplication. (i.e. does the proof show how much backing storage was used?)
* Track record: does the record of proofs show a Sybil resistant track record of good service? (No free wash trading.)
* Penalties/insurance associated with failures.

* **Storage (possession) proof type:** Sampling + inclusion proof, expansion + sampling, PoRep/PoST (Filecoin), SPoRA (Arweave).

## Privacy

Centralised service providers generally must comply with various standards (ISO etc.) governing privacy. Applicability of standards depend on the type of data, i.e. is it "personal data." Other (legal) rules may compel providers to *reveal* data to authorities.

In decentralised storage, privacy is generally approached with client-side encryption. It is often the responsibility of the user to pre-encrypt data, or at best, this step is integrated into client software. 

With standard encryption methods, read access to files is governed by possession of a single keypair; more complex sharing or access control requires more sophisticated approaches.



## Resources

### Decentralised storage

* Codex whitepaper. https://docs.codex.storage/learn/whitepaper
* Arweave
  * SPoRA. https://github.com/ArweaveTeam/arweave-standards/blob/master/ans/ANS-103.md
  * Summary. https://2-6-spec.arweave.dev/
* Swarm
  * ACT. https://docs.ethswarm.org/docs/concepts/access-control

### Cloud SLAs and T&Cs

* S3. https://aws.amazon.com/s3/sla/
* IBM Cloud. https://www.ibm.com/support/customer/csol/terms/?id=i126-9268&lc=en
* Hetzner T&Cs (see especially S6). https://www.hetzner.com/legal/terms-and-conditions/


