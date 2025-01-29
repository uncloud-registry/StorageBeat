# Rationale (ctd).

We address the following questions:

1. How do we determine the number of trials and compute statistics?
2. Controls: do we control for geolocation?
3. Controls: do we control for time of day/week? Traffic?
4. Do we test fast failure? Time to error? Do we distinguish types of errors?
5. What other features should we test?
6. Should workloads include concurrent requests?
7. Should we measure per request time? Throughput at different points within a single request?
8. Controls: can we control for the state of remote caches?
9. How broad a range of workloads can we parametrise?

## Target audience

To address these, we posit the following target audience: a CTO choosing a storage backend to deploy a service (henceforth: the Service) that will allow users to download data from different geographic locations.

Other target audiences we choose to put aside:

1. A lead engineer choosing a storage platform on which to build an application. (This is slightly different because the engineer need not use an end-to-end service but simply integrate components.)
2. A consumer wishing to back up his squirrel videos. (We believe this type of target market is generally far enough removed from the details of storage backend so as to make presenting this type of information irrelevant; what the user cares about is the performance and features of *applications*, not backends.)

## Statistical inference

A typical engineer might approach download speed tests by running tests a number of times and computing the sample mean, perhaps as well as outliers, sample variance, and quantiles. To determine if download speeds satisfy some desired property, plot visualisations of the results and eyeball it.

Given the decision variable "the service we will use for task Z," in some cases a more rigorous approach to statistical inference may be justified. For example, if the service based on this backend will offer a performance SLA, our CTO may wish to perform a hypothesis test to establish that the backend satisfies the SLA on 99% of workloads within some range.

To do statistical inference, we would need to:

1. Pick a reference family of distributions (prior distribution, if using Bayesian methods) for the retrieval time. (As a first guess, gamma distribution seems applicable?)
2. Formulate a hypothesis, e.g. "pulls satisfy SLA with at least 95% probability" and use standard methods to set up a hypothesis test. 
3. Use statistical power analysis to determine the number of samples to take.

Since it may not be reasonable to expect our CTO to have a statistician on team to design this statistical apparatus, we should aim to propose standard approaches and rules of thumb that can be mechanically applied to the problem.

## Controls

### Geolocation

In (Bocchi, 2014), the authors expend some efforts to figure out where in the world service endpoints are located and the routes that packets travel to reach them. Round trip times (RTT) are tested and plotted. 

As they point out:

> Storage providers strongly encourage users to select the closest end-point to their location in order to reduce data latency and to offload the public Internet.

For a CTO interested in running a service available to a geo-distributed userbase, it is not reasonable to expect all users to be positioned close to a single server; the CTO is interested in the *full range* of performance possibilities in all locations in which the service will be accessed.

### Time of day, day of week

In case of seasonal effects (essentially exogenous traffic, but possibly also node liveness), samples should be taken at all times of day and all days of the week.

### Cache state

It is difficult to control for the state of remote caches, but we can try to reason about it in terms of known cache policies and then try to run workloads over a range that spans cache condition boundaries.

* LRU cache. Objects remain in cache until it is full, after which oldest objects are excised. Caches may be tracked per user or global.
  To trigger an LRU cache boundary, additional traffic must be generated on different objects on the same node. This approach may not make much sense for a decentralised storage protocol.
* Time based. Objects that haven't been accessed for a certain amount of time are excised. To trigger, upload data and wait different amounts of time before testing download.

## Failures

How do we test *failed* downloads? How do we determine if a download has failed? Should we track different failure conditions?

The assumption that all tests make HTTP requests provides a useful framework for defining failure modes.

* If we are testing HTTP endpoints, then it is up to us to fix HTTP client settings such as timeout and retries since these can affect when and sometimes whether a request is deemed to have failed (in the case of no response).
  On the other hand, a response with 400+ code would generally be interpreted as a type of failure.
* To assess failure modes, it may be useful to set up tests where the *expected* result is failure, e.g. requesting a blob we know not to be available.

## Workload parametrisation

To be fully general, a workload should be able to consist of any number of requests for any number of different files, on an arbitrary schedule, with any number of repetitions, from any geographic location to any endpoint. 

Defining fully general schedules is a weighty task, so we restrict to considering schedules that are:

* Triggered at a certain time of day and day of the week (to control for seasonality);
* All requests are for unique data;
* All requests are of the same size;
* Requests arrive at a constant rate;
* Requests have the same origin.

By default, requests and the ensuing sessions are allowed to be concurrent. We do not use the end of a session (e.g. by a completed download) as an event trigger.

```rust
struct Workload { 
    requests: u64;
    request_size: u64;
    request_spacing: TimeDelta
}
```

## Measurements

The most basic measurements we can make are:

* Time to complete a workload;
* Failure rate, or more generally, rate of each possible request outcome (success, HTTP error code, timeout...).

There are other, more fine-grained quantities that we might try to measure or estimate — for example, time to first byte, or time to complete each request in a workload. 

* If a workload is meant to simulate multiple users interacting with the service in one session, time to complete requests arriving at different stages of the workload might be useful to simulate the user experience of being at different stages of an artificial demand spike.
  Measuring this is basically exactly as complicated as measuring full workload length, but there are more parameters to keep track of.
* Time to first byte might be relevant to understanding how to configure connection timeouts. One might consider it relevant for assessing the performance on workloads with small request size, but that is even better assessed by actually running the workloads of interest.

Generally, when deciding whether to attempt measurement or estimation, there are some tradeoffs to consider.

* Measurement may not be practical with the available tools;
* Even if available, subtle differences in the way that measurement is done can make results incomparable or unreproducible.

So what about estimation?

### Estimation

*Time to complete each request.* If we have a total of $n$ requests arriving at a rate of one per $k$ seconds, and the $i$th request completes in $t_i$ seconds, then the total time $T$ to workload completion is
$$
\max\{t_i+ik \mid i =1,\ldots,n \}.
$$
By running the workload with different numbers of requests, we can fit a parametric model to the numbers $t_i$. But who cares: we had to detect when each request terminated, which is tantamount to measuring each $t_i$, in order to measure $T$ anyway.

*Time to first byte.* This is just the limit of small request size.

*Plotting throughput over time.* Similarly, suppose we run $N$ trials that each make a single request for $B_n$ bytes and complete in time $t_n$. Working in continuous time, if $s(t)$ denotes the throughput in bytes per second at time $t$, then we have
$$
B_n = \int_0^{t_n}s(t)dt.
$$
If we assume $s$ belongs to some $k$-parameter family of functions $f(\theta_1,\ldots,\theta_k; t)$, then we ought to be able to fit $s$ by judiciously choosing $k$ values of $B_n$ to use as interpolation points.