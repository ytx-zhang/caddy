FROM caddy:2.11-builder-alpine AS builder
RUN xcaddy build --with github.com/caddy-dns/alidns

FROM gcr.io/distroless/static-debian12

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

ENTRYPOINT ["/usr/bin/caddy", "run", "--config", "/etc/caddy/Caddyfile"]
