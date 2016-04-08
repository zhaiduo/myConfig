#!/bin/bash
#run with: . play.sh
cd /home/zhaiduo/workrepo
#pwd
/bin/git pull
cd ~
#pwd
rm -f ~/centosLNMP.sh
cp /home/zhaiduo/workrepo/nginx/centosLNMP.sh ~/
rm -f ~/firewall.sh
cp /home/zhaiduo/workrepo/nginx/firewall.sh ~/
chmod 755 centosLNMP.sh
chmod 755 firewall.sh

rm -f ~/install_db.sh
cp /home/zhaiduo/workrepo/nginx/install_db.sh ~/
chmod 755 install_db.sh

#rm -rf /scripts/*.*
#cp /home/zhaiduo/php/*.php /scripts/
#cp /home/zhaiduo/php/composer.json /scripts/

#. centosLNMP.sh
#. install_db.sh
cd ~
#echo "OK"