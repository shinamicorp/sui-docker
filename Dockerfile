FROM rust:1.65 AS builder

RUN apt-get update && \
    apt-get install -y cmake libclang-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/sui

# ARG SUI_RELEASE
# RUN curl -sL https://github.com/MystenLabs/sui/archive/refs/tags/${SUI_RELEASE}.tar.gz | \
#     tar -xzv --strip-components 1
# ENV GIT_REVISION=${SUI_RELEASE}

ARG SUI_GIT_REVISION
RUN git clone https://github.com/MystenLabs/sui.git . && \
    git checkout ${SUI_GIT_REVISION}

RUN cargo build --locked --release --package sui-node
RUN cargo build --locked --release --package sui


FROM debian:bullseye-slim AS base

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates procps vim sudo awscli && \
    rm -rf /var/lib/apt/lists/*

RUN adduser --home /sui --gecos '' --disabled-password sui


FROM base AS sui

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder \
    /usr/src/sui/target/release/sui-node \
    /usr/src/sui/target/release/sui \
    /usr/local/bin/

USER sui
WORKDIR /sui


FROM base AS sui-node

COPY --from=builder \
    /usr/src/sui/target/release/sui-node \
    /usr/local/bin/

USER sui
WORKDIR /sui

EXPOSE 9000
EXPOSE 9184

ENTRYPOINT ["sui-node"]
