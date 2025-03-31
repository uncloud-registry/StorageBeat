## Price

* UnitSize: Smallest indivisible storable string size  (in bytes)

* Epoch: Measured in months

* StateRent: Measured in USD. NB: Quite often storage on these networks is priced using a utility token numeraire. This results in us performing a market-lookup conversion. For StorageBeat we will attempt to capture daily (or finer) pricing data.

* CommonPrice: Measured in units of $\rm \$/GB\cdot mo$, this is computed as a formula of (minimal) epoch (in months) and (miniml) rental size in $\rm GB$. 

  ​	CommonPrice = StateRent/(Epoch$\times$ UnitSize)

* Transit price.

  * Upload/download. (Arweave charges to "upload + store" but not to download.)
  * Egress (may be different price to cross "domain boundary")
  * Measured in $\rm \$/Gb$ (note use of Gigabits here rather than Gigabytes = Gigabits/8) or fixed monthly cost for auto-renewing quota

## Service availability

* CensResistance: Censorship Resistance (measured in CtC)

## Consistency

* 
* Verification: The captures the type of consensus mechanism on the network for storage. (NB: this can be different, e.g., between the Storage mechanism and the blockproduction mechanism in the case that a service is associated with its own L1; as is the case for Filecoin.)

## Size metrics

* NumNodes: is the number of nodes

* TVL: TODO – write this correctly

* NetCap: Network Capacity, measured in Exabytes

* Consensus Takeover: TODO – write this correctly

## Convenience

* Friction-to-Eth: TODO – figure this out
* DevOpsComplexity: Captures a notion of how difficult node operation at scale i
* UtiltyToken: typical ticker symbol for the "utility token" of the service, being the token for which service deals are performed (E.g., FIL & BZZ). NB: this may or may not be the same as the governance token. 
* UtilityChain: Name of the chain on which the storage deal contracts are deployed. (E.g., Filecoin for FIL, and Gnosis Chain for EthSwarm)

* ChainType: roughly the VM-type of the chain. (e.g, EVM for EthSwarm, and FVM for Filecoin).

## Performance

* RetrLatency: Retrieval Latency (measured immediately upon storage deal completion)
* RetrSpeed: measured at $\rm Gb/s$ (measured immediately upon storage deal completion)

## Internal details

* DiskType: Most commonly used disk type for archival nodes (e.g., in FIL this is usually spinning disks and solid state for EthSwarm).Darkness: A measure of how difficult it is for a government to request data from storage provider. TODO – add more
* ASIC: Checked if large operator outfits tend to use these
* GPU:  Checked if large operator outfits tend to use these
* CPU:  Checked if large operator outfits tend to use these
* GovToken: Governance Token (possibly different from utility token)