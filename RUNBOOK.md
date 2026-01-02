# Runbook

## Sync down photos

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

## Database Back and Restore

Create a backup from a 'real' host

```shell


```
