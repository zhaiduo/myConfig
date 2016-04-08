####Author:Adam 201501
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
REDIS="redis-2.8.19"

##########################

#DelFile "/Data/tgz/$REDIS.tar.gz"

GetFile "/Data/tgz/$REDIS.tar.gz" "http://download.redis.io/releases/$REDIS.tar.gz"

UnTar "/Data/tgz/" $REDIS

if [ -d "/Data/tgz/$REDIS" ]; then
    cd "/Data/tgz/$REDIS"
    IS_MAKE="$(ls src/*.o|wc -l)"
    if [ $IS_MAKE == "0" ]; then
    #./configure --prefix=/Data/apps/pcre
    make
        #make install

    GetFile "/Data/tgz/$REDIS/redis.conf" "https://raw.githubusercontent.com/antirez/redis/2.8/redis.conf"
    Info "[$REDIS] is Done."
    else
    Info "[$REDIS] is already Installed."
    fi
    cd ~/
else
    Err "Failed untar [$REDIS]."
fi

#as cache in redis.conf
#maxmemory 2mb
#maxmemory-policy allkeys-lru

#exit(0)

if [[ ! -f "/Data/apps/composer/composer.phar" ]]; then
  MkMl "/Data/apps/composer"
  cat /home/adam/adamrepo/nginx/installer.php | /Data/apps/php/bin/php -- --install-dir=/Data/apps/composer
  Info "[composer] is already Installed."
fi
