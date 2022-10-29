# sui-docker

[![Docker](https://github.com/shinamicorp/sui-docker/actions/workflows/docker.yaml/badge.svg)](https://github.com/shinamicorp/sui-docker/actions/workflows/docker.yaml)

Multi-platform docker images for [Sui](https://sui.io/).

These are built from the official release source code from [Sui](https://github.com/MystenLabs/sui/releases).
The images are tagged with the corresponding release version, e.g. `devnet-0.13.2`.

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
    docker run --rm -it ghcr.io/shinamicorp/sui-node:devnet-0.13.2 --help
    ```
  - In practice, you'll need to mount volumes for config, genesis, and data storage etc.
- [sui](https://github.com/shinamicorp/sui-docker/pkgs/container/sui)
  - `ghcr.io/shinamicorp/sui:<sui_release_version>`
  - Contains `sui-node`, `sui`, and `rpc-server`, so a little larger in size.
  - No entrypoint set.
