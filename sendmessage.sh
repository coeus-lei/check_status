#!/bin/bash
script_dir=$( cd $(dirname "$0") && pwd )
line=`cat ${script_dir}/result.log | wc -l`
line1=`cat ${script_dir}/result1.log | wc -l`
Domain_Status=`awk '{print $6}' ${script_dir}/result.log`
Token_api="$API"
Chat_id="$ID"
#cat ${script_dir}/result.log | while read line
#do
awk '{if($6==000||$6==403||$6==404||$6>=500)print}' ${script_dir}/result.log >${script_dir}/result1.log
#awk '{print}' ${script_dir}/result.log >${script_dir}/result1.log
#done
sed -i '1 i\以下为故障域名及状态码' ${script_dir}/result1.log
if [ $line1 -lt 20 ];then
        curl -X POST "https://api.telegram.org/bot${Token_api}/sendMessage" -d "chat_id=${Chat_id}&text=`head -21 ${script_dir}/result1.log`"
fi
if [ $line1 -gt 20 ];then
        curl -F document=@"${script_dir}/result1.log" https://api.telegram.org/bot${Token_api}/sendDocument?chat_id=${Chat_id}
fi
#>${script_dir}/result1.log
