#!/bin/bash

Bird_Node_router=('Michotte' 'Carnoy' 'SH1C' 'Halles' 'Pythagore' 'Stevin')
Bird_Node=('Michotte' 'Carnoy' 'SH1C' 'Halles' 'Pythagore' 'Stevin' 'MONIT' 'ADNS01' 'ADNS02' 'RDNS01' 'RDNS02')
IP6_Node=('fd00:200:7:34::4' 'fd00:200:7:34::4' 'fd00:200:7:34::3' 'fd00:200:7:13::1' 'fd00:200:7:12::2' 'fd00:200:7:56::6' 'fd00:200:7:57::10' 'fd00:200:7:27::7'
'fd00:200:7:57::7' 'fd00:200:7:29::9' 'fd00:200:7:59::9')


file=('/etc/nagios/nrpe.cfg' 'fichier2.txt' 'fichier3.txt')
value=('allowed_hosts=127.0.0.1' 'value2' 'value3')
new_value=('allowed_hosts=fd00:300:7:57::10' 'new_value2' 'new_value3')

#####################################################

/usr/sbin/nagios3stats

echo "==============================================*MONINTORING*===========================================================\n"
        echo "|Host_name | link |Status  | Time_up |CPU   | check_Update|Check_user |\n"
        echo "===================================================================================================================\n"


j=0
for i in  ${Bird_Node[*]}
        do

		for i in  ${Bird_Node[$j]}
       		 do

printf "===================================================================================================================\n"
printf "| %20s | %40s \n" $i ${IP6_Node[$j]}
printf "===================================================================================================================\n"

                        for Status in $(/usr/lib/nagios/plugins/check_nrpe -H \"${IP6_Node[$j]}\" check_host); do printf "%s " $Status ;done
                        for Uptime in $(/usr/lib/nagios/plugins/check_nrpe -H \"${IP6_Node[$j]}\" check_uptime.pl -w 30 -c 60); do printf "%s \n" $Uptime ;done
                        for Check_load in $(/usr/lib/nagios/plugins/check_nrpe -H \"${IP6_Node[$j]}\" check_load); do printf "%s " $Check_load ;done
                        for check_users in $(/usr/lib/nagios/plugins/check_nrpe -H \"${IP6_Node[$j]}\" check_users); do printf "%s " $check_users ;done
                        for Check_update in $(/usr/lib/nagios/plugins/check_nrpe -H \"${IP6_Node[$j]}\" check_apt); do printf "%s " $Check_update ;done
			((j++))

		done

done

####################################################

for i in  ${Bird_Node_router[*]}
        do
printf "===================================================================================================================\n"
printf "| %20s \n" $i
printf "===================================================================================================================\n"

for check_bird_proto in $(/usr/lib/nagios/plugins/check_bird_proto.pl  -p all -s \"$i\"); do printf "%s " $check_bird_proto ;done

	done
