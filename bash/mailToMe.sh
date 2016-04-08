#!/bin/bash

#crontab: 03 10 * * * /root/mailToMe.sh
df|mail -s "df" zhaiduo@gmail.com
