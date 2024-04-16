# 修改 user api_port api_doc_and_front_port
# 端口需要在云服务器中添加并且不与其他应用冲突

user=mangosteen
api_port=3000
api_doc_and_front_port=8080

root=/home/$user/deploys/$version
container_name=$user-prod-1
nginx_container_name=$user-nginx-1
db_container_name=db-for-$user
network_name=network1

function set_env {
  name=$1
  hint=$2
  [[ ! -z "${!name}" ]] && return
  while [ -z "${!name}" ]; do
    [[ ! -z "$hint" ]] && echo "> 请输入 $name: $hint" || echo "> 请输入 $name:" 
    read $name
  done
  sed -i "1s/^/export $name=${!name}\n/" ~/.bashrc
  echo "${name} 已保存至 ~/.bashrc"
}
function title {
  echo 
  echo "###############################################################################"
  echo "## $1"
  echo "###############################################################################" 
  echo 
}

title '设置远程机器的环境变量'
set_env DB_HOST
set_env DB_PASSWORD
set_env RAILS_MASTER_KEY '请将 config/credentials/production.key 的内容复制到这里'

title '检查远程机器中是否已创建 network1'
if [ "$(docker network ls -q -f name=^${network_name}$)" ]; then
  echo '已存在 network1'
else
  docker network create $network_name
  echo '创建成功'
fi

title '创建数据库'
if [ "$(docker ps -aq -f name=^${DB_HOST}$)" ]; then
  echo '已存在数据库'
  if ! docker container inspect $DB_HOST --format '{{.State.Status}}' | grep -q 'running'; then
    echo '启动数据库'
    docker start $DB_HOST
  fi
else
  docker run -d --name $DB_HOST \
            --network=$network_name \
            -e POSTGRES_USER=$user \
            -e POSTGRES_DB=$user_production \
            -e POSTGRES_PASSWORD=$DB_PASSWORD \
            -e PGDATA=/var/lib/postgresql/data/pgdata \
            -v $user-data:/var/lib/postgresql/data \
            postgres:14
  echo '创建成功'
fi

title 'app: docker build'
docker build $root -t $user:$version

if [ "$(docker ps -aq -f name=^${container_name}$)" ]; then
  title 'app: docker rm'
  docker rm -f $container_name
fi

title 'app: docker run'
docker run -d -p $api_port:$api_port \
           --network=$network_name \
           --name=$container_name \
           -e DB_HOST=$DB_HOST \
           -e DB_PASSWORD=$DB_PASSWORD \
           -e RAILS_MASTER_KEY=$RAILS_MASTER_KEY \
           $user:$version

if [[ ! -z "$need_migrate" ]]; then
  title '更新数据库'
  docker exec $container_name bin/rails db:create db:migrate
fi

if [ "$(docker ps -aq -f name=^${nginx_container_name}$)" ]; then
  title 'doc: docker rm'
  docker rm -f $nginx_container_name
fi

title 'doc: docker run'
cd /home/$user/deploys/$version
if [[ -f dist.tar.gz ]]; then
  mkdir ./dist
  tar xf dist.tar.gz --directory=./dist
fi
cd -

docker run -d -p $api_doc_and_front_port:80 \
           --network=$network_name \
           --name=$nginx_container_name \
           -v /home/$user/deploys/$version/nginx.default.conf:/etc/nginx/conf.d/default.conf \
           -v /home/$user/deploys/$version/dist:/usr/share/nginx/html \
           -v /home/$user/deploys/$version/api:/usr/share/nginx/html/apidoc \
           nginx:latest

title '全部执行完毕'