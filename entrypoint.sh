
if [ ! -z "$CRONTAB" ] || [ -f "/data/init/crontab.enable" ]
then
  /usr/bin/cp /data/init/crontab/* /var/spool/cron/
fi

for INITFILE in `ls init/*.sh`
do
  bash $INITFILE
done

/usr/bin/supervisord
