# 第一阶段：编译
FROM caddy:2.10.2-builder AS builder
RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/caddyserver/cache-handler

# 第二阶段：运行环境
FROM alpine:3.23.3

# 1. 安装 tzdata 并设置时区
# 2. 安装 ca-certificates (Caddy 访问 ZeroSSL API 必须)
RUN apk add --no-cache tzdata ca-certificates \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone

# 设置环境变量
ENV TZ=Asia/Shanghai
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

# 复制编译好的二进制文件
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# 启动命令
ENTRYPOINT ["/usr/bin/caddy", "run", "--config", "/etc/caddy/Caddyfile"]
