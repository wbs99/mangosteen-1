# 启动数据库

在 `windows` 终端运行 `docker start db-for-mangosteen`

# 部署相关

- 不需要更新数据库执行下面命令

```
bin/pack_for_remote.sh
```

- 需要更新数据库时，执行下面命令

```
need_migrate=1 bin/pack_for_remote.sh
```
