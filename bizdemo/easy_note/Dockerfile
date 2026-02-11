# 统一的Dockerfile，通过SERVICE参数指定要构建的服务
# 使用方法：docker build --build-arg SERVICE=api -t easy_note/api .

# 第一阶段：构建
FROM golang:1.23-alpine AS builder
ENV GO111MODULE=on

# 定义要构建的服务类型（api, user, note）
ARG SERVICE=api

WORKDIR /app
COPY . .

# 根据不同的服务执行不同的构建命令
RUN cd /app/cmd/${SERVICE} && sh build.sh

# 第二阶段：运行
FROM alpine:3

# 定义要构建的服务类型（api, user, note）
ARG SERVICE=api

WORKDIR /app

# 根据不同的服务复制不同的可执行文件
COPY --from=builder /app/cmd/${SERVICE}/output/bin/demo${SERVICE} .
RUN chmod +x demo${SERVICE}

EXPOSE 8080 8889 8888

# 环境变量默认值
ENV MYSQL_IP="mysql"
ENV ETCD_IP="etcd"
ENV JAEGER_AGENT_HOST="jaeger"
ENV JAEGER_DISABLED=false
ENV JAEGER_SAMPLER_TYPE="const"
ENV JAEGER_SAMPLER_PARAM=1
ENV JAEGER_REPORTER_LOG_SPANS=true
ENV JAEGER_AGENT_PORT=6831
ENV SERVICE=${SERVICE}

# 根据不同的服务设置不同的入口点
CMD ./demo${SERVICE};