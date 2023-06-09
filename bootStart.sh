#!/bin/sh
echo =================================
echo 自动化部署脚本启动
echo =================================

echo 停止原来运行中的工程
APP_NAME=reggie

tpid=$(ps -ef | grep $APP_NAME | grep -v grep | grep -v kill | awk '{print $2}')
if [ ${tpid} ]; then
    echo 'Stop Process...'
    kill -15 $tpid
fi
sleep 2
tpid=$(ps -ef | grep $APP_NAME | grep -v grep | grep -v kill | awk '{print $2}')
if [ ${tpid} ]; then
    echo 'Kill Process!'
    kill -9 $tpid
else
    echo 'Stop Success!'
fi

echo 准备打开数据库
service mysql start

echo 准备从Git仓库拉取最新代码
cd /test/reggie_take_out/

echo 开始从Git仓库拉取最新代码
git pull
echo 代码拉取完成

echo 开始打包
output=$(mvn clean install -T 1C -Dmaven.test.skip=true -Dmaven.compile.fork=true)

cd target
echo 启动项目
nohup java -jar reggie_take_out-1.0-SNAPSHOT.jar &
>reggie_take_out.log &
echo 项目启动完成
