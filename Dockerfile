FROM    rust:1.89-alpine3.22 AS compiler
RUN     apk add -q --no-cache build-base openssl-dev

ENV     RUSTFLAGS="-C target-feature=-crt-static"

WORKDIR /project

COPY . .

RUN cargo build --release --verbose --workspace ${EXTRA_ARGS}
