#!/bin/bash

node_nagios=('Michotte.cfg' 'Carnoy.cfg' 'SH1C.cfg' 'Halles.cfg' 'Pythagore.cfg' 'Stevin.cfg' 'MONIT.cfg' 'ADNS01.cfg' 'ADNS02.cfg' 'RDNS01.cfg' 'RDNS02.cfg')
value=('je suis tres fotrt' 'value2' 'value3')
new_value=('ca donne tres bien' 'new_value2' 'new_value3')

for i in  ${node_nagios[*]}
        do
                echo "[INFO] create configuration file $i ..."
                sudo cp ~/lingi2142/gr7_cfg/MONIT/nagios3/conf.d/"$i" ~/lingi2142//monintoring/
        done
