# Provider durability

An extreme form of durability failure is a failure of the service itself, accompanied by the de facto expiry of all commitments. How do storage clients gain confidence that their service provider will not simply disappear in the future? In practice, clients use information about the provider such as reputation, size metrics, years in operation, or profit reports to make forecasts about the continuation of services.

Evaluation criteria:

* **Platform size.** *number of nodes, total data stored, years of operation, total revenue.* 
  For centralised platforms, typically only *years in operation* is publicly known.
* **Reputation.** Not really quantifiable

## Provider diversity

The risk of provider failure can be diversified by replicating or expanding data across multiple providers. This process is expedited by common APIs and fair egress charges, which can be facilitated by industry cooperation or regulation.[^eu-storage-liquidity]
A distinguishing feature of many decentralised storage platforms is that dispersal across multiple providers happens automatically and is completely transparent to the user.

[^eu-storage-liquidity]: For example an EU working group has developed recommendations in this direction: https://digital-strategy.ec.europa.eu/en/library/study-presenting-assessments-codes-conduct-data-porting-and-cloud-switching

In case of decentralised platforms, **supply market concentration** measures such as *number of controlling entities* or *HH index* are of interest in assessing diversification.

## Gateway diversity

p2p network based platforms in principle offer much higher *provider* or *portal* diversification, since the client always has the option of running their own p2p node and retrieving data from a long list of peers. 

We distinguish portal diversification as meaning that there are multiple access points to the same storage backend. An example would be a web gateway to a p2p storage service such as a blockchain; in the event that the gateway provider becomes unavailable, the client may spin up a node and connect directly to the p2p backend as a fallback. Moreover, fallback is built into the structure of a p2p network itself: if one's current peer list won't provide the desired service, a node can attempt to connect to new peers as a fallback. On the other hand, mirroring content across two tradcloud storage providers is not portal diversification: the data is stored in two separate platforms, and the client must pay twice for capacity rental.

We introduce the evaluation criterion

* **Gateway.** Web, p2p, or web with p2p fallback.

The existence of a p2p backend could be taken as a definition of "decentralised," though as we have observed that is not the whole story.

