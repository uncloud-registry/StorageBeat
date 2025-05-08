# Upload specifics
* Files are uploaded using Pinata CLI
* Garbage collector is run every time after all files are uploaded

# Download specifics
* Local IPFS node (Kubo) is used for downlading files

# Notes
1. Since IPFS is an indexer, after redirection the speed and connection depend on pinning service
1. Pinata was used for the purpose of those tests. Other pinning services may behave differently.
1. Pinata configuration is not intuitive in terms of making files available through any (not just Pinata's) IPFS gateway. We have faced the issue when files uploaded via access key that has all permisions but admin were not propogated to IPFS. Only uploads via admin key seem to propogate correctly. This behavior is not documented anywhere. 
1. Pinata UI or CLI doesn't provide an option to force propagation. There is also no way to check propgation status (without using 3rd party tools)
1. At one point download speed got signifantly throttled. Pinata doesn't give any indication of this happening
1. Wait time for the first byte if significantly higher than with S3 and Arweave. It can especially be seen on the tests that use small file sizes