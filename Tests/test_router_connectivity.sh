#!/bin/bash

WORKKING_DIR=/home/vagrant/lingi2142
CONNECT_TO=sudo ./connect.sh gr7_cfg
belnetb=fd00:200:::b
belneta=fd00:300::b

cd $WORKKING_DIR

echo "Connect to Halles"
sudo ./connect.sh gr7_cfg Halles
echo Ping $belnetb
if ping6 -q -c 1 -W 1 fd00:200::b >/dev/null; then
  echo $belnetb is up
else
  echo $belnetb is down
fi

echo Ping $belneta
if ping6 -q -c 1 -W 1 fd00:300::b >/dev/null; then
  echo $belneta is up
else
  echo $belneta is down
fi

exit

echo "Connect to Pythagore"
sudo ./connect.sh gr7_cfg Pythagore
echo Ping $belnetb
if ping6 -q -c 1 -W 1 fd00:200::b >/dev/null; then
  echo $belnetb is up
else
  echo $belnetb is down
fi

echo Ping $belneta
if ping6 -q -c 1 -W 1 fd00:300::b >/dev/null; then
  echo $belneta is up
else
  echo $belneta is down
fi

exit

echo "Connect to SH1C"
sudo ./connect.sh gr7_cfg SH1C
echo Ping $belnetb
if ping6 -q -c 1 -W 1 fd00:200::b >/dev/null; then
  echo $belnetb is up
else
  echo $belnetb is down
fi

echo Ping $belneta
if ping6 -q -c 1 -W 1 fd00:300::b >/dev/null; then
  echo $belneta is up
else
  echo $belneta is down
fi

exit

echo "Connect to Carnoy"
sudo ./connect.sh gr7_cfg Carnoy
echo Ping $belnetb
if ping6 -q -c 1 -W 1 fd00:200::b >/dev/null; then
  echo $belnetb is up
else
  echo $belnetb is down
fi

echo Ping $belneta
if ping6 -q -c 1 -W 1 fd00:300::b >/dev/null; then
  echo $belneta is up
else
  echo $belneta is down
fi

exit

echo "Connect to Michotte"
sudo ./connect.sh gr7_cfg Michotte
echo Ping $belnetb
if ping6 -q -c 1 -W 1 fd00:200::b >/dev/null; then
  echo $belnetb is up
else
  echo $belnetb is down
fi

echo Ping $belneta
if ping6 -q -c 1 -W 1 fd00:300::b >/dev/null; then
  echo $belneta is up
else
  echo $belneta is down
fi

exit

echo "Connect to Stevin"
sudo ./connect.sh gr7_cfg Stevin
echo Ping $belnetb
if ping6 -q -c 1 -W 1 fd00:200::b >/dev/null; then
  echo $belnetb is up
else
  echo $belnetb is down
fi

echo Ping $belneta
if ping6 -q -c 1 -W 1 fd00:300::b >/dev/null; then
  echo $belneta is up
else
  echo $belneta is down
fi

exit
