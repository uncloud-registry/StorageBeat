# Data durability

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

