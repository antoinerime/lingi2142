#!/bin/bash

Bird_Node=('Michotte' 'Carnoy' 'SH1C' 'Halles' 'Pythagore' 'Stevin' 'MONIT' 'ADNS01' 'ADNS02' 'RDNS01' 'RDNS02')

file=('/etc/nagios/nrpe.cfg')
value=('allowed_hosts=127.0.0.1')
new_value=('allowed_hosts=fd00:300:7:57::10')
IP6_Node=('fd00:200:7:34::4' 'fd00:200:7:34::4' 'fd00:200:7:34::3' 'fd00:200:7:13::1' 'fd00:200:7:12::2' 'fd00:200:7:56::6' 'fd00:200:7:57::10' 'fd00:200:7:27::7'
'fd00:200:7:57::7' 'fd00:200:7:29::9' 'fd00:200:7:59::9')


echo "deb http://ftp.de.debian.org/debian jessie main non-free" >> /etc/apt/sources.list
apt-get update

echo "[INFO-gr7_cfg] ."
apt-get install -y libtimedate-perl libdatetime-perl libdatetime-format-duration-perl libnet-ip-perl libswitch-perl libtemplate-perl

echo "[INFO-gr7_cfg] installation nagios and all its plugins "
apt-get install -y nagios3 nagios-plugins nagios-nrpe-plugin nagios-plugins-contrib nagios-plugins-rabbitmq nagios-plugins-standard

echo "[INFO-gr7_cfg] installation of the Nagios Remote Plugin Executor (NRPE) plug-in to monitor service and remote Linux / Unix network device"
apt-get install -y nagios-nrpe-server

echo "[INFO-gr7_cfg] installation snmp pacquet "
apt-get install -y snmp snmpd snmp-mibs-downloader

echo "[INFO-gr7_cfg] installation make pacquet "
apt-get install -y make

echo "[INFO-gr7_cfg] installation Plugin Monitoring pacquet for perl "
cpan -i Monitoring::Plugin Net::SNMP
cpan -i Proc::ProcessTable
cpan -i Sys::MemInfo

apt-get install -y libstdc++5
apt-get install -y gcc


#backup of configuration files
echo "[INFO-gr7_cfg] backup of configuration files"
for i in  ${file[*]}
        do
                echo "[INFO] backup of configuration file $i ..."
                cp "$i" "$i.save"
        done

echo "[INFO-gr7_cfg] create command[check_memory] to /etc/nagios/nrpe.cfg "
echo "command[check_memory]=/usr/lib/nagios/plugins/check_memory.pl -w $ -c $ -M $" >> /etc/nagios/nrpe.cfg

echo "[INFO-gr7_cfg] create command[check_uptime] to /etc/nagios/nrpe.cfg "
echo "command[check_uptime]=/usr/lib/nagios/plugins/check_uptime.pl -w $ARG1$ -c $ARG2$" >> /etc/nagios/nrpe.cfg

echo "[INFO-gr7_cfg] create command[check_process] to /etc/nagios/nrpe.cfg "
echo "command[check_process]=/usr/lib/nagios/plugins/check_process.pl -n $ARG1$" >> /etc/nagios/nrpe.cfg

echo "[INFO-gr7_cfg] create command[check_apt] to /etc/nagios/nrpe.cfg"
echo "command[check_apt]=/usr/lib/nagios/plugins/check_apt $ARG1$" >> /etc/nagios/nrpe.cfg


echo "[INFO-gr7_cfg] copie the perl plugin to /usr/lib/nagios/plugins/"
cp /home/vagrant/lingi2142/monintoring/*.pl /usr/lib/nagios/plugins/

##############
#fonction to configured automaticaly file
function change_configuration
{

        for file in  "$1"
                do
                        echo "[INFO-gr7_cfg] file processing  $1 ..."
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

for i in  ${IP6_Node[*]}
	do
echo "agentAddress udp6:["$i"]:161" >> /etc/snmp/snmpd.conf


done

#copie snmp folder to the node
echo "[INFO-gr7_cfg] create nagios configuration files for nodes"

for i in  ${Bird_Node[*]}
        do
                echo "[INFO-gr7_cfg] copie snmpd and nagios files to the nodes $i ..."
                cp -Rf /etc/snmp/ /home/vagrant/lingi2142/gr7_cfg/"$i"/
		cp -Rf /etc/snmp-mibs-downloader/ /home/vagrant/lingi2142/gr7_cfg/"$i"/
		cp -Rf /etc/nagios3/ /home/vagrant/lingi2142/gr7_cfg/"$i"/
		cp -Rf /etc/nagios/ /home/vagrant/lingi2142/gr7_cfg/"$i"/
		cp -Rf /etc/nagios-plugins/ /home/vagrant/lingi2142/gr7_cfg/"$i"/
		cp -Rf /etc/init.d/ /home/vagrant/lingi2142/gr7_cfg/"$i"/
		cp /etc/group /home/vagrant/lingi2142/gr7_cfg/"$i"/
		cp /etc/passwd /home/vagrant/lingi2142/gr7_cfg/"$i"/
        done

#create nagios configuration files for nodes
echo "[INFO-gr7_cfg] create nagios configuration files for nodes"

for i in  ${Bird_Node[*]}
        do
                echo "[INFO-gr7_cfg] create configuration file $i .cfg ..."
                cp /home/vagrant/lingi2142/monintoring/"$i".cfg /home/vagrant/lingi2142/gr7_cfg/MONIT/nagios3/conf.d/
        done

        #Restarting service
        echo "[INFO-gr7_cfg] Restarting the nagios service"
        /etc/init.d/nagios3 restart

#Restarting service
echo "[INFO-gr7_cfg] Restarting the nagios service"
/etc/init.d/nagios3 restart

echo "[INFO-gr7_cfg] Restarting the nrpe service"
/etc/init.d/nagios-nrpe-server restart

echo "[INFO-gr7_cfg] Restarting the snmp service"
/etc/init.d/snmpd restart

echo "[FIN INSTALATION AND CONFIGURATION MONINTORING SERVICE :GROUPE7] Termined"
