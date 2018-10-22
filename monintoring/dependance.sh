#!/bin/bash

Bird_Node=('Michotte' 'Carnoy' 'SH1C' 'Halles' 'Pythagore' 'Stevin' 'MONIT' 'ADNS01' 'ADNS02' 'RDNS01' 'RDNS02')

file=('/etc/nagios/nrpe.cfg' '/etc/snmp/snmpd.conf' '/etc/snmp/snmpd.conf')
value=('allowed_hosts=127.0.0.1' '#agentAddress udp:161,udp6:[::1]:161' ' rocommunity public  default    -V systemonly')
new_value=('allowed_hosts=fd00:300:7:57::10' 'agentAddress udp6:[fd00:200::7:1]:161' '# rocommunity public  default    -V systemonly')

echo "deb http://ftp.de.debian.org/debian jessie main non-free" >> /etc/apt/sources.list
apt-get update

echo "[INFO] ."
apt-get install -y libtimedate-perl libdatetime-perl libdatetime-format-duration-perl libnet-ip-perl libswitch-perl libtemplate-perl

echo "[INFO] installation nagios and all its plugins "
apt-get install -y nagios3 nagios-plugins nagios-nrpe-plugin nagios-plugins-contrib nagios-plugins-rabbitmq nagios-plugins-standard

echo "[INFO] installation of the Nagios Remote Plugin Executor (NRPE) plug-in to monitor service and remote Linux / Unix network device"
apt-get install -y nagios-nrpe-server

echo "[INFO] installation snmp pacquet "
apt-get install -y snmp snmpd snmp-mibs-downloader

echo "[INFO] installation make pacquet "
apt-get install -y make

echo "[INFO] installation Plugin Monitoring pacquet for perl "
cpan -i Monitoring::Plugin Net::SNMP
cpan -i Proc::ProcessTable
cpan -i Sys::MemInfo

apt-get install -y libstdc++5
apt-get install -y gcc


#backup of configuration files
echo "[INFO] backup of configuration files"
for i in  ${file[*]}
        do
                echo "[INFO] backup of configuration file $i ..."
                cp "$i" "$i.save"
        done

echo "command[check_memory]=/usr/lib/nagios/plugins/check_memory.pl -w $ -c $ -M $" >> /etc/nagios/nrpe.cfg
echo "command[check_uptime]=/usr/lib/nagios/plugins/check_uptime.pl -w $ARG1$ -c $ARG2$" >> /etc/nagios/nrpe.cfg
echo "command[check_process]=/usr/lib/nagios/plugins/check_process.pl -n $ARG1$" >> /etc/nagios/nrpe.cfg
echo "command[check_apt]=/usr/lib/nagios/plugins/check_apt $ARG1$" >> /etc/nagios/nrpe.cfg


echo "copie the perl plugin to /usr/lib/nagios/plugins/"
cp ~/lingi2142/monintoring/*.pl /usr/lib/nagios/plugins/

##############
#fonction to configured automaticaly file
function change_configuration
{

        for file in  "$1"
                do
                        echo "file processing  $1 ..."
                        sed -i -e "s/$2/$3/g" "$1"
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
                cp -Rf /etc/snmp/ ~/lingi2142/gr7_cfg/"$i"/
		cp -Rf /etc/snmp-mibs-downloader/ ~/lingi2142/gr7_cfg/"$i"/
		cp -Rf /etc/nagios3/ ~/lingi2142/gr7_cfg/"$i"/
		cp -Rf /etc/nagios/ ~/lingi2142/gr7_cfg/"$i"/
		cp -Rf /etc/nagios-plugins/ ~/lingi2142/gr7_cfg/"$i"/
		cp -Rf /etc/init.d/ ~/lingi2142/gr7_cfg/"$i"/
		cp /etc/group ~/lingi2142/gr7_cfg/"$i"/
		cp /etc/passwd ~/lingi2142/gr7_cfg/"$i"/
        done

#create nagios configuration files for nodes
echo "[INFO] create nagios configuration files for nodes"

for i in  ${Bird_Node[*]}
        do
                echo "[INFO] create configuration file $i ..."
                cp ~/lingi2142/gr7_cfg/monintoring/"$i".cfg ~/lingi2142/gr7_cfg/MONIT/nagios3/conf.d/
        done


#Restarting service
echo "[INFO] Restarting the nagios service"
/etc/init.d/nagios3 restart

echo "[INFO] Restarting the nrpe service"
/etc/init.d/nagios-nrpe-server restart

echo "[INFO] Restarting the snmp service"
/etc/init.d/snmpd restart


echo "[FIN] Terminede"
