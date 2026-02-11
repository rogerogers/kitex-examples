#!/bin/bash

# 设置工作目录为项目目录
cd ./

REPO_PATH="."
export GOPATH=$(go env GOPATH)
export GOCACHE=$(go env GOCACHE)

# 初始化状态变量
status=0
project="easy_note"

echo "---------------------------------------"
echo "Running project: $project"

cd "$REPO_PATH" || exit

# 构建并启动所有容器，等待服务健康
echo "Building and starting containers..."
docker compose up --build -d --wait

# 检查所有服务是否健康
# 检查所有服务是否健康
unhealthy_services=$(docker compose ps --format json | jq -r 'select(.Health != "healthy") | .Service')
if [ -n "$unhealthy_services" ]; then
    echo "Some services are not healthy: $unhealthy_services"
    docker compose logs
    status=1
else
    echo "All services are running healthily!"
    echo "Project run successfully: $project"
fi

# 停止并删除所有容器
echo "Cleaning up containers..."
docker compose down

cd - > /dev/null || exit

echo "---------------------------------------"

# 设置脚本的退出状态
exit $status