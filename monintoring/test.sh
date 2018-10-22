#!/bin/bash

Bird_Node=('Michotte' 'Carnoy' 'SH1C' 'Halles' 'Pythagore' 'Stevin' 'MONIT' 'ADNS01' 'ADNS02' 'RDNS01' 'RDNS02')

file=('/etc/nagios/nrpe.cfg' 'fichier2.txt' 'fichier3.txt')
value=('allowed_hosts=127.0.0.1' 'value2' 'value3')
new_value=('allowed_hosts=fd00:300:7:57::10' 'new_value2' 'new_value3')

echo "[INFO] test."

echo "command[check_memory]=/usr/local/nagios/libexec/check_memory.pl -w $ARG1$ -c $ARG2$ -M $ARG3$" >> /etc/nagios/nrpe.cfg
