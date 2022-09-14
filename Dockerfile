FROM rust:1.63 AS builder

RUN apt-get update && \
    apt-get install -y cmake libclang-dev && \
    rm -rf /var/lib/apt/lists/*

ARG SUI_RELEASE

WORKDIR /usr/src/sui
RUN curl -sL https://github.com/MystenLabs/sui/archive/refs/tags/${SUI_RELEASE}.tar.gz | \
    tar -xzv --strip-components 1

ENV GIT_REVISION=${SUI_RELEASE}
RUN cargo build --locked --release --package sui-node
RUN cargo build --locked --release --package sui


FROM debian:bullseye-slim AS base

RUN adduser --home /sui --gecos '' --disabled-password sui

USER sui
WORKDIR /sui


FROM base AS sui

COPY --from=builder \
    /usr/src/sui/target/release/sui \
    /usr/local/bin/

ENTRYPOINT ["sui"]


FROM base AS sui-node

COPY --from=builder \
    /usr/src/sui/target/release/sui-node \
    /usr/local/bin/

EXPOSE 9000
EXPOSE 9184

ENTRYPOINT ["sui-node"]
