# Costs of decentralised storage

## Introduction

* Need to do conversions to get apples-to-apples comparisons
* How to report prices when there are different tiers, commitment periods
* At-rest storage and bandwidth/retrieval costs
* Other types of cost not priced explicitly by the service?

## Concepts

Make definitions and give rationale

Specify properties that would go in a StorageBeat table, like

**storage cost ($/GBmo equivalent)**: <definition>

## Data collection methodology

Considerations when obtaining pricing data



## Glossary of Columns:

* Name: Name of Service

  Sometimes a single storage ecosystem can have multiple tier types; this results in multiple names

* CommonPrice: Measured in units of $\rm \$/GB\cdot mo$, this is computed as a formula of (minimal) epoch (in months) and (miniml) rental size in $\rm GB$. 

  ​	CommonPrice = StateRent/(Epoch$\times$ UnitSize)

* UnitSize: Smallest indivisible storable string size  (in bytes)

* Epoch: Measured in months

* StateRent: Measured in USD. NB: Quite often storage on these networks is priced using a utility token numeraire. This results in us performing a market-lookup conversion. For StorageBeat we will attempt to capture daily (or finer) pricing data.

* Subsidy: TODO – capture amount of subsidy that was injected into ecosystem, essentially elucidating a type of "runway."

* Category: TODO – what is this?

* Verification: The captures the type of consensus mechanism on the network for storage. (NB: this can be different, e.g., between the Storage mechanism and the blockproduction mechanism in the case that a service is associated with its own L1; as is the case for Filecoin.)

* NumNodes: is the number of nodes

* TVL: TODO – write this correctly

* NetCap: Network Capacity, measured in Exabytes

* Consensus Takeover: TODO – write this correctly

* UtiltyToken: typical ticker symbol for the "utility token" of the service, being the token for which service deals are performed (E.g., FIL & BZZ). NB: this may or may not be the same as the governance token. 

* UtilityChain: Name of the chain on which the storage deal contracts are deployed. (E.g., Filecoin for FIL, and Gnosis Chain for EthSwarm)

* ChainType: roughly the VM-type of the chain. (e.g, EVM for EthSwarm, and FVM for Filecoin).

* GovToken: Governance Token (possibly different from utility token)

* Friction-to-Eth: TODO – figure this out

* Guarantee: Guarantee Type. TODO – give some info about differences between corporate and cryptographic storage guarantees. 

* Egress: Measured in $\rm \$/Gb \cdot mo$ (note use of Gigabits here rather than Gigabytes = Gigabits/8)

* DiskType: Most commonly used disk type for archival nodes (e.g., in FIL this is usually spinning disks and solid state for EthSwarm).

* RetrLatency: Retrieval Latency (measured immediately upon storage deal completion)

* RetrSpeed: measured at $\rm Gb/s$ (measured immediately upon storage deal completion)

* Darkness: A measure of how difficult it is for a government to request data from storage provider. TODO – add more

* CensResistance: Censorship Resistance (measured in CtC)

* DevOpsComplexity: Captures a notion of how difficult node operation at scale i

* Fixed Erasure:

* 

* ProofTypes:

* ASIC: Checked if large operator outfits tend to use these

* GPU:  Checked if large operator outfits tend to use these

* CPU:  Checked if large operator outfits tend to use these