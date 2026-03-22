FROM lukemathwalker/cargo-chef:latest-rust-slim-trixie AS chef
RUN apt-get update && apt-get install -y --no-install-recommends libssl-dev pkg-config && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app


FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json


FROM chef AS builder
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json

ENV     RUSTFLAGS="-C target-feature=-crt-static"

WORKDIR /project

COPY . .

RUN cargo build --release --verbose --workspace ${EXTRA_ARGS}
