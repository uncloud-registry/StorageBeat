# Risks and promises in decentralised storage

Briefly, the main risks of any storage service are: 

1. What if I can't retrieve my data? 
2. What if someone else sees my data when I don't want them to?

To manage these risks, you want your storage service to have good *availability* and *privacy* properties, respectively. 

Such properties can be reported in the form of "guarantees," which promise that the provider will pay some penalty or compensation in the event a target is not met (as in a tradcloud uptime SLA or uncloud slashing penalty), or simple "advertisements" (such as the typical "eleven nines" durability metrics reported by many cloud storage providers) that do not have any contractual obligations associated with them. Ideally, such advertisements should at least be *measurable* in the sense that a customer or third party could check the validity of the claims.

## Availability

* Handled by SLAs in the case of tradcloud providers.
* SLAs for object storage typically measure percentage of requests that fail in a specified way (e.g. "Internal Error" response) within a five minute window. Missed SLAs are compensated by a service credit, measured as % of monthly fee.
* SLAs do not cover other types of error or timeouts, nor do they guarantee correctness of the retrieved data.

Access portal:

* Accessed via remote gateway or directly on p2p network?
* Can I access it over p2p as a fallback? (E.g. Pinata, Ardrive yes, Storj maybe no). "Escape hatch."
* **Gateway type:** local, remote (centralised), p2p fallback

### Durability

A durability failure is nothing more than an unrecoverable availability failure (or at least, unrecoverable from within the service).

* Focus of Codex Storage "decentralised durability engine."
* Reference BackBlaze explanation of "nines" system for reporting durability. https://www.backblaze.com/blog/cloud-storage-durability/
* Are data losses detectable?
* Do they result in penalties? Compensation (insurance)?
* Measuring durability: basically only possible with Filecoin PoRep. Users must trust the provider's reporting of durability.
* The scale needed for durability events to kick in at eleven nines is probably too large for any provider on earth (e.g. 1 billion drives over a period of 1000 years).

## Privacy

* In decentralised storage: basically just client side encryption, possibly integrated into a node (Swarm ACT?)
* In centralised storage, must be compliant with various standards (ISO etc.). Applicability of standards depend on the type of data, i.e. is it "personal data." Also, other laws may compel providers to *reveal* data to authorities.

## Open source

As with all computer systems, the risks and guarantees can be best understood with open source software and infrastructure.

## Resources

### Decentralised storage

* Codex whitepaper. https://docs.codex.storage/learn/whitepaper

### Cloud SLAs and T&Cs

* S3. https://aws.amazon.com/s3/sla/
* IBM Cloud. https://www.ibm.com/support/customer/csol/terms/?id=i126-9268&lc=en
* Hetzner T&Cs (see especially S6). https://www.hetzner.com/legal/terms-and-conditions/





Hi, finally following up from our chat in Soho House in November.

We are preparing 

Research (?) questions:

* We want to provide a simple risk framework a la L2Beat that stakeholders can use to make decisions about storage services.
* We're interested in a simple way to report durability (analogous to the "x nines" approach of tradcloud).
* "achieving *provable availability* is in general not possible" + citation to Al-Bassam-Sonnino-Buterin. Is there some specific claim in that paper you're referencing? (Actually I'm not sure "provable availability" is even defined in that paper.)

Calls to action:

* Hop on a call to catch each other up?
* Answer questions about the Codex "whitepaper"
* Have you come across these questions in your work?





## Costs





## Performance

