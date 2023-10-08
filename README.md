# 创建数据库

windows 终端

```bash
docker run -d --name db-for-mangosteen -e POSTGRES_USER=mangosteen -e POSTGRES_PASSWORD=123456 -e POSTGRES_DB=mangosteen_dev -e PGDATA=/var/lib/postgresql/data/pgdata -v mangosteen-data:/var/lib/postgresql/data --network=network1 postgres:14
```

# 启动数据库

windows 终端

```bash
docker start db-for-mangosteen
```

# 部署相关

- 不需要更新数据库执行下面命令

```
bin/pack_for_remote.sh
```

- 需要更新数据库时，执行下面命令

```
need_migrate=1 bin/pack_for_remote.sh
```
