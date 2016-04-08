####Author:Zhaiduo 201501
#!/bin/bash

#ANSI控制码的说明
#\33[0m 关闭所有属性
#\33[1m 设置高亮度
#\33[4m 下划线
#\33[5m 闪烁
#\33[7m 反显
#\33[8m 消隐
#\33[30m -- \33[37m 设置前景色
#\33[40m -- \33[47m 设置背景色
#\33[nA 光标上移n行
#\33[nB 光标下移n行
#\33[nC 光标右移n行
#\33[nD 光标左移n行
#\33[y;xH设置光标位置
#\33[2J 清屏
#\33[K 清除从光标到行尾的内容
#\33[s 保存光标位置
#\33[u 恢复光标位置
#\33[?25l 隐藏光标
#\33[?25h 显示光标

#字背景颜色范围:40----49 40:黑 41:深红 42:绿 43:黄色 44:蓝色 45:紫色 46:深绿 47:白色
#red alert
Err(){
    echo -e "\033[40;31m$1 \033[5m"
}
#字颜色:30-----------39 30:黑 31:红 32:绿 33:黄 34:蓝色 35:紫色 36:深绿 37:白色
#green alert
Info(){
    echo -e "\033[40;32m$1 \033[0m"
}

#创建目录
MkMl(){
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
    fi
}

#删除文件
DelFile(){
    if [ -f $1 ]; then
        rm -f $1
    fi
}

#wget文件
GetFile(){
  if [ ! -f $1 ]; then
    wget -O $1 $2
  fi
}

#untar
UnTar(){
  if [ ! -d "$1$2" ]; then
    tar zxvf "$1$2.tar.gz" -C $1
  fi
}

#untgz
UnTgz(){
  if [ ! -d "$1$2" ]; then
    tar zxvf "$1$2.tgz" -C $1
  fi
}

#install
Install(){

  if [ -d "/Data/tgz/$1" ]; then
    cd "/Data/tgz/$1"
    IS_MAKE="$(ls|grep config.log|wc -l)"
    IS_MAKE2="0"

    if [ -d "objs" ]; then
      IS_MAKE2="$(ls objs/*.o|wc -l)"
    fi

    if [[ $IS_MAKE == "0" ]]; then
      if [[ $IS_MAKE2 == "0" ]]; then
        if [[ -z "$3" ]]; then
      ./configure $2
      make && make install
    fi
    Info "[$1] is Done."
      else
    Info "[$1] is already Installed."
      fi
    fi
    cd ~/
  else
    Err "Failed untar [$1]."
  fi

}

##########################

DIRECTORY="/Data/tgz"
PCRE="pcre-8.36"
NGINX="nginx-1.7.9"
#http://tengine.taobao.org/download/tengine-2.1.0.tar.gz
TENGINE="tengine-2.1.0"

#MYSQL="mariadb-10.0.15"
MYSQL="mysql-5.6.22"

##########################

MkMl $DIRECTORY

CHECK_YUM=`yum list installed|awk '{print $1}'`
IS_YUM_INSTALLED=0
for m in $CHECK_YUM
do
  #匹配：http://mywiki.wooledge.org/BashFAQ/031 [ or [[ ?
  if [[ $m =~ ^gd\-devel\. ]]
  then
    IS_YUM_INSTALLED=1
    break
  fi
done

if [ $IS_YUM_INSTALLED == 0 ]
then

  /bin/yum -y install wget perl pcre make gcc gcc-c++ autoconf \
  cmake libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel \
  libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 \
  glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl \
  curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel \
  libidn libidn-devel openssl openssl-devel gd gd2 gd-devel gd2-devel \
  iptables-services

fi

IS_ADD_USER=`cat /etc/passwd|grep website`
if [[ $IS_ADD_USER == "" ]]; then
    /sbin/groupadd website
    /sbin/useradd -g website website
fi

ulimit -SHn 65535

######start PCRE

#DelFile "/Data/tgz/$PCRE.tar.gz"

GetFile "/Data/tgz/$PCRE.tar.gz" "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/$PCRE"

UnTar "/Data/tgz/" $PCRE

if [ -d "/Data/tgz/$PCRE" ]; then
    cd "/Data/tgz/$PCRE"
    IS_MAKE="$(ls *.lo|wc -l)"
    if [ $IS_MAKE == "0" ]; then
    ./configure --prefix=/Data/apps/pcre
    make && make install
    Info "[$PCRE] is Done."
    else
    Info "[$PCRE] is already Installed."
    fi
    cd ~/
else
    Err "Failed untar [$PCRE]."
fi

######end PCRE

######start nginx
#DelFile "/Data/tgz/$NGINX.tar.gz"

GetFile "/Data/tgz/$NGINX.tar.gz" "http://nginx.org/download/$NGINX.tar.gz"

UnTar "/Data/tgz/" $NGINX

if [ -d "/Data/tgz/$NGINX" ]; then
    cd "/Data/tgz/$NGINX"

    IS_MAKE="0"
    if [ -d "objs" ]; then
      IS_MAKE="$(ls objs/*.o|wc -l)"
    fi

    if [ $IS_MAKE == "0" ]; then
    ./configure --user=website --group=website \
    --prefix=/Data/apps/nginx \
    #--with-http_stub_status_module \
    --with-http_ssl_module \
    --with-pcre=/Data/apps/pcre \
    #--with-http_realip_module \
    #--with-http_image_filter_module
    make
    make install
    Info "[$NGINX] isDone."
    else
    Info "[$NGINX] is already Installed."
    fi
    cd ~/
else
    Err "Failed untar [$NGINX]."
fi
######end nginx

######start tengine
#DelFile "/Data/tgz/$TENGINE.tar.gz"

GetFile "/Data/tgz/$TENGINE.tar.gz" "http://tengine.taobao.org/download/$TENGINE.tar.gz"

UnTar "/Data/tgz/" $TENGINE

if [ -d "/Data/tgz/$TENGINE" ]; then
    cd "/Data/tgz/$TENGINE"
    IS_MAKE="0"
    if [ -d "objs" ]; then
      IS_MAKE="$(ls objs/*.o|wc -l)"
    fi
    if [ $IS_MAKE == "0" ]; then
    ./configure --prefix=/Data/apps/tengine \

    --enable-mods-shared=all \
    --dso-path=/Data/apps/dso \
    --dso-tool-path=/Data/apps/dso-tool \
    #jemalloc 一个性能非常卓越的内存分配器
    #--with-jemalloc=/path \
    --with-http_concat_module \
    --with-http_concat_module=shared \
    --with-http_trim_filter_module=shared \

    #--with-http_stub_status_module \
    --with-http_ssl_module \
    --with-pcre=/Data/apps/pcre \
    #--with-http_realip_module \
    #--with-http_image_filter_module
    make
    make install
    Info "[$TENGINE] isDone."
    else
    Info "[$TENGINE] is already Installed."
    fi
    cd ~/
else
    Err "Failed untar [$TENGINE]."
fi
######end tengine

######start mysql
#DelFile "/Data/tgz/$MYSQL.tar.gz"

GetFile "/Data/tgz/$MYSQL.tar.gz" "http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.22.tar.gz"

UnTar "/Data/tgz/" $MYSQL

IS_ADD_USER=`cat /etc/passwd|grep mysql`
if [[ $IS_ADD_USER == "" ]]; then
    /sbin/groupadd mysql
    /sbin/useradd -g mysql mysql
fi

CONFIG_MYSQL=0
if [ -d "/Data/tgz/$MYSQL" ]; then
    cd "/Data/tgz/$MYSQL"
    #IS_MAKE="$(ls objs/*.o|wc -l)"
    if [ ! -d "/Data/apps/mysql/usr/local/mysql/lib" ]; then
        MkMl "/Data/apps/mysql"
        chmod +w /Data/apps/mysql
    chown -R mysql:mysql /Data/apps/mysql

    cd "/Data/apps/mysql"

    #./configure --prefix=/Data/apps/mysql

    #http://dev.mysql.com/doc/refman/5.6/en/installing-source-distribution.html
    #make clean
    #DelFile "CMakeCache.txt"
    cmake /Data/tgz/$MYSQL -LH  #“.”表示编译当前目录，-LH编译完后打印出选项
    #-LAH # all params with help text
    make
    make install DESTDIR="/Data/apps/mysql"

    Info "[$MYSQL] isDone."
    CONFIG_MYSQL=1
    else
    Info "[$MYSQL] is already Installed."
    CONFIG_MYSQL=1
    fi
    cd ~/
else
    Err "Failed untar [$MYSQL]."
fi

MYSQL_RUNNING=`netstat -an|grep 3306|awk '{print $4}'`

if [ $MYSQL_RUNNING==":::3306" ]; then
  Info "[Mysql] is running"
else
  if [ $CONFIG_MYSQL==1 ]; then

    #http://howtolamp.com/lamp/mysql/5.6/installing/
    cd "/Data/apps/mysql"

    if [[ ${PATH} =~ ^\/Data\/apps\/mysql ]]; then
        Info ${PATH}
    else
        PATH=/Data/apps/mysql/usr/local/mysql/bin:${PATH}
    fi
    #share MySQL Server libraries
    echo "/Data/apps/mysql/usr/local/mysql/lib" > /etc/ld.so.conf.d/mysql.conf
    #ldconfig scans the ld.so.conf.d folder and updates the shared library cache;
    ldconfig

    chown -R mysql usr/local/mysql
    chgrp -R mysql usr/local/mysql
    usr/local/mysql/scripts/mysql_install_db --basedir=/Data/apps/mysql/usr/local/mysql --user=mysql
    chown -R root usr/local/mysql
    chown -R mysql usr/local/mysql/data
    chmod -R go-rwx usr/local/mysql/data

    DelFile /etc/my.cnf
    cp usr/local/mysql/support-files/my-default.cnf /etc/my.cnf
    echo "user = mysql" >> /etc/my.cnf
    echo "basedir = /Data/apps/mysql/usr/local/mysql" >> /etc/my.cnf
    echo "datadir = /Data/apps/mysql/usr/local/mysql/data" >> /etc/my.cnf
    echo "port = 3306" >> /etc/my.cnf
    echo "server_id = 1" >> /etc/my.cnf
    echo "socket = /tmp/mysql.sock" >> /etc/my.cnf

    echo "join_buffer_size = 128M" >> /etc/my.cnf
    echo "sort_buffer_size = 2M" >> /etc/my.cnf
    echo "read_rnd_buffer_size = 2M" >> /etc/my.cnf

    DelFile /etc/rc.d/init.d/mysql
    cp usr/local/mysql/support-files/mysql.server /etc/rc.d/init.d/mysql

    cd /Data/apps/mysql/usr/local/mysql
    ./bin/mysqld_safe --user=mysql &

    #Add mysql as a Sys V init service.
    chkconfig --add mysql

    service mysql start

    #Displays the status of MySQL service
    # service mysql status
    #Displays the status of mysqld daemon
    # mysqladmin -u root -p ping
    #Displays the status of server with variables
    # mysqladmin -u root -p status
    #Display the status of server with variables and their values
    # mysqladmin -u root -p extended-status

    #Displays a list of active server threads
    # mysqladmin -u root -p processlist
    #Displays a list of active server threads with full processlist
    # mysqladmin -u root -p -v processlist

    #Displays a list of server system variables and their values
    # mysqladmin -u root -p variables
    #Get information on Server version
    # mysqladmin -u root -p version

    cd ~/
  fi
fi

######end mysql

######start php

MkMl /Data/apps/libs/

JPEG="jpeg-9"

GetFile "/Data/tgz/$JPEG.tar.gz" "http://www.ijg.org/files/$JPEG.tar.gz"
UnTar "/Data/tgz/" $JPEG
Install $JPEG "--prefix=/Data/apps/libs --enable-shared --enable-static"

PNG="libpng-1.6.2"

GetFile "/Data/tgz/$PNG.tar.gz" "http://prdownloads.sourceforge.net/libpng/$PNG.tar.gz"
UnTar "/Data/tgz/" $PNG
Install $PNG "--prefix=/Data/apps/libs"

FREETYPE="freetype-2.4.12"

GetFile "/Data/tgz/$FREETYPE.tar.gz" "http://download.savannah.gnu.org/releases/freetype/$FREETYPE.tar.gz"
UnTar "/Data/tgz/" $FREETYPE
Install $FREETYPE "--prefix=/Data/apps/libs"

MHASH="mhash-0.9.9.9"

GetFile "/Data/tgz/$MHASH.tar.gz" "http://downloads.sourceforge.net/mhash/$MHASH.tar.gz"
UnTar "/Data/tgz/" $MHASH
Install $MHASH "--prefix=/Data/apps/libs"

LIBMCRYPT="libmcrypt-2.5.8"

GetFile "/Data/tgz/$LIBMCRYPT.tar.gz" "http://downloads.sourceforge.net/mcrypt/$LIBMCRYPT.tar.gz"
UnTar "/Data/tgz/" $LIBMCRYPT
Install $LIBMCRYPT "--prefix=/Data/apps/libs"

MCRYPT2="mcrypt-2.6.8"

GetFile "/Data/tgz/$MCRYPT2.tar.gz" "http://downloads.sourceforge.net/mcrypt/$MCRYPT2.tar.gz"
UnTar "/Data/tgz/" $MCRYPT2
Install $MCRYPT2 "--prefix=/Data/apps/libs --with-libmcrypt-prefix=/Data/apps/libs"

LDCONFIG=`cat /etc/ld.so.conf | grep /Data/apps/libs`
if [[ $LDCONFIG == "" ]]; then
  echo "/Data/apps/libs/lib" >> /etc/ld.so.conf
  ldconfig
fi

PTHREADS="pthreads-2.0.10"

GetFile "/Data/tgz/$PTHREADS.tar.gz" "http://pecl.php.net/get/$PTHREADS.tgz"
UnTar "/Data/tgz/" $PTHREADS
Install $PTHREADS "--prefix=/Data/apps/libs" "no-config"

PHP5="php-5.6.5"

GetFile "/Data/tgz/$PHP5.tar.gz" "http://cn2.php.net/get/$PHP5.tar.gz/from/this/mirror"
UnTar "/Data/tgz/" $PHP5


if [ -d "/Data/tgz/$PHP5" ]; then
    cd "/Data/tgz/$PHP5"
    IS_MAKE="0"
    IS_MAKE2="0"

    IS_MAKE="$(ls|grep config.log|wc -l)"
    if [ -d "/Data/tgz/$PHP5/objs" ]; then
      IS_MAKE2="$(ls objs/*.o|wc -l)"
    fi
    if [[ $IS_MAKE == "0" ]]; then
      if [[ $IS_MAKE2 == "0" ]]; then

    #http://docs.php.net/manual/en/pthreads.installation.php
    if [[ -d "/Data/tgz/$PHP5/ext/$PTHREADS" ]]; then
      rm -rf "/Data/tgz/$PHP5/ext/$PTHREADS"
    fi
    if [[ -d "/Data/tgz/$PHP5/ext/pthreads" ]]; then
      rm -rf "/Data/tgz/$PHP5/ext/pthreads"
    fi
        cp -R "/Data/tgz/$PTHREADS" "/Data/tgz/$PHP5/ext/"
    mv "/Data/tgz/$PHP5/ext/$PTHREADS" "/Data/tgz/$PHP5/ext/pthreads"
        ./buildconf --force
        ./configure --help | grep pthreads

        export LIBS="-lm -ltermcap -lresolv"
        export DYLD_LIBRARY_PATH="/Data/apps/mysql/lib/:/lib/:/usr/lib/:/usr/local/lib:/lib64/:/usr/lib64/:/usr/local/lib64"
        export LD_LIBRARY_PATH="/Data/apps/mysql/lib/:/lib/:/usr/lib/:/usr/local/lib:/lib64/:/usr/lib64/:/usr/local/lib64"
    make clear
    make clean
    ./configure --prefix=/Data/apps/php \
    --enable-maintainer-zts --enable-pthreads \
    --with-config-file-path=/Data/apps/php/etc \
    --with-mysql=/Data/apps/mysql/usr/local/mysql \
    --with-mysqli=/Data/apps/mysql/usr/local/mysql/bin/mysql_config \
    --with-iconv-dir --with-freetype-dir=/Data/apps/libs \
    --with-jpeg-dir=/Data/apps/libs \
    --with-png-dir=/Data/apps/libs --with-zlib \
    --with-libxml-dir=/usr --enable-xml --disable-rpath \
    --enable-bcmath --enable-shmop --enable-sysvsem \
    --enable-inline-optimization --with-curl \
    --enable-mbregex --enable-fpm --enable-mbstring \
    --with-mcrypt=/Data/apps/libs --with-gd \
    --enable-gd-native-ttf --with-openssl --with-mhash \
    --enable-pcntl --enable-sockets --with-xmlrpc \
    --enable-zip --enable-soap --enable-opcache \
    --with-pdo-mysql


    make && make install
    #DelFile /Data/apps/php/etc/php.ini
    if [[ ! -f "/Data/apps/php/etc/php.ini" ]];then
      cp php.ini-development /Data/apps/php/etc/php.ini
    fi
    #echo "extension = "pthreads.so"" >> /Data/apps/php/etc/php.ini
    if [[ -f "/Data/apps/mysql/usr/local/mysql/lib/libmysqlclient.18.dylib" ]];then
      ln -s /Data/apps/mysql/usr/local/mysql/lib/libmysqlclient.18.dylib /usr/lib/libmysqlclient.18.dylib
    fi
    if [[ ! -f "/Data/apps/php/etc/php-fpm.conf" ]];then
      mv /Data/apps/php/etc/php-fpm.conf.default /Data/apps/php/etc/php-fpm.conf
    fi
    #ulimit -SHn 65535
        #/Data/apps/php/sbin/php-fpm

    /Data/apps/php/bin/pecl install pthreads

    Info "[$PHP5] is Done."
      else
    Info "[$PHP5] is already Installed."
      fi
    else
      Info "[$PHP5] is already Installed."
    fi
    cd ~/
else
    Err "Failed untar [$PHP5]."
fi

#####

AUTOCONF="autoconf-2.69"

GetFile "/Data/tgz/$AUTOCONF.tar.gz" "http://ftp.gnu.org/gnu/autoconf/$AUTOCONF.tar.gz"
UnTar "/Data/tgz/" $AUTOCONF
Install $AUTOCONF "--prefix=/Data/apps/libs"

MEMCACHE="memcache-3.0.8"

GetFile "/Data/tgz/$MEMCACHE.tgz" "http://pecl.php.net/get/$MEMCACHE.tgz"
UnTgz "/Data/tgz/" $MEMCACHE
if [ -d "/Data/tgz/$MEMCACHE" ]; then
    cd "/Data/tgz/$MEMCACHE"

    IS_MAKE="$(ls|grep config.log|wc -l)"
    IS_MAKE2="0"
    if [ -d "objs" ]; then
      IS_MAKE2="$(ls objs/*.o|wc -l)"
    fi
    if [[ $IS_MAKE == "0" ]]; then
      if [[ $IS_MAKE2 == "0" ]]; then
        export PHP_AUTOCONF="/Data/apps/libs/bin/autoconf"
        export PHP_AUTOHEADER="/Data/apps/libs/bin/autoheader"
        /Data/apps/php/bin/phpize
    ./configure --with-php-config=/Data/apps/php/bin/php-config
    make && make install
    #echo "extension = "memcache.so"" >> /Data/apps/php/etc/php.ini
    Info "[$MEMCACHE] is Done."
      else
    Info "[$MEMCACHE] is already Installed."
      fi
    fi
    cd ~/
else
    Err "Failed untar [$MEMCACHE]."
fi


sed -i 's#extension_dir = "./"#extension_dir = "/Data/apps/php/lib/php/extensions/no-debug-non-zts-20060613/"\nextension = "memcache.so"\nextension = "pthreads.so"\n#' /Data/apps/php/etc/php.ini
#设置output_buffering=0彻底禁用output buffering机制
#禁用了php buffering机制之后，在浏览器可以断断续续看到间断性输出，不必等到脚本执行完毕才看到输出。
#sed -i 's#output_buffering = On#output_buffering = Off#' /Data/apps/php/etc/php.ini

#是否总是生成$HTTP_RAW_POST_DATA变量(原始POST数据)。
#否则，此变量仅在遇到不能识别的MIME类型的数据时才产生。
#不过，访问原始POST数据的更好方法是 php://input 。
sed -i "s#; date.timezone = #date.timezone = Aisa/Hong_Kong#g" /Data/apps/php/etc/php.ini

#sed -i "s#; always_populate_raw_post_data = Off#always_populate_raw_post_data = On#g" /Data/apps/php/etc/php.ini

#打开此指令，并修正脚本以使用 SCRIPT_FILENAME 代替 PATH_TRANSLATED 。
sed -i "s#; cgi.fix_pathinfo=0#cgi.fix_pathinfo=0#g" /Data/apps/php/etc/php.ini
#http://www.80sec.com/ddos-attack-defend.html

#exit(0)

######end php

######start sysctl
if [[ ! -f "/etc/sysctl.conf.bak" ]]; then
  cp /etc/sysctl.conf /etc/sysctl.conf.bak
  cat /home/adam/adamrepo/nginx/sysctl.conf  > /etc/sysctl.conf

  #立即生效
  /sbin/sysctl -p
fi
######end sysctl

######end log

RUN_CRONTAB=0
if [[ $RUN_CRONTAB == 1 ]]; then
  cat /home/adam/adamrepo/nginx/cut_nginx_log.sh  > /Data/apps/tengine/sbin/cut_nginx_log.sh
  #write out current crontab
  crontab -l > mycron
  #echo new cron into cron file
  echo "00 00 * * * /bin/bash  /Data/apps/tengine/sbin/cut_nginx_log.sh" >> mycron
  #install new cron file
  crontab mycron
  rm -f mycron
fi

######end log


######start iptables
#iptables
#https://logicdudes.com/how-to/setup-centos-7/iptables
#iptables-save > /etc/sysconfig/iptables
#vi /etc/sysconfig/iptables

#yum install iptables-services
#systemctl start iptables
#systemctl enable iptables

#http://wiki.centos.org/zh/HowTos/Network/IPTables

iptables -P INPUT ACCEPT
iptables -F
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

Info "[iptables] Done"
#iptables -L -v

##iptables -I INPUT 5 -i eth0 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
##iptables -I INPUT 5 -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT

#iptables --line -vnL
service iptables save
service iptables restart

#Set the default INPUT policy to DROP.
#:INPUT DROP [0:0]

#Allow all traffic to move freely through the lo device (127.0.0.1)
#-A INPUT -i lo -j ACCEPT

#Allow RELATED and ESTABLISHED packets
#-A INPUT -m state –state RELATED,ESTABLISHED -j ACCEPT

#Block NULL Packets
#-A INPUT -p tcp –tcp-flags ALL NONE -j DROP

#Block SYN Packets
#-A INPUT -p tcp ! –syn -m state –state NEW -j DROP

#Block XMAS Packets
#-A INPUT -p tcp –tcp-flags ALL ALL -j DROP

#Open port 22 for SSH
#-A INPUT -s 72.186.229.42/32 -p tcp -m tcp –dport 22 -j ACCEPT

#Allow SMTP Packets
#-A INPUT -p tcp -m tcp –dport 25 -j ACCEPT

#Allow DNS tcp & udp Packets
#-A INPUT -p tcp -m tcp –dport 53 -j ACCEPT -A INPUT -p udp -m udp –dport 53 -j ACCEPT

#Allow HTTP & HTTPS Packets
#-A INPUT -p tcp -m tcp –dport 53 -j ACCEPT -A INPUT -p udp -m udp –dport 53 -j ACCEPT

######end iptables
