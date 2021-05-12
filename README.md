## 安装须知
1、进入openenresty目录拉取相关安装包
```
cd openenresty
git clone https://github.com/happyfish100/libfastcommon.git --depth 1
git clone https://github.com/happyfish100/fastdfs.git --depth 1
git clone https://github.com/happyfish100/fastdfs-nginx-module.git --depth 1
```
2、进入fastdfs_config目录，修改相关fastdfs配置
```
cd ../fastdfs_config
vim tracker.conf
base_path=/home/dfs // 数据和日志文件存储根目录

vim storage.conf
base_path=/home/dfs  # 数据和日志文件存储根目录
store_path0=/home/dfs  # 第一个存储目录
tracker_server=192.168.52.1:22122  # 修改为本机的外网ip，端口不用改,如果是分布式部署，则写上多个tracker_server

vim client.conf
base_path=/home/dfs
tracker_server=192.168.52.1:22122 // 修改为本机的外网ip，端口不用改，如果是分布式部署，则写上多个tracker_server

vim mod_fastdfs.conf
url_have_group_name=true
store_path0=/home/dfs
tracker_server=192.168.52.2:22122 // 修改为本机的外网ip，端口不用改，如果是分布式部署，则写上多个tracker_server

```

3、进入Dockfile修改文件存储目录
```
cd ..
vim Dockerfile
ARG MKDIR_DATA_PATH="/www/dfs" // 改为跟上面一致的目录，如果存储不在www根目录下，则还要修改docker-compose的volumes
```

