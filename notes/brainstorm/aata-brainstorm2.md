> ==TODO: Availability can mean different things to different audiences/consumers. E.g., a CDN may be entrusted with data and be expected to provide reasonable access times independent of the geolocation of an http-requester. Alternatively, for on-chain computations, accessing off-chain data is—without exception—extremely cumbersome. The latter requires the notion of a data oracle.== 
>
> The notion of availability in the on-chain case is multi-dimensional: (1) Is the backend online (in the sense of being connected to the internet), (2) can the backend provider move their data $v$ into a block within reasonable time, so that, e.g., it can be used in an on-chain function call ${\tt f}(v)$. It should be noted that one shouldn't assume that it would become the norm that backend providers are also the same agents that bridge the data to chain. ==It seems much more likely (akin to PBS-type separation of roles) that oracles and bridge providers will compete for customers independent of their backends. (TODO: Is this actually try?  need to think [aata])== Along this line of thought, it seems a notion of logistical/economic "friction-to-chain" can capture the issues outlined above in addition to an economic angle. (E.g., there exist reasonable mechanisms such that paying more could yield higher probabilities of the requested data appearing in, say, the next block, essentially de-risking the request.) In summary availability related risks can occur from:
>
> * block inclusion probabilities
> * utility token price surges
> * chain-native gas price surges
>
> ==TODO: do we need to describe this block inclusion business?==
