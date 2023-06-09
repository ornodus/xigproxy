FROM ubuntu as builder
RUN apt update && apt install -y wget

WORKDIR /tmp
RUN wget -O bin.tar.gz https://github.com/xmrig/xmrig-proxy/releases/download/v6.19.2/xmrig-proxy-6.19.2-linux-static-x64.tar.gz

RUN tar -xzvf bin.tar.gz

FROM alpine

RUN adduser -S -D -H -h /xmrig-proxy xmrig && \
    apk update && \
    apk upgrade && \
    apk add --no-cache libuv libmicrohttpd util-linux

USER xmrig

COPY --from=builder /tmp/xmrig-proxy-6.19.2 /xmrig-proxy 

WORKDIR /xmrig-proxy

ENTRYPOINT [ "./xmrig-proxy" ]