FROM golang:1.23-bookworm AS build

RUN apt-get update && apt-get install -y libgeos++-dev libleveldb-dev

RUN go install -tags="ldbpost121" github.com/omniscale/imposm3/cmd/imposm@v0.14.2

FROM gcr.io/distroless/cc-debian12

COPY --from=build /go/bin/imposm /usr/bin/imposm

WORKDIR /lib/x86_64-linux-gnu
COPY --from=build /lib/x86_64-linux-gnu/libleveldb.so.1d .
COPY --from=build /lib/x86_64-linux-gnu/libsnappy.so.1 .
COPY --from=build /lib/x86_64-linux-gnu/libgeos_c.so.1 .
COPY --from=build /lib/x86_64-linux-gnu/libgeos.so.3.11.1 .

WORKDIR /

ENTRYPOINT ["/usr/bin/imposm"]
