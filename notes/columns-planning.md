Columns Notes:

1. Pricing Columns

   1. Capacity Rent (Quoted)
   2. Capacity Rend (normalized)
   3. Explicit Expiry

2. Performance Metrics

   1. Steady State Throughput — (avg. download speed for  fetching a  1 GB )

      (Plot: x=size, y=avg. speed)

   2. Latency

      Measure by time taken to fetch the "smallest" segment size

3. Risks
   1. Consistency model (immutable, strong, blockchain/other)
   1. Estimated loss rate ($10^{-9}$ for most tradcloud providers, currently no data for decentralised)
   1. SLA (error rate, early termination)
   1. Storage proofs (none, sampling, sampling+expansion, PoST)







Notes:

- [ ] Compile list of data losses
  - [ ] Dropbox
  - [ ] Google Drive (There exists a report: loads of customers affected)
- [ ] Devise a statistical hypothesis test
- [ ] Do it
- [ ] 