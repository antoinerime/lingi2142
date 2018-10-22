#!/bin/bash

Bird_Node=('Michotte' 'Carnoy' 'SH1C' 'Halles' 'Pythagore' 'Stevin' 'MONIT' 'ADNS01' 'ADNS02' 'RDNS01' 'RDNS02')

file=('/etc/nagios/nrpe.cfg' 'fichier2.txt' 'fichier3.txt')
value=('allowed_hosts=127.0.0.1' 'value2' 'value3')
new_value=('allowed_hosts=fd00:300:7:57::10' 'new_value2' 'new_value3')

sudo echo "deb http://ftp.de.debian.org/debian jessie main non-free" >> /etc/apt/sources.list
sudo apt-get update

echo "[INFO] ."
sudo apt-get install -y libtimedate-perl libdatetime-perl libdatetime-format-duration-perl libnet-ip-perl libswitch-perl libtemplate-perl

echo "[INFO] installation nagios and all its plugins "
sudo apt-get install -y nagios3 nagios-plugins nagios-nrpe-plugin nagios-plugins-contrib nagios-plugins-rabbitmq nagios-plugins-standard

echo "[INFO] installation of the Nagios Remote Plugin Executor (NRPE) plug-in to monitor service and remote Linux / Unix network device"
sudo apt-get install -y nagios-nrpe-server

echo "[INFO] installation snmp pacquet "
sudo apt-get install -y snmp snmpd snmp-mibs-downloader

echo "[INFO] installation make pacquet "
sudo apt-get install -y make

echo "[INFO] installation Plugin Monitoring pacquet for perl "
sudo cpan -i Monitoring::Plugin Net::SNMP
sudo cpan -i Proc::ProcessTable
sudp cpan -i Sys::MemInfo

sudo apt-get install -y libstdc++5
sudo apt-get install -y gcc


echo "command[check_memory]=/usr/lib/nagios/plugins/check_memory.pl -w $ -c $ -M $" >> /etc/nagios/nrpe.cfg
echo "command[check_uptime]=/usr/lib/nagios/plugins/check_uptime.pl -w $ARG1$ -c $ARG2$" >> /etc/nagios/nrpe.cfg
echo "command[check_process]=/usr/lib/nagios/plugins/check_process.pl -n $ARG1$" >> /etc/nagios/nrpe.cfg
echo "command[check_apt]=/usr/lib/nagios/plugins/check_apt $ARG1$" >> /etc/nagios/nrpe.cfg


echo "copie the perl plugin to /usr/lib/nagios/plugins/"
cp *.pl /usr/lib/nagios/plugins/

##############
#fonction to configured automaticaly file
function change_configuration
{

        for file in  "$1"
                do
                        echo "file processing  $1 ..."
                        sudo  sed -i -e "s/$2/$3/g" "$1"
                done
}

#call change_configuration function
j=0
for i in  ${file[*]}
        do
                change_configuration  ${file[$j]} ${value[$j]} ${new_value[$j]}
                ((j++))
        done
###############

#copie snmp folder to the node
echo "[INFO] create nagios configuration files for nodes"

for i in  ${Bird_Node[*]}
        do
                echo "[INFO] copie snmp files to the nodes $i ..."
                sudo cp -Rf /etc/snmp/ ~/lingi2142/gr7_cfg/"$i"/
		sudo cp -Rf /etc/nagios3/ ~/lingi2142/gr7_cfg/"$i"/
		sudo cp -Rf /etc/nagios/ ~/lingi2142/gr7_cfg/"$i"/
		sudo cp -Rf /etc/nagios-plugins/ ~/lingi2142/gr7_cfg/"$i"/
		sudo cp -Rf /etc/init.d/ ~/lingi2142/gr7_cfg/"$i"/
		sudo cp /etc/group ~/lingi2142/gr7_cfg/"$i"/
		sudo cp /etc/passwd ~/lingi2142/gr7_cfg/"$i"/
        done

#backup of configuration files
echo "[INFO] backup of configuration files"
for i in  ${file[*]}
	do
		echo "[INFO] backup of configuration file $i ..."
		sudo cp "$i" "$i.save"
	done

#create nagios configuration files for nodes
echo "[INFO] create nagios configuration files for nodes"

for i in  ${Bird_Node[*]}
        do
                echo "[INFO] create configuration file $i ..."
                sudo cp ~/lingi2142/gr7_cfg/monintoring/"$i".cfg ~/lingi2142/gr7_cfg/MONIT/nagios3/conf.d/
        done


#Restarting service
echo "[INFO] Restarting the nagios service"
sudo /etc/init.d/nagios3 restart

echo "[INFO] Restarting the nrpe service"
sudo /etc/init.d/nagios-nrpe-server restart

echo "[INFO] Restarting the snmp service"
sudo /etc/init.d/snmpd restart
