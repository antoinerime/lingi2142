#!/bin/bash

Bird_Node=('Michotte' 'Carnoy' 'SH1C' 'Halles' 'Pythagore' 'Stevin' 'MONIT' 'ADNS01' 'ADNS02' 'RDNS01' 'RDNS02')
IP6_Node=('fd00:200:7:34::4' 'fd00:200:7:34::4' 'fd00:200:7:34::3' 'fd00:200:7:13::1' 'fd00:200:7:12::2' 'fd00:200:7:56::6' 'fd00:200:7:57::10' 'fd00:200:7:27::7')


#Check_User = $(`/usr/lib/nagios/plugins/check_nrpe -H "${IP6_Node[0]}" check_users`)
for i in  ${IP6_Node[*]}
do
echo "agentAddress udp6:["$i"]:161" >> fichier.txt

done



#res=$(grep ...)
#echo "Le résultat est $res"
#if test -n "$res"
#then
#    echo ok
#else
#    echo bad
#fi
