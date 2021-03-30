#!/bin/bash
###
### Script created by dAtUmErA
###

###
### Color definition
###
red=`tput setaf 1`
green=`tput setaf 2`
blue=`tput setaf 6`
yellow=`tput setaf 3`
orange=`tput setaf 131`
action=`tput setaf 132`
reset=`tput sgr0`

###
### Grant execution only for root user
###
if [[ $EUID -ne 0 ]]; then
        echo "${red}ERROR${reset}: You should use root user to execute the script $0"
        exit 1;
fi

###
### Script should include parameters 
###
if [[ $1 == "" ]]; then
        echo "${red}ERROR${reset}: The script $0 should include config.xml file as argument to obtain the WebLogic Domain configuration"
        exit 1;
fi



###
### Pass as argument the config.xml domain configuration file from weblogic domain and export the servers in an array list
###

declare -a servers=`echo "cat //*[local-name()='domain']/*[local-name()='server']/*[local-name()='name']/text()"| xmllint --shell $1 | grep -v "/ >" | grep -v " -------"`
echo "The following Instances have been detected in the config.xml file"
echo "${servers[@]}"
###
### Definition of the domain name
###
echo "Insert the domain name:"
read domainname
###
### Definition of the domain path
###
echo "Insert the domain path:"
read domainpath
###
### Definition of the binary installation 
###
echo "Insert the binary path installation dir:"
read binarypath
###
### Definition of the nodemanager username
### 
echo "Insert the nodemanager username to managed services:"
read nodeuser
###
### Definition of the nodemanager password
###
echo "Insert the nodemanager password for the selected user:"
read nodepasswd
###
### Definition of the nodemanager hostname 
###
echo "Insert the hostname where the nodemanager is running:"
read nodehost
###
### Definition of the nodemanager port 
###
echo "Insert the port of nodemanager service:"
read nodeport
###
### Definition of the protocol 
###
echo "Insert the nodemanager cypher? (plain or ssl)"
read cypher 

###
### Creation of NodeManager systemd scripts
###
echo "Creating NodeManager service:"
echo "[Unit]" > nodemanager.service
echo "Description=Weblogic Node Manager" >> nodemanager.service
echo "After=network.target sshd.service" >> nodemanager.service
echo "[Service]" >> nodemanager.service 
echo "Type=simple" >> nodemanager.service 
echo "ExecStart=$domainpath/bin/startNodeManager.sh" >> nodemanager.service
echo "ExecStop=$domainpath/bin/stopNodeManager.sh" >> nodemanager.service
echo "User=weblogic" >> nodemanager.service
echo "Group=weblogic" >> nodemanager.service 
echo "KillMode=process" >> nodemanager.service
echo "SuccessExitStatus=143" >> nodemanager.service
echo "PIDFile=$domainpath/nodamanager/nodemanager.process.id" >> nodemanager.service
echo "Restart=on-failure" >> nodemanager.service
echo "RestartSec=1" >> nodemanager.service
echo "[Install]" >> nodemanager.service
echo "WantedBy=multi-user.target" >> nodemanager.service
chmod 754 nodemanager.service
echo "NodeManager configuration has been generated"
                echo "#!/bin/bash" > nodemanager.sh
                echo "###" >> nodemanager.sh
                echo "### This script has been designed to manage the AdminServer WebLogic instance" >> nodemanager.sh
                echo "###" >> nodemanager.sh
                echo "### Color definition" >> nodemanager.sh
                echo "red=\`tput setaf 1\`" >> nodemanager.sh
                echo "green=\`tput setaf 2\`" >> nodemanager.sh
                echo "blue=\`tput setaf 6\`" >> nodemanager.sh
                echo "yellow=\`tput setaf 3\`" >> nodemanager.sh
                echo "orange=\`tput setaf 131\`" >> nodemanager.sh
                echo "action=\`tput setaf 132\`" >> nodemanager.sh
                echo "reset=\`tput sgr0\`" >> nodemanager.sh
                echo "### Grant execution only for weblogic user" >> nodemanager.sh
                echo "if [ \$(whoami) != 'weblogic' ]; then" >> nodemanager.sh
                echo "        echo \"\${red}ERROR\${reset}: Debes utilizar el usuario weblogic para ejecutar el script \$0\"" >> nodemanager.sh
                echo "        exit 1;" >> nodemanager.sh
                echo "fi" >> nodemanager.sh
                echo "### Script should be executed from the /oracle/scripts directory" >> nodemanager.sh
                echo "  if [ \$PWD != /oracle/scripts ]; then" >> nodemanager.sh
                echo "        echo \"\${red}ERROR\${reset}: El script \$0 debe ser lanzado desde el directorio /oracle/scripts\"" >> nodemanager.sh
                echo "        exit 1;" >> nodemanager.sh
                echo "fi" >> nodemanager.sh
                echo "### Script should include parameters" >> nodemanager.sh
                echo "if [[ \$1 == \"\" ]]; then" >> nodemanager.sh
                echo "       echo \"\${red}ERROR\${reset}: El script \$0 debe ir acompañado de start , stop , status o restart\"" >> nodemanager.sh
                echo "        exit 1;" >> nodemanager.sh
                echo "fi" >> nodemanager.sh
                echo "### Define allowed arguments" >> nodemanager.sh
                echo "ALLOWED_ARGS=(start stop status restart)" >> nodemanager.sh
                echo "if [[ \$1 != \${ALLOWED_ARGS[0]} && \$1 != \${ALLOWED_ARGS[1]} && \$1 != \${ALLOWED_ARGS[2]} && \$1 != \${ALLOWED_ARGS[3]} ]]; then" >> nodemanager.sh
                echo "        echo \"\${red}ERROR\${reset}: El script \$0 debe ir acompañado de start , stop , status o restart\"" >> nodemanager.sh
                echo "exit 1;" >> nodemanager.sh
                echo "fi" >> nodemanager.sh
                echo "### Define allowed actions with the script" >> nodemanager.sh
                echo "start(){" >> nodemanager.sh
                echo "  sudo systemctl start nodemanager.service" >> nodemanager.sh
                echo "}" >> nodemanager.sh
                echo "stop(){" >> nodemanager.sh
                echo "  sudo systemctl stop nodemanager.service" >> nodemanager.sh
                echo "}" >> nodemanager.sh
                echo "status(){" >> nodemanager.sh
                echo "  sudo systemctl status nodemanager.service -l" >> nodemanager.sh
                echo "}" >> nodemanager.sh
                echo "case \"\$1\" in" >> nodemanager.sh
                echo "    start)" >> nodemanager.sh
                echo "        start" >> nodemanager.sh
                echo "        ;;" >> nodemanager.sh
                echo "    stop)" >> nodemanager.sh
                echo "        stop" >> nodemanager.sh
                echo "        ;;" >> nodemanager.sh
                echo "    status)" >> nodemanager.sh
                echo "        status" >> nodemanager.sh
                echo "  ;;" >> nodemanager.sh
                echo "    restart)" >> nodemanager.sh
                echo "  stop" >> nodemanager.sh
                echo "  start" >> nodemanager.sh
                echo "        ;;" >> nodemanager.sh
                echo "    *)" >> nodemanager.sh
                echo "        exit 1" >> nodemanager.sh
                echo "        ;;" >> nodemanager.sh
                echo "esac" >> nodemanager.sh
                chmod 754 nodemanager.sh
		echo "### Sudoers line for nodemanager service management: ###"
		echo "weblogic ALL=(ALL) NOPASSWD: /usr/bin/systemctl start nodemanager.service, /usr/bin/systemctl stop nodemanager.service, /usr/bin/systemctl status nodemanager.service -l" 
###
### Creation of WL Instances systemd scripts
###
for i in ${servers[@]}; do

	echo "Detected node:" $i
		echo "Generating start wlst script for managed $i"
        echo "nmConnect('$nodeuser','$nodepasswd',host='$nodehost',port='$nodeport',domainName='$domainname',domainDir='$domainpath',nmType='$cypher')" > start_$i.wlst
		echo "nmStart('$i')" >> start_$i.wlst
		echo "Generating stop wlst script for managed $i"
		echo "nmConnect('$nodeuser','$nodepasswd',host='$nodehost',port='$nodeport',domainName='$domainname',domainDir='$domainpath',nmType='$cypher')" > stop_$i.wlst
		echo "nmKill('$i')" >> stop_$i.wlst 
		echo "Generating status wlst script for managed $i"
		echo "nmConnect('$nodeuser','$nodepasswd',host='$nodehost',port='$nodeport',domainName='$domainname',domainDir='$domainpath',nmType='$cypher')" > status_$i.wlst
		echo "nmServerStatus('$i')" >> status_$i.wlst
		echo "Manageds: $i configuration has been generated" 
		echo "[Unit]" > $i.service
		echo "Description=Weblogic $i Instance" >> $i.service
		echo "After=network.target sshd.service nodemanager.service adminserver.service" >> $i.service 
		echo "[Service]" >> $i.service
		echo "Type=oneshot" >> $i.service
		echo "ExecStart=$binarypath/wlserver/common/bin/wlst.sh \"/oracle/scripts/start_"$i".wlst\"" >> $i.service
		echo "ExecStop=$binarypath/wlserver/common/bin/wlst.sh \"/oracle/scripts/stop_"$i".wlst\"" >> $i.service
		echo "User=weblogic" >> $i.service
		echo "Group=weblogic" >> $i.service
		echo "RemainAfterExit=yes" >> $i.service
		echo "KillMode=process" >> $i.service
		echo "[Install]" >> $i.service
		echo "WantedBy=multi-user.target" >> $i.service
		chmod 754 $i.service
                echo "#!/bin/bash" > $i.sh
                echo "###" >> $i.sh
                echo "### This script has been designed to manage the AdminServer WebLogic instance" >> $i.sh
                echo "###" >> $i.sh
                echo "### Color definition" >> $i.sh
                echo "red=\`tput setaf 1\`" >> $i.sh
                echo "green=\`tput setaf 2\`" >> $i.sh
                echo "blue=\`tput setaf 6\`" >> $i.sh
                echo "yellow=\`tput setaf 3\`" >> $i.sh
                echo "orange=\`tput setaf 131\`" >> $i.sh
                echo "action=\`tput setaf 132\`" >> $i.sh
                echo "reset=\`tput sgr0\`" >> $i.sh
                echo "### Grant execution only for weblogic user" >> $i.sh
                echo "if [ \$(whoami) != 'weblogic' ]; then" >> $i.sh
                echo "        echo \"\${red}ERROR\${reset}: Debes utilizar el usuario weblogic para ejecutar el script \$0\"" >> $i.sh
                echo "        exit 1;" >> $i.sh
                echo "fi" >> $i.sh
                echo "### Script should be executed from the /oracle/scripts directory" >> $i.sh
                echo "  if [ \$PWD != /oracle/scripts ]; then" >> $i.sh
                echo "        echo \"\${red}ERROR\${reset}: El script \$0 debe ser lanzado desde el directorio /oracle/scripts\"" >> $i.sh
                echo "        exit 1;" >> $i.sh
                echo "fi" >> $i.sh
                echo "### Script should include parameters" >> $i.sh
                echo "if [[ \$1 == \"\" ]]; then" >> $i.sh
                echo "       echo \"\${red}ERROR\${reset}: El script \$0 debe ir acompañado de start , stop , status o restart\"" >> $i.sh
                echo "        exit 1;" >> $i.sh
                echo "fi" >> $i.sh
                echo "### Define allowed arguments" >> $i.sh
                echo "ALLOWED_ARGS=(start stop status restart)" >> $i.sh
                echo "if [[ \$1 != \${ALLOWED_ARGS[0]} && \$1 != \${ALLOWED_ARGS[1]} && \$1 != \${ALLOWED_ARGS[2]} && \$1 != \${ALLOWED_ARGS[3]} ]]; then" >> $i.sh
                echo "        echo \"\${red}ERROR\${reset}: El script \$0 debe ir acompañado de start , stop , status o restart\"" >> $i.sh
                echo "exit 1;" >> $i.sh
                echo "fi" >> $i.sh
                echo "### Define allowed actions with the script" >> $i.sh
                echo "start(){" >> $i.sh
                echo "  sudo systemctl start $i.service" >> $i.sh
                echo "}" >> $i.sh
                echo "stop(){" >> $i.sh
                echo "  sudo systemctl stop $i.service" >> $i.sh
                echo "}" >> $i.sh
                echo "status(){" >> $i.sh
                echo "  sudo systemctl status $i.service -l" >> $i.sh
                echo "}" >> $i.sh
                echo "case \"\$1\" in" >> $i.sh
                echo "    start)" >> $i.sh
                echo "        start" >> $i.sh
                echo "        ;;" >> $i.sh
                echo "    stop)" >> $i.sh
                echo "        stop" >> $i.sh
                echo "        ;;" >> $i.sh
                echo "    status)" >> $i.sh
		echo "        status" >> $i.sh
                echo "        ;;" >> $i.sh
                echo "    restart)" >> $i.sh
                echo "        stop" >> $i.sh
                echo "        start" >> $i.sh
                echo "        ;;" >> $i.sh
                echo "    *)" >> $i.sh
                echo "        exit 1" >> $i.sh
                echo "        ;;" >> $i.sh
                echo "esac" >> $i.sh
                chmod 754 $i.sh
                echo "### Sudoers line for $i service management: ###"
                echo "weblogic ALL=(ALL) NOPASSWD: /usr/bin/systemctl start $i.service, /usr/bin/systemctl stop $i.service, /usr/bin/systemctl status $i.service -l" 		


done

read -r -p "Do you want generate management scripts for an embedded OHS service? [Y/n] " embedded

case $embedded in
    		[yY][eE][sS]|[yY])
        	echo "Insert the OHS instance name:"
        	read ohsinstancename
        	###
                echo "[Unit]" > $ohsinstancename.service
                echo "Description=OHS embedded $e component" >> $ohsinstancename.service
                echo "After=network.target sshd.service nodemanager.service" >> $ohsinstancename.service
                echo "[Service]" >> $ohsinstancename.service
                echo "Type=oneshot" >> $ohsinstancename.service
                echo "ExecStart=$binarypath/oracle_common/common/bin/wlst.sh \"/oracle/scripts/start_$ohsinstancename.wlst\""  >> $ohsinstancename.service
                echo "ExecStop=$binarypath/oracle_common/common/bin/wlst.sh \"/oracle/scripts/stop_$ohsinstancename.wlst\""  >> $ohsinstancename.service
                echo "User=weblogic" >> $ohsinstancename.service
                echo "Group=weblogic" >> $ohsinstancename.service
                echo "KillMode=process" >> $ohsinstancename.service
                echo "RemainAfterExit=yes" >> $ohsinstancename.service
                echo "[Install]" >> $ohsinstancename.service
                echo "WantedBy=multi-user.target" >> $ohsinstancename.service
                chmod 754 $ohsinstancename.service
                echo "OHS component configuration has been generated"
                echo "Generating start wlst script for OHS component"
                echo "nmConnect('$nodeuser','$nodepasswd',host='$nodehost',port='$nodeport',domainName='$domainname',domainDir='$domainpath',nmType='$cypher')" > start_$ohsinstancename.wlst
                echo "nmStart(serverName='$ohsinstancename', serverType='OHS')" >> start_$ohsinstancename.wlst
                echo "Generating stop wlst script for OHS component"
                echo "nmConnect('$nodeuser','$nodepasswd',host='$nodehost',port='$nodeport',domainName='$domainname',domainDir='$domainpath',nmType='$cypher')" > stop_$ohsinstancename.wlst
                echo "nmKill(serverName='$ohsinstancename', serverType='OHS')" >> stop_$ohsinstancename.wlst
                echo "Generating status wlst script for OHS component"
                echo "nmConnect('$nodeuser','$nodepasswd',host='$nodehost',port='$nodeport',domainName='$domainname',domainDir='$domainpath',nmType='$cypher')" > status_$ohsinstancename.wlst
                echo "nmServerStatus(serverName='$ohsinstancename', serverType='OHS')" >> status_$ohsinstancename.wlst
                echo "#!/bin/bash" > $ohsinstancename.sh
                echo "###" >> $ohsinstancename.sh
                echo "### This script has been designed to manage the OHS standalone service" >> $ohsinstancename.sh
                echo "###" >> $ohsinstancename.sh
                echo "### Color definition" >> $ohsinstancename.sh
                echo "red=\`tput setaf 1\`" >> $ohsinstancename.sh
                echo "green=\`tput setaf 2\`" >> $ohsinstancename.sh
                echo "blue=\`tput setaf 6\`" >> $ohsinstancename.sh
                echo "yellow=\`tput setaf 3\`" >> $ohsinstancename.sh
                echo "orange=\`tput setaf 131\`" >> $ohsinstancename.sh
                echo "action=\`tput setaf 132\`" >> $ohsinstancename.sh
                echo "reset=\`tput sgr0\`" >> $ohsinstancename.sh
                echo "### Grant execution only for weblogic user" >> $ohsinstancename.sh
                echo "if [ \$(whoami) != 'weblogic' ]; then" >> $ohsinstancename.sh
                echo "        echo \"\${red}ERROR\${reset}: Debes utilizar el usuario weblogic para ejecutar el script \$0\"" >> $ohsinstancename.sh
                echo "        exit 1;" >> $ohsinstancename.sh
                echo "fi" >> $ohsinstancename.sh
                echo "### Script should be executed from the /oracle/scripts directory" >> $ohsinstancename.sh
                echo "  if [ \$PWD != /oracle/scripts ]; then" >> $ohsinstancename.sh
                echo "        echo \"\${red}ERROR\${reset}: El script \$0 debe ser lanzado desde el directorio /oracle/scripts\"" >> $ohsinstancename.sh
                echo "        exit 1;" >> $ohsinstancename.sh
                echo "fi" >> $ohsinstancename.sh
                echo "### Script should include parameters" >> $ohsinstancename.sh
                echo "if [[ \$1 == \"\" ]]; then" >> $ohsinstancename.sh
                echo "       echo \"\${red}ERROR\${reset}: El script \$0 debe ir acompañado de start , stop , status o restart\"" >> $ohsinstancename.sh
                echo "        exit 1;" >> $ohsinstancename.sh
                echo "fi" >> $ohsinstancename.sh
                echo "### Define allowed arguments" >> $ohsinstancename.sh
                echo "ALLOWED_ARGS=(start stop status restart)" >> $ohsinstancename.sh
                echo "if [[ \$1 != \${ALLOWED_ARGS[0]} && \$1 != \${ALLOWED_ARGS[1]} && \$1 != \${ALLOWED_ARGS[2]} && \$1 != \${ALLOWED_ARGS[3]} ]]; then" >> $ohsinstancename.sh
                echo "        echo \"\${red}ERROR\${reset}: El script \$0 debe ir acompañado de start , stop , status o restart\"" >> $ohsinstancename.sh
                echo "exit 1;" >> $ohsinstancename.sh
                echo "fi" >> $ohsinstancename.sh
                echo "### Define allowed actions with the script" >> $ohsinstancename.sh
                echo "start(){" >> $ohsinstancename.sh
                echo "  sudo systemctl start $ohsinstancename.service" >> $ohsinstancename.sh
                echo "}" >> $ohsinstancename.sh
                echo "stop(){" >> $ohsinstancename.sh
                echo "  sudo systemctl stop $ohsinstancename.service" >> $ohsinstancename.sh
                echo "}" >> $ohsinstancename.sh
                echo "status(){" >> $ohsinstancename.sh
                echo "  sudo systemctl status $ohsinstancename.service -l" >> $ohsinstancename.sh
                echo "}" >> $ohsinstancename.sh
                echo "case \"\$1\" in" >> $ohsinstancename.sh
                echo "    start)" >> $ohsinstancename.sh
                echo "        start" >> $ohsinstancename.sh
                echo "        ;;" >> $ohsinstancename.sh
                echo "    stop)" >> $ohsinstancename.sh
                echo "        stop" >> $ohsinstancename.sh
                echo "        ;;" >> $ohsinstancename.sh
                echo "    status)" >> $ohsinstancename.sh
                echo "        status" >> $ohsinstancename.sh
                echo "        ;;" >> $ohsinstancename.sh
                echo "    restart)" >> $ohsinstancename.sh
                echo "        stop" >> $ohsinstancename.sh
                echo "        start" >> $ohsinstancename.sh
                echo "        ;;" >> $ohsinstancename.sh
                echo "    *)" >> $ohsinstancename.sh
                echo "        exit 1" >> $ohsinstancename.sh
                echo "        ;;" >> $ohsinstancename.sh
                echo "esac" >> $ohsinstancename.sh
                chmod 754 $ohsinstancename.sh
                echo "### Sudoers line for $ohsinstancename service management: ###"
                echo "weblogic ALL=(ALL) NOPASSWD: /usr/bin/systemctl start $ohsinstancename.service, /usr/bin/systemctl stop $ohsinstancename.service, /usr/bin/systemctl status $ohsinstancename.service -l"            
		;;



	    	[nN][oO]|[nN])
		 echo "No"
	       ;;

    *)
 echo "Invalid input..."
 ;;

esac

read -r -p "Do you want generate management scripts for a standalone OHS service? [Y/n] " standalone
 
case $standalone in
    [yY][eE][sS]|[yY])
	echo "Insert the domain name:"
	read ohsdomainname
	###
	### Definition of the OHS domain path
	###
	echo "Insert the domain path:"
	read ohsdomainpath
	###
	### Definition of the OHS binary installation 
	###
	echo "Insert the binary path installation dir:"
	read ohsbinarypath
	###
	### Definition of the OHS nodemanager username
	### 
	echo "Insert the nodemanager username to managed services:"
	read ohsnodeuser
	###
	### Definition of the OHS nodemanager password
	###
	echo "Insert the nodemanager password for the selected user:"
	read ohsnodepasswd
	###
	### Definition of the OHS nodemanager hostname 
	###
	echo "Insert the hostname where the nodemanager is running:"
	read ohsnodehost
        ###
        ### Definition of the nodemanager port 
        ###
        echo "Insert the port of nodemanager service:"
        read ohsnodeport
	###
	### Definition of the OHS cypher
	###
	echo "Insert the OHS nodemanager cypher? (plain or ssl)"
	read ohscypher

	echo "Creating OHS NodeManager service:"
	echo "[Unit]" > ohsnodemanager.service
	echo "Description=OHS Node Manager" >> ohsnodemanager.service
	echo "After=network.target sshd.service" >> ohsnodemanager.service
	echo "[Service]" >> ohsnodemanager.service
	echo "Type=simple" >> ohsnodemanager.service
	echo "ExecStart=$ohsdomainpath/bin/startNodeManager.sh" >> ohsnodemanager.service
	echo "ExecStop=$ohsdomainpath/bin/stopNodeManager.sh" >> ohsnodemanager.service
	echo "User=weblogic" >> ohsnodemanager.service
	echo "Group=weblogic" >> ohsnodemanager.service
	echo "KillMode=process" >> ohsnodemanager.service
	echo "SuccessExitStatus=143" >> ohsnodemanager.service
	echo "PIDFile=$ohsdomainpath/nodamanager/nodemanager.process.id" >> ohsnodemanager.service
	echo "Restart=on-failure" >> ohsnodemanager.service
	echo "RestartSec=1" >> ohsnodemanager.service
	echo "[Install]" >> ohsnodemanager.service
	echo "WantedBy=multi-user.target" >> ohsnodemanager.service
	chmod 754 ohsnodemanager.service
	echo "OHS NodeManager configuration has been generated"
                echo "#!/bin/bash" > ohsnodemanager.sh
                echo "###" >> ohsnodemanager.sh
                echo "### This script has been designed to manage the AdminServer WebLogic instance" >> ohsnodemanager.sh
                echo "###" >> ohsnodemanager.sh
                echo "### Color definition" >> ohsnodemanager.sh
                echo "red=\`tput setaf 1\`" >> ohsnodemanager.sh
                echo "green=\`tput setaf 2\`" >> ohsnodemanager.sh
                echo "blue=\`tput setaf 6\`" >> ohsnodemanager.sh
                echo "yellow=\`tput setaf 3\`" >> ohsnodemanager.sh
                echo "orange=\`tput setaf 131\`" >> ohsnodemanager.sh
                echo "action=\`tput setaf 132\`" >> ohsnodemanager.sh
                echo "reset=\`tput sgr0\`" >> ohsnodemanager.sh
                echo "### Grant execution only for weblogic user" >> ohsnodemanager.sh
                echo "if [ \$(whoami) != 'weblogic' ]; then" >> ohsnodemanager.sh
                echo "        echo \"\${red}ERROR\${reset}: Debes utilizar el usuario weblogic para ejecutar el script \$0\"" >> ohsnodemanager.sh
                echo "        exit 1;" >> ohsnodemanager.sh
                echo "fi" >> ohsnodemanager.sh
                echo "### Script should be executed from the /oracle/scripts directory" >> ohsnodemanager.sh
                echo "  if [ \$PWD != /oracle/scripts ]; then" >> ohsnodemanager.sh
                echo "        echo \"\${red}ERROR\${reset}: El script \$0 debe ser lanzado desde el directorio /oracle/scripts\"" >> ohsnodemanager.sh
                echo "        exit 1;" >> ohsnodemanager.sh
                echo "fi" >> ohsnodemanager.sh
                echo "### Script should include parameters" >> ohsnodemanager.sh
                echo "if [[ \$1 == \"\" ]]; then" >> ohsnodemanager.sh
                echo "       echo \"\${red}ERROR\${reset}: El script \$0 debe ir acompañado de start , stop , status o restart\"" >> ohsnodemanager.sh
                echo "        exit 1;" >> ohsnodemanager.sh
                echo "fi" >> ohsnodemanager.sh
                echo "### Define allowed arguments" >> ohsnodemanager.sh
                echo "ALLOWED_ARGS=(start stop status restart)" >> ohsnodemanager.sh
                echo "if [[ \$1 != \${ALLOWED_ARGS[0]} && \$1 != \${ALLOWED_ARGS[1]} && \$1 != \${ALLOWED_ARGS[2]} && \$1 != \${ALLOWED_ARGS[3]} ]]; then" >> ohsnodemanager.sh
                echo "        echo \"\${red}ERROR\${reset}: El script \$0 debe ir acompañado de start , stop , status o restart\"" >> ohsnodemanager.sh
                echo "exit 1;" >> ohsnodemanager.sh
                echo "fi" >> ohsnodemanager.sh
                echo "### Define allowed actions with the script" >> ohsnodemanager.sh
                echo "start(){" >> ohsnodemanager.sh
                echo "  sudo systemctl start ohsnodemanager.service" >> ohsnodemanager.sh
                echo "}" >> ohsnodemanager.sh
                echo "stop(){" >> ohsnodemanager.sh
                echo "  sudo systemctl stop ohsnodemanager.service" >> ohsnodemanager.sh
                echo "}" >> ohsnodemanager.sh
                echo "status(){" >> ohsnodemanager.sh
                echo "  sudo systemctl status ohsnodemanager.service -l" >> ohsnodemanager.sh
                echo "}" >> ohsnodemanager.sh
                echo "case \"\$1\" in" >> ohsnodemanager.sh
                echo "    start)" >> ohsnodemanager.sh
                echo "        start" >> ohsnodemanager.sh
                echo "        ;;" >> ohsnodemanager.sh
                echo "    stop)" >> ohsnodemanager.sh
                echo "        stop" >> ohsnodemanager.sh
                echo "        ;;" >> ohsnodemanager.sh
                echo "    status)" >> ohsnodemanager.sh
                echo "        status" >> ohsnodemanager.sh
                echo "  ;;" >> ohsnodemanager.sh
                echo "    restart)" >> ohsnodemanager.sh
                echo "  stop" >> ohsnodemanager.sh
                echo "  start" >> ohsnodemanager.sh
                echo "        ;;" >> ohsnodemanager.sh
                echo "    *)" >> ohsnodemanager.sh
                echo "        exit 1" >> ohsnodemanager.sh
                echo "        ;;" >> ohsnodemanager.sh
                echo "esac" >> ohsnodemanager.sh
                chmod 754 ohsnodemanager.sh
                echo "### Sudoers line for OHS nodemanager service management: ###"
                echo "weblogic ALL=(ALL) NOPASSWD: /usr/bin/systemctl start ohsnodemanager.service, /usr/bin/systemctl stop ohsnodemanager.service, /usr/bin/systemctl status ohsnodemanager.service -l"            


for e in `ls $ohsdomainpath/config/fmwconfig/components/OHS/instances/`; do
                echo "[Unit]" > $e.service
                echo "Description=OHS standalone $e component" >> $e.service
                echo "After=network.target sshd.service ohsnodemanager.service" >> $e.service
                echo "[Service]" >> $e.service
                echo "Type=oneshot" >> $e.service
                echo "ExecStart=$ohsbinarypath/oracle_common/common/bin/wlst.sh \"/oracle/scripts/start_"$e".wlst\""  >> $e.service
                echo "ExecStop=$ohsbinarypath/oracle_common/common/bin/wlst.sh \"/oracle/scripts/stop_"$e".wlst\""  >> $e.service
                echo "User=weblogic" >> $e.service
                echo "Group=weblogic" >> $e.service
                echo "KillMode=process" >> $e.service
                echo "RemainAfterExit=yes" >> $e.service
                echo "[Install]" >> $e.service
                echo "WantedBy=multi-user.target" >> $e.service
                chmod 754 $e.service
                echo "OHS $e component configuration has been generated"
	        echo "Generating start wlst script for OHS $e component"
	        echo "nmConnect('$ohsnodeuser','$ohsnodepasswd',host='$ohsnodehost',port='$ohsnodeport',domainName='$ohsdomainname',domainDir='$ohsdomainpath',nmType='$ohscypher')" > start_$e.wlst
	        echo "nmStart(serverName='$e', serverType='OHS')" >> start_$e.wlst
	        echo "Generating stop wlst script for OHS $e component"
	        echo "nmConnect('$ohsnodeuser','$ohsnodepasswd',host='$ohsnodehost',port='$ohsnodeport',domainName='$ohsdomainname',domainDir='$ohsdomainpath',nmType='$ohscypher')" > stop_$e.wlst
	        echo "nmKill(serverName='$e', serverType='OHS')" >> stop_$e.wlst
        	echo "Generating status wlst script for OHS $e component"
        	echo "nmConnect('$ohsnodeuser','$ohsnodepasswd',host='$ohsnodehost',port='$ohsnodeport',domainName='$ohsdomainname',domainDir='$ohsdomainpath',nmType='$ohscypher')" > status_$e.wlst
	        echo "nmServerStatus(serverName='$e', serverType='OHS')" >> status_$e.wlst
                echo "#!/bin/bash" > $e.sh
                echo "###" >> $e.sh
                echo "### This script has been designed to manage the OHS standalone service" >> $e.sh
                echo "###" >> $e.sh
                echo "### Color definition" >> $e.sh
                echo "red=\`tput setaf 1\`" >> $e.sh
                echo "green=\`tput setaf 2\`" >> $e.sh
                echo "blue=\`tput setaf 6\`" >> $e.sh
                echo "yellow=\`tput setaf 3\`" >> $e.sh
                echo "orange=\`tput setaf 131\`" >> $e.sh
                echo "action=\`tput setaf 132\`" >> $e.sh
                echo "reset=\`tput sgr0\`" >> $e.sh
                echo "### Grant execution only for weblogic user" >> $e.sh
                echo "if [ \$(whoami) != 'weblogic' ]; then" >> $e.sh
                echo "        echo \"\${red}ERROR\${reset}: Debes utilizar el usuario weblogic para ejecutar el script \$0\"" >> $e.sh
                echo "        exit 1;" >> $e.sh
                echo "fi" >> $e.sh
                echo "### Script should be executed from the /oracle/scripts directory" >> $e.sh
                echo "  if [ \$PWD != /oracle/scripts ]; then" >> $e.sh
                echo "        echo \"\${red}ERROR\${reset}: El script \$0 debe ser lanzado desde el directorio /oracle/scripts\"" >> $e.sh
                echo "        exit 1;" >> $e.sh
                echo "fi" >> $e.sh
                echo "### Script should include parameters" >> $e.sh
                echo "if [[ \$1 == \"\" ]]; then" >> $e.sh
                echo "       echo \"\${red}ERROR\${reset}: El script \$0 debe ir acompañado de start , stop , status o restart\"" >> $e.sh
                echo "        exit 1;" >> $e.sh
                echo "fi" >> $e.sh
                echo "### Define allowed arguments" >> $e.sh
                echo "ALLOWED_ARGS=(start stop status restart)" >> $e.sh
                echo "if [[ \$1 != \${ALLOWED_ARGS[0]} && \$1 != \${ALLOWED_ARGS[1]} && \$1 != \${ALLOWED_ARGS[2]} && \$1 != \${ALLOWED_ARGS[3]} ]]; then" >> $e.sh
                echo "        echo \"\${red}ERROR\${reset}: El script \$0 debe ir acompañado de start , stop , status o restart\"" >> $e.sh
                echo "exit 1;" >> $e.sh
                echo "fi" >> $e.sh
                echo "### Define allowed actions with the script" >> $e.sh
                echo "start(){" >> $e.sh
                echo "  sudo systemctl start $e.service" >> $e.sh
                echo "}" >> $e.sh
                echo "stop(){" >> $e.sh
                echo "  sudo systemctl stop $e.service" >> $e.sh
                echo "}" >> $e.sh
                echo "status(){" >> $e.sh
                echo "  sudo systemctl status $e.service -l" >> $e.sh
                echo "}" >> $e.sh
                echo "case \"\$1\" in" >> $e.sh
                echo "    start)" >> $e.sh
                echo "        start" >> $e.sh
                echo "        ;;" >> $e.sh
                echo "    stop)" >> $e.sh
                echo "        stop" >> $e.sh
                echo "        ;;" >> $e.sh
                echo "    status)" >> $e.sh
                echo "        status" >> $e.sh
                echo "        ;;" >> $e.sh
                echo "    restart)" >> $e.sh
                echo "        stop" >> $e.sh
                echo "        start" >> $e.sh
                echo "        ;;" >> $e.sh
                echo "    *)" >> $e.sh
                echo "        exit 1" >> $e.sh
                echo "        ;;" >> $e.sh
                echo "esac" >> $e.sh
                chmod 754 $e.sh
                echo "### Sudoers line for $e service management: ###"
                echo "weblogic ALL=(ALL) NOPASSWD: /usr/bin/systemctl start $e.service, /usr/bin/systemctl stop $e.service, /usr/bin/systemctl status $e.service -l"          

done
        echo "All webLogic + OHS standalone services have been configured"
exit 0
       ;;
 
    [nN][oO]|[nN])
 echo "No"
	echo "All webLogic services have been configured"
	exit 0
       ;;
 
    *)
 echo "Invalid input..."
 exit 1
 ;;
esac