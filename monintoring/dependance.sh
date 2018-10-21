#!/bin/sh

file=('/etc/nagios/nrpe.cfg' 'fichier2.txt' 'fichier3.txt')
value=('allowed_hosts=127.0.0.1' 'value2' 'value3')
new_value=('allowed_hosts=10.10.10.105' 'new_value2' 'new_value3')

echo "[INFO] ."
sudo apt-get install libtimedate-perl libdatetime-perl libdatetime-format-duration-perl libnet-ip-perl libswitch-perl libtemplate-perl

echo "[INFO] installation nagios and all its plugins "
sudo apt-get install nagios3 nagios-plugins nagios-nrpe-plugin nagios-plugins-contrib nagios-plugins-rabbitmq nagios-plugins-standard

echo "[INFO] installation of the Nagios Remote Plugin Executor (NRPE) plug-in to monitor service and remote Linux / Unix network device"
sudo apt-get install nagios-nrpe-server

#[INFO] backup of configuration files
for i in  ${file[*]}
	do
		echo "[INFO] backup of configuration file $i ..."
		sudo cp "$i" "$i.save"
	done

echo "[INFO]Creating new router host configuration files"


function change_configuration
{

	for file in  "$1"
		do
			echo "file processing  $1 ..."
			sudo  sed -i -e "s/$2/$3/g" "$1"
		done
}

j=0
for i in  ${file[*]}
	do
		change_configuration  ${file[$j]} ${value[$j]} ${new_value[$j]}
		((j++))
	done


echo "[INFO] Restarting the nagios service"
sudo /etc/init.d/nagios3 restart
