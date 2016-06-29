FROM centos:7

RUN rpm -Uvh http://mirrors.opencas.cn/epel/7/x86_64/e/epel-release-7-5.noarch.rpm \
    && rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum install --enablerepo=remi --enablerepo=remi-php56 php php-fpm php-cli php-gd php-common php-mbstring php-pdo php-mysqli php-simplexml  php-redis  -y 
RUN yum install nginx supervisor crontabs -y 

ENV LANG zh_CN.UTF-8
RUN /usr/bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && /usr/bin/echo -e "ZONE="Asia/Shanghai"\nUTC=false\nRTC=false" > /etc/sysconfig/clock \
    && /usr/bin/sed -i -e 's/required/sufficient/' /etc/pam.d/crond

WORKDIR /data

RUN /usr/bin/mkdir -p /data/www /data/logs && /usr/bin/chown -R apache:apache /data/www && /usr/bin/chmod 777 -R /data/logs && /usr/bin/chmod 777 -R /var/lib/nginx
ADD init init
ADD entrypoint.sh /data/entrypoint.sh
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisor.conf /etc/supervisord.conf
RUN chmod +x -R /data/init /data/entrypoint.sh

RUN /usr/bin/sed -e 's/;daemonize = yes/daemonize = no/' -i /etc/php-fpm.conf \
    && /usr/bin/sed -i -e 's/;listen\.owner = nobody/listen.owner = apache/' /etc/php-fpm.d/www.conf \
    && /usr/bin/sed -i -e 's/;listen\.group = nobody/listen.group = apache/' /etc/php-fpm.d/www.conf \
    && /usr/bin/sed -i -e 's/php_admin_value\[error_log\] = .*/php_admin_value[error_log] = \/data\/logs\/www-error.log/g' /etc/php-fpm.d/www.conf \
    && /usr/bin/sed -i -e 's/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm\/php-fpm.sock/' /etc/php-fpm.d/www.conf \
    && /usr/bin/sed -i -e "s/error_log.*/error_log = \/data\/logs\/php-fpm.error.log/g" /etc/php-fpm.conf \ 
    && /usr/bin/sed -i -e "s/;error_log =.*/error_log = \/data\/logs\/php_errors.log/g" /etc/php.ini
    
EXPOSE 80
    
CMD ["/usr/bin/bash", "entrypoint.sh"]
