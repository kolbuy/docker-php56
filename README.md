# docker-php56

## pull

> docker pull kolbuy/php-56:1.0.12

or 

> docker pull registry.aliyuncs.com/kolbuy/php56:1.0.12

## version notes

lastest version : 1.0.12

### 1.0.12

new add redis extension

### 1.0.11

change crontab type

### 1.0.10

1. add crontab option
2. add init .sh file execute when container start

### 1.0.9

open error_log and set to /data/logs/php_errors.log

### 1.0.7

add php package php-simplexml

fix some permission bugs

move logs to /data/logs


## image location


1. based on centos 7.0
2. installed php php-fpm php-cli php-gd php-common php-mbstring php-pdo php-mysqli php-simplexml crontab nginx supervisor
3. php version is 5.6.18
4. timezone is Asia/Shanghai
5. system LANG is zh_CN.UTF-8
6. WORKDIR is /data
7. web folder is /data/www, 
8. default run php-fpm and nginx, php-fpm is run on sockt not port

## command


### run

run it on port 80, display nothing. you can access it on http://`<server_name>`:80/ this image is just a base.
> docker run -d -p 80:80 kolbuy/php-56:`<image version>`

run it on port 80
> docker run -it --rm -p 80:80 kolbuy/php-56:`<image version>`

run it with php projects

> docker run -it --rm -p 80:80 -v `<source code path>`:/data/www -v `<log path>`:/data/logs kolbuy/php-56:`<image version>`

run it backend, take in container to doing something

> docker run -d -p 80:80 kolbuy/php-56:`<image version>`
> 
> docker exec -it `<container name>` /usr/bin/bash

## OPTIONS

### crontab

the container will run crontab when start, meet below two conditions:



1 environment variables `CRONTAB` not none, or file `/data/init/crontab.enable` exist

1.1 this option is a switch for enable or disable cron task

by the way, you can enable cron task when run the container:

> docker run -d -e "CRONTAB=true" <image name\>

1.2 use file `/data/init/crontab.enable`, you can make cron task always run.

by this way, you can enable cron task by two step: 

step one, create a file `init/crontab.enable` with any string

> echo "true" > init/crontab.enable

step two, write below command into `Dockerfile` for add file into image

> COPY init/crontab.enable /data/init/crontab.enable


2 you can write it reference blow in to folder init/crontab/, specifie user with file name:

step one, write a file `init/crontab/<user name>`  reference blow:

> * * * * * /bin/echo "hello world"

step two, write below command into `Dockerfile` for add file into image

> COPY init/crontab/* /data/init/crontab/



### init 

when the container start, will execute all .sh file in `/data/init`

you can add .sh file into `/data/init`, as such Dockerfile

> COPY custom.sh /data/init/custom.sh


## example project: 

[https://git.amoyxtest.com/amoyx/KJTPortal](https://git.amoyxtest.com/amoyx/KJTPortal)

> cd `<project folder>`
>
> bash tools/docker/build.sh

PS: 

1. php sourcecode just in www folder.
2. display nothing, just a base image for deploy portal project php part.
