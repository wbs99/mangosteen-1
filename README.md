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

```bash
bin/pack_for_remote.sh
```

- 需要更新数据库时，执行下面命令

```bash
need_migrate=1 bin/pack_for_remote.sh
```
# 注意事项
1. clone 项目后，重新生成密钥 ( 这一步必须做，否则运行测试用例会报错 )
```bash 
rm config/credentials.yml.enc
EDITOR="code --wait" bin/rails credentials:edit
EDITOR="code --wait" rails credentials:edit --environment production
```
在自动生成的文件中写入以下内容 (xxx 是密码或是随机字符串)
```
secret_key_base: xxx
email_password: xxx
hmac_secret: xxx
```
