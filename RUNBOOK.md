# Runbook

## First time Migration Notes

### Sync down photos

```shell
rsync -av \
--include "2020-2029/" \
--include "2020-2029/2025/" \
--include "2020-2029/2025/202508/" \
--include "2020-2029/2025/202509/" \
--include "2020-2029/2025/202508/*" \
--include "2020-2029/2025/202509/*" \
--exclude "*" \
bridgetek@ssh.bridgetek.com:/home/bridgetek/family.bridgetek.com/html/photoalbum/galleries/Family/ .
```

### Restore Backup database

Startup server to initialize database

- Open up SQL and Piwigo ports in docker compose file then

```shell
# for local podman running
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock
docker-compose up
```

Do a full configuration get to it's working page, close browswer

### Initial Web Config

Login to container and set database parameters

- HOST: piwigo-db:3306
- USER: piwigodb_user
- DATABASE: piwigodb

### Restore the backup we took

Database

```shell
cd backups

USERNAME=piwigodb_user
HOST=127.0.0.1
DATABASE=piwigodb
export MYSQL_PWD=d9hGO86fPJME1l
mysql -h $HOST -u $USERNAME -e "DROP DATABASE $DATABASE;"
mysql -h $HOST -u $USERNAME -e "CREATE DATABASE $DATABASE;"
mysql -h $HOST -u $USERNAME $DATABASE< btek_family.sql
```

```shell
podman-compose down
```

Plugins and Themes

```shell
sudo cp -r themes/* ../piwigo-data/piwigo/themes/
sudo cp -r plugins/* ../piwigo-data/piwigo/plugins/
sudo chown -R 100099:100100 ../piwigo-data/piwigo/themes/
sudo chown -R 100099:100100 ../piwigo-data/piwigo/plugins/

```

### Secure, remove local stuff

- Shutdown containers
- Remove local overrides on ports in compose

### Setup SSL

### Backups

```shell
tar -cvzf backups/piwigo-data-$(date +%Y%m%d%H%M%S).tar.gz piwigo-data
```
