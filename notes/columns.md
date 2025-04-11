# Column Descriptions

## Cost metrics

* **Capacity Rent.** Capacity rent as quoted by the service, in whatever units they quote it in. May include several bands.
* **Capacity Rent (normalized).** Capacity rent normalised to units of USD per GiB-month. Currencies are converted on the day the data was fetched. Lifetime or permanent leases are amortised on a straight line basis over 60 months.
* **Transit.** Egress fees as quoted by the service, in whatever units they quote it in. May include several bands.

## Performance Metrics

* **100M (MiB/s).** Mean download speed of a 100MiB workload, reported at 50th quantile. An estimator of *steady state throughput.*
* **100K (ms).** Total session time of a 100KiB workload, reported at 50th, 95th, and 99th quantiles. An estimator of *latency* a.k.a. *time to first byte.*

## Risks

* **Consistency model.** Database consistency model. One of *immutable*, *strong*, or *exotic/blockchain*.
* **Estimated loss rate.** Estimated probability of irretrievable data loss, per object per year. 
* **Service level agreement (SLA).** Definition of the service guarantees as in a telco agreement; indemnity in case of failures.
* **Storage proof.** Type of storage proof used to ensure provider-side availability.
