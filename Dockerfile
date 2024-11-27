# Keep up-to-date with https://github.com/MystenLabs/sui/blob/main/rust-toolchain.toml
FROM rust:1.81.0-slim-bookworm AS builder-base

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        make \
        clang \
        && \
    rm -rf /var/lib/apt/lists/*


FROM builder-base AS builder

WORKDIR /usr/src/sui

# Shallow clone of a specific commit
ARG SUI_GIT_REF
RUN git init && \
    git remote add origin https://github.com/MystenLabs/sui.git && \
    git fetch --depth 1 origin ${SUI_GIT_REF} && \
    git checkout FETCH_HEAD

RUN cargo build --locked --release --bin sui-node
RUN cargo build --locked --release --bin sui


# To be used as a cache. Much smaller compared to builder.
FROM debian:bookworm-slim AS binaries

COPY --from=builder \
    /usr/src/sui/target/release/sui-node \
    /usr/local/bin/
COPY --from=builder \
    /usr/src/sui/target/release/sui \
    /usr/local/bin/


FROM debian:bookworm-slim AS runtime-base

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        procps \
        && \
    rm -rf /var/lib/apt/lists/*

RUN adduser --uid 1000 --home /sui --gecos '' --disabled-password sui
WORKDIR /sui


FROM runtime-base AS sui

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*

COPY --from=binaries \
    /usr/local/bin/sui-node \
    /usr/local/bin/sui \
    /usr/local/bin/

USER sui


FROM runtime-base AS sui-node

COPY --from=binaries \
    /usr/local/bin/sui-node \
    /usr/local/bin/

USER sui

EXPOSE 9000
EXPOSE 9184

ENTRYPOINT ["/usr/local/bin/sui-node"]
