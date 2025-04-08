# Consistency

In the case of immutable data, the definition of "consistency" is that retrieved data is exactly the same as what was uploaded, a property that can be verified using checksum or other commitments. Content addressing and immutability is widespread in decentralised storage, so these checks are built in at a low level of the infrastructure. Some decentralised storage platforms (Filecoin, Arweave, and more generally the blockspace of any blockchain) have native support only for immutable data.

Content-addressable centralised storage solutions appear to be uncommon, except when explicitly advertised as associated to some decentralised backend. However, there are some immutable cloud storage services advertised for compliance applications.[^s3-immutable]

[^s3-immutable]: https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock.html#object-lock-retention-modes

For mutable data, we are faced with the general consistency problem in database systems. Naively, one hopes that the data retrieved reflects the *most recent* update pushed to the store. In distributed systems theory this property is known as *strong consistency*, or *strong read-after-write consistency* in S3.[^s3-consistency] It requires a system to achieve global consensus over transaction ordering, and is generally costly or slow to achieve.

[^s3-consistency]: https://aws.amazon.com/blogs/aws/amazon-s3-update-strong-read-after-write-consistency/

In decentralised storage, a few approaches exist to manage mutable data:

* Write it on a blockchain. Users experience the consistency model (and costs) of that blockchain — usually a probabilistic, forkable version of strong consistency where "latest" is defined by a custom blockchain scheduling mechanism.
* In IPNS, data is partitioned into namespaces, each managed by a single node. Because a single node manages each item, consistency issues do not occur.
* EthSwarm supports custom (non content-derived) addressing schemes that allow the construction of "feeds," that is, integer-indexed sequences of strings associated with a common topic. The most recent update is found by attempting retrieval of each element of the sequence in turn until retrieval fails.

In summary, the **consistency model** of a storage service can be divided into checksummed *immutable* services, those offering a traditional consistency model like *strong read-after-write* consistency, and some emerging non-traditional consistency models such as those offered by blockchain/DLT consensus mechanisms.

