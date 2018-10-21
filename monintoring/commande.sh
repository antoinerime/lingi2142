#!/bin/bash

file=('fichier.txt' 'fichier2.txt' 'fichier3.txt')
value=('je suis tres fotrt' 'value2' 'value3')
new_value=('ca donne tres bien' 'new_value2' 'new_value3')

for i in  ${file[*]}
do
echo "[INFO] backup of configuration file $i ..."
sudo cp "$i" "$i.save"
done


function ma_fonction
{
echo $1
for file in  "$1"
do
 echo "Traitement de $1 ..."
 sudo  sed -i -e "s/$2/$3/g" "$1"
done
}

j=0
for i in  ${file[*]}
do
echo "$j"
#ma_fonction  ${file[$j]} ${value[$j]} ${new_value[$j]}
((j++))
done
