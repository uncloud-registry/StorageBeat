# How to run Benchmark

## Prerquisites
* Artillery installed (`npm install -g artillery@latest`)
* Corresponding gateway (e.g. Swarm, IPFS etc) in installed and running

## Execution
`artillery run -e $TARGET StorageBeat.yml` (from this folder) where `$TARGET` is the name of protocol being benchamrked (currently `swarm`, `ipfs` or `arweave`)
