# sui-docker

[![Docker](https://github.com/shinamicorp/sui-docker/actions/workflows/docker.yaml/badge.svg)](https://github.com/shinamicorp/sui-docker/actions/workflows/docker.yaml)

Multi-platform docker images for [Sui](https://sui.io/).

These are built from the official release source code from [Sui](https://github.com/MystenLabs/sui/releases).
The images are tagged with the corresponding release version, e.g. `devnet-0.22.0`.

Please refer to the [GitHub Packages](https://github.com/orgs/shinamicorp/packages?repo_name=sui-docker) page for available versions.

## Supported platforms

- `linux/amd64`
- `linux/arm64`
  - Can run natively with Docker on Mac computers with Apple silicon (M1/M2).

## Image variants

- [sui-node](https://github.com/shinamicorp/sui-docker/pkgs/container/sui-node)
  - `ghcr.io/shinamicorp/sui-node:<sui_release_version>`
  - Contains a single `sui-node` binary, geared towards running Sui fullnodes.
  - Image entrypoint set to `sui-node`, so you can directly run commands like this:
    ```
    docker run --rm -it ghcr.io/shinamicorp/sui-node:devnet-0.22.0 --help
    ```
  - In practice, you'll need to mount volumes for config, genesis, and data storage etc.
- [sui](https://github.com/shinamicorp/sui-docker/pkgs/container/sui)
  - `ghcr.io/shinamicorp/sui:<sui_release_version>`
  - Contains `sui-node` and `sui`, so a little larger in size.
  - No entrypoint set.

## Helper script

Also included is a [helper script](./sui) to run `sui` CLI commands using the above docker image.
This can be used as a "universal binary" of `sui` on any of the supported platforms, without having to compile or download the platform-specific binary.

Docker and Python 3 are required to run the script.

Example:

```bash
# Assuming the sui script is in the current dir
❯ ./sui --help
sui 0.15.0
Mysten Labs <build@mystenlabs.com>
A Byzantine fault tolerant chain with low-latency finality and high throughput

USAGE:
    sui <SUBCOMMAND>

OPTIONS:
    -h, --help       Print help information
    -V, --version    Print version information

SUBCOMMANDS:
    client              Client for interacting with the Sui network
    console             Start Sui interactive console
    genesis             Bootstrap and initialize a new sui network
    genesis-ceremony    
    help                Print this message or the help of the given subcommand(s)
    keytool             Sui keystore tool
    move                Tool to build and test Move applications
    network             
    start               Start sui network
```
