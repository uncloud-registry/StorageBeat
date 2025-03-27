

## Costs

### Background on costs

In storage ecosystems there are storage providers (SPs) and storage consumers (SCs). Storage consumers engage in a type of rental contract for capacity on some type of storage "fabric." That is, SCs pay SPs to hold data. But moreover, customers are often (interested in) paying for the ability to *correctly* retrieve their data within a timeframe which is meaningful or useful to them. On the supply side, costs are driven by the cost of storage media, bandwidth, electricity, data centre real-estate markets, labour and electricity prices, to name a few exogenous variables. Storage ecosystems compete with each other to provide services to the addressable consumer storage market, which itself is highly segmented:

* **Glacial.** Immutable data stored for immensely long periods of time (e.g., on the order of decades)
* **CDN-like**. Customers who strore low-to-high frequency mutated content, but wish to have both low latency and high-bandwidth with only little dependence on geolocation of the requesters 
* **Online Filesync**. "Dropbox-like," high availability + high mutability/consistency, not much weighting on bandwidth or geolocation issues. Access Control Lists (ACLs) provided permissioned access to content is important to this user-base.

On the consumption side, SCs can expect to evaluate costs (e.g., \$/GB-mo) for capacity rental, costs for egress (\$GB-/mo), as well as perceptions of data durability at the provider. Here is a good time to point out that it is not meaningful to attempt to linearly rank service providers "across the board." Service providers will tend to cluster at "peaks" of a Pareto boundary curve; and likewise the addressable market will similarly be segmented accordingly. (This is a standard phenomenon in economic game theory.) 

**Subsidies.** It is common across both startup tradcloud providers and startup web3 decentralized storage ecosystems to introduce absurdly low rates for storage (sometimes even grandfathering in early adopters). A simplified profit model is 

$ {\rm Profit}_{\rm total}(k) = \textrm{(grandfathered losses)}(k) + \sum_{\tau \in \rm tiers} \mathrm{profit}_\tau(k)$ 

where as epoch (e.g., say year) $k$ grows the losses are either dwarfed by the profits from new tears and/or the grandfathered losses "wither away," e.g, by early adopters leaving the system. Subsidies are first introduced into the systems from early investors (e.g. IPOs / ICOs) and some level of financial and actuarial sophistication is used to forecast the usage of the system in a way that profits eventually outweigh operating costs. 

In decentralized ecosystems, a word can be said about the difference in the way the subsidies are consumed. In the decentralized world quite often storage ecosystems (and any ecosystem in general) offers node operator (NO) programs, where DevOps complexities are managed by consultation free information sharing amongst node operators, as well as consumption of subsidies for running costs, offsetting what might be unsatisfactory "mining" rewards.

One important part of the current work was determining how to compare the following three types of services:

* Tradcloud storage providers
* Hybrid corporate + decentralized endeavor
* Finite duration decentralized storage ecosystems
* Quasi-permanent decentralised systorage ecosystems (ie systems which purport to have infinite duration storage)

There are a number of things that can be done to compare "apples-to-apples" in order to make sense of purportedly quasi-permanent data storage claims. Ignoring future discounted cash flows an "effective perceived market length" (in number of service epochs)

### Egress.

It is quite the norm in tradcloud situation that enterprise customers must think seriously about their egress costs. All typical Big Cloud / Big Storage providers mention egress charges and/or capacities in the SLAs. In the decentralised ecosystems egress is a bit less clear. Some systems, e.g.., NKN & Swarm do discuss micropayments for providing a transport layer  to ferry packets, rewarding  those nodes who participate in the routing protocol. 

Empirically the authors have not yet seen much usage out of such systems and have little data on such micropayment services. On the other hand, when, e.g., data is stored on, say, the Swarm DHT it is  typically easily retrievable and payments by the requester  are not necessary for retrieval. (It should be noted, that in tradcloud scenario the requester also is not assumed to carry the burden of paying for egress.)

Nevertheless, it is pertinent to discuss egress conditions in p2p networks as well. Just like in tradcloud cases there are idiosyncratic subtleties involved but we hope to condense this material and relegate it to Performance Measurements sections and GitHub. 

Our study uses `artillery`  test-battery tool for *live* measuring of **steady-state throughput** (SST)  and **latency** (average time to download smallest datagram). These appear as columns in the StorageBeat front-end.

See Payments section below. 

### Quasi-permanence vs Finite Duration Services

To deal with quasi-permanence there are at least a couple of ways that can be done to compare quasi-permanent offers with epoch-oriented service deals. The immediate naïve way  is to consider the lifetime quoted price $p_\infty$ per datagram (e.g., 1 TB), and consider a "market equivalent standard" price $p_\epsilon$. Put  $N_{\rm eff} = p_\infty/p_\epsilon$.   

For example at the time of writing storing 1 TB on Arweave – itself considered as high-frequency availability by the authors – is around 6350 USD, as quoted for lifetime storage in Arweave blocks. A similar "high frequency availability" tier at Amazon S3 for reference would currently cost 92 USD per month to store 1 TB with (mutable) data. We note this comparison is not perfect, but is at least an illustration for how to begin comparing quasi-permanent models with finite duration models. In this case, we get 

$N_{\rm eff} \approx \frac{6350}{92}~\rm mo = 5.75 yrs$   

As we discuss in the risks section, consumers are exposed to risks involving ecosystem abandonment.  (E.g., a blockchain ceasing to exist and no endpoints/gateways willing to fetch/store old blocks.)

A second, more sophisticated method can be to use a curve fitting regression method using, e.g., \$/GB-mo $\sim \frac{1}{\rm epoch^\alpha}$  , which might somehow capture an effect that services that purport lifetime guarantees quote pricing schemes according to some power low. More work is required in this area.

### Payments (Utility tokens & batching).

In tradcloud SLAs consumers typically choose a tier of their storage-sizing/mutability/egress and make fiat bank payments according to predefined pricing. The next section is more interesting.

The way storage customers interact with various decentralized storage ecosystems specifically focussing on payments can be quite varied and differentiated from tradcloud SLAs. For example, SCs using Swarm directly upload 4 KiB "chunks" into the system and uses a `postage` contract which manages a relationship regarding which chunks are owned by what addresses, and thus enables rewards (payments) to flow down to the NO (the SPs); accounting is handled by a constellation of contracts on the Gnosis chain. Filecoin is distinct: SCs must first make a storage deal with a NO in a "storage marketplace" and prices will be mediated by FIL. Arweave and Celestia work by the familiar method of tipping to include a tx into a block (by paying native gas).

NB: difference services tend to use their own unique utility token. (FA of the market cap of the of token gives some idea of the staying power of the service.)

Pinning services like Pinata, et al., behave vey much like tradcloud services and can have, relative to crytographically guaranteed ecoystems, somewhat mysterious or absent guarantees. Files are then CID-fetchable on the open internet. Payments are often mediated either in trod-fiat (e.g., USD) as well as ether. 

One thing that was not discussed here is the switching-costs or "frictions" between moving data between multiple competing services. We believe this to be an extremely important topic in the near future as "liquid data" services arise. 

###  Data Collection Methodology

The initial pricing data set that we collected was done painstakingly by hand (without web-scrapers etc.). The initial compilation of quotes was provided graciously by Ramesh of the Swarm Foundation, and then subsequently added to by our grant team. We expect there to be errors related to elastic pricing that we haven't taken the time to sort out.

