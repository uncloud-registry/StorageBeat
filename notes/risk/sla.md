# Tradcloud availability SLAs

In tradcloud, availability is usually stated in terms of a bound on the rate of certain types of errors (namely, server-side HTTP 5xx errors) in a rolling time interval. We don't know if this class of errors always indicates unavailability at the gateway level or if it can be local to a particular object request.

Provider obligations include a service-level agreement (SLA) that guarantees, for example, that at most proportion $p\ll 1$ of requests in a monthly rolling window return an internal error. Missed SLAs are compensated by a service credit, measured as % of monthly fee. The SLAs do not tend to cover timeouts or other types of errors, so that in principle the provider could avoid triggering these clauses by simply failing to respond to requests when an internal error would otherwise occur. For example, the AWS S3 SLA appears to reference HTTP codes 500 and 503; is 504 included?

> "Error Rate” means, for each request type to an Amazon S3 storage class: (i) the total number of internal server errors returned by Amazon S3 for such request type to the applicable Amazon S3 storage class as error status “InternalError” or “ServiceUnavailable” divided by (ii) the total number of requests for such request type during the applicable 5-minute interval of the monthly billing cycle. We will calculate the Error Rate for each AWS account as a percentage for each 5-minute interval in the monthly billing cycle. The calculation of the number of internal server errors will not include errors that arise directly or indirectly as a result of any of the Amazon S3 SLA Exclusions.

To the best of our knowledge, no decentralised storage platform offers any quantifiable availability SLA. On the other hand, p2p network based platforms in principle offer much higher *provider* or *portal* diversification, since the client always has the option of running their own p2p node and retrieving data from a long list of peers. 

Note: as far as we know, tradcloud SLAs do not offer explicit guarantees for durability failures.

## Cloud SLAs and T&C examples

* S3 SLA. https://aws.amazon.com/s3/sla/
* IBM Cloud SLA. https://www.ibm.com/support/customer/csol/terms/?id=i126-9268&lc=en
* Hetzner T&Cs (see $\S$6 for terms concerning durability failures). https://www.hetzner.com/legal/terms-and-conditions/


