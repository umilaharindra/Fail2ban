#!/bin/bash
#title           :ipaddrunlock.sh
#description     :This script will remove banned ip address from fail2ban jails.
#author		       :Umila Harindra
#date            :2020-05-09
#version         :0.1    
#usage		       :bash ipaddrunlock.sh
#notes           :Install Fail2ban and configure to use this script. Some fail2ban versions may not competible.
#bash_version    :4.1.5(1)-release

#+------------------------------------------------------------------------------------------------------------------+

echo "$(tput setaf 2)
                      .---.     .-**-.
                  .--.l   l   .* .-.  )   /l                     _..._
     _.._         l__ll   l  / .*  / /    ll                   .*     *.
   .* .._l        .--.l   l (_/   / /     ll                  .   .-.   .
   l *       __   l  ll   l      / /      ll  __        __    l  *   *  l
 __l l__  .:--.*. l  ll   l     / /       ll/*__ *.  .:--.*.  l  l   l  l
l__   __l/ l   % ll  ll   l    . *        l:/*  *. */ l   % l l  l   l  l
   l l   ** __ l ll  ll   l   / /    _.-*)ll     l l** __ l l l  l   l  l
   l l    .*.**l ll__ll   l .* *  _.*.-** ll%    / * .*.**l l l  l   l  l
   l l   / /   l l_   *---*/  /.-*_.*     l/%*..* / / /   l l_l  l   l  l
   l l   % %._,% */       /    _.*        *  **-**  % %._,% */l  l   l  l
   l_l    *--*  **       ( _.-*                      *--*  ** *--*   *--*

$(tput sgr0)"

cat << "EOF"
  _                   _     _                                 _     _            _
 (_)_ __     __ _  __| | __| |_ __ ___  ___ ___   _   _ _ __ | |__ | | ___   ___| | _____ _ __
 | | '_ \   / _` |/ _` |/ _` | '__/ _ \/ __/ __| | | | | '_ \| '_ \| |/ _ \ / __| |/ / _ \ '__|
 | | |_) | | (_| | (_| | (_| | | |  __/\__ \__ \ | |_| | | | | |_) | | (_) | (__|   <  __/ |
 |_| .__/   \__,_|\__,_|\__,_|_|  \___||___/___/  \__,_|_| |_|_.__/|_|\___/ \___|_|\_\___|_|
   |_|

EOF

echo "$(tput setaf 2)
`uname -srmo`$(tput setaf 1)
`date +"%A, %e %B %Y, %r"`
$(tput sgr0)"

printf "\n"
txtred=$(tput setaf 1)
echo "Enter ${txtred}'exit' `tput sgr0`for exit from the program "        # print standard user inputs to perform
echo "Enter ${txtred}'view' `tput sgr0`for view all jail status "         # print standard user inputs to perform 
printf "\n"

while :

do

printf "\n"

read -p "Enter ip address: " ip                                           # read input and set to variable


if [ $ip == "exit" ]													  # conditional check to exit
        then
               printf "\n"
                break
fi

if [ $ip == "view" ]                                                      # conditional check to view 
        then
         sudo /bin/fail2ban-client status  zimbra-account
	     printf "\n"
	     sudo /bin/fail2ban-client status  zimbra-audit
	     printf "\n"
	     sudo /bin/fail2ban-client status  zimbra-recipient
	     printf "\n"      

elif 

expr "$ip" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' >/dev/null;              # conditional check to valid ip adderss input
	
	then

	sudo /bin/fail2ban-client set  zimbra-account  unbanip $ip 1&> .ip.txt                  # mv stdout to hidden file
	
	i=$(cat .ip.txt)
	if [ $i -eq 1 ];
		then	
		echo "$ip successfully unblocked from zimbra-account jail" && echo "$ip successfully unblocked from zimbra-account at $(date) " >> unblocked.log      # update log file 
		else
		echo "$ip not banned in zimbra-account jail"
	fi

	sudo /bin/fail2ban-client set  zimbra-recipient  unbanip $ip 1&> .ip.txt                # mv stdout to hidden file
	
	i=$(cat .ip.txt)
	if [ $i -eq 1 ];
		then
		echo "$ip successfully unblocked from zimbra-recipient jail " && echo "$ip successfully unblocked from zimbra-recipient at $(date) " >> unblocked.log    # update log file
		else
		echo "$ip not banned in zimbra-recipient jail"
	fi

	sudo /bin/fail2ban-client set  zimbra-audit  unbanip $ip 1&> .ip.txt                    # mv stdout to hidden file

	i=$(cat .ip.txt)
	if [ $i -eq 1 ];
		then
		echo "$ip successfully unblocked from zimbra-audit jail" && echo "$ip successfully unblocked from zimbra-audit at $(date) " >> unblocked.log             # update log file
		else
		echo "$ip not banned in zimbra-audit jail"
	fi

#	sudo /bin/fail2ban-client set  sshd  unbanip $ip 1&> .ip.txt

#	i=$(cat .ip.txt)
#	if [ $i -eq 1 ];
#		then
#		echo "$ip successfully unblocked from sshd jail" && echo "$ip successfully unblocked from sshd at $(date) " >> unblocked.log 
#		else
#		echo "$ip not banned in sshd jail"
#	fi

	if [ $ip == "view" ];
	        then
		ip == "e"
	fi


	
else
		printf "\n"
		echo "*******************************"
		echo "Please provide valid ip address"                                            # error message for invalid ip address
		echo "*******************************"
		printf "\n"

fi

done
