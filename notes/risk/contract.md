# Contract risk

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

