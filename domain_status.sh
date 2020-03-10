#!/bin/bash
script_dir=$( cd $(dirname "$0") && pwd )
Domain_Data=`cat domain_ssl.info`
if [ -z "$Domain_Data" ];then
    echo "Faild to connect database!"
    exit 1
fi

delay() {
        sleep 2
}
tmp_fifofile=/tmp/$$.fifo
mkfifo $tmp_fifofile
exec 6<>$tmp_fifofile
rm $tmp_fifofile
thread=100
for ((i=0;i<$thread;i++))
do
        echo
done>&6

for url in $Domain_Data
do
        read -u6
        {
        code=`curl -o /dev/null --retry 3 --retry-max-time 8 -s -w "%{http_code}" $url`
        echo "HTTP STATUS of $url is $code"  >> result.log
        delay && {
                echo "HTTP STATUS of $url is $code"
        } || {
                echo "CHECK THREAD ERROR!"
        }
                echo >& 6
        }&
done
wait
exec 6>&-
exit 0
