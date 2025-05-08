# Upload specifics
* For the ease of uploads Adrive is used instead of raw Arweave. This shouldn't affect the download benchmark since the files are stored (and later downloaded)
* Files are uploaded using the ardrive-cli into the same (configured) folder. Turbo is used for uploads as it allows to use credits instead of AR tokens

# Download specifics
* https://arweave.net gateway is used for downloads

# Notes
1. Local Arweave node requires significant resources. So regular users have to rely on public gateways (usually it's the one provided by Arweave).
1. ArDrive is the most convenient way to upload files programtically. While "raw" Arweave is the easiest way to download it via HTTP.
1. When using ArDrive, if uploading file with the same name to the same folder it's "overriden" from ArDrive perspective but because the file on "raw" Arweave are accessed by tx ids, the olde file will be accessible.
1. There are 2 ways to pay for Arweave storage: AR tokens and onchain payment and Turbo credits that can be bought with credit card and then used for ArDrive. Turbo credits were used for uploads in the context of Arweave tests. To use them via CLI a special `--turbo` flag needs to be provided