#!/bin/bash 
mypubip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4); 
IFS=$'\n' read -d '' -r -a myarray < /tmp/test.txt; 
for i in ${!myarray[@]}; 
do 
  if [[ ${myarray[$i]} == $mypubip ]]; 
  then
    if [[ ${myarray[$i]} == ${myarray[@]:(-1)} ]];
    then 
      ping -c 1 ${myarray[0]} >> /tmp/ping
    else
      ping -c 1 ${myarray[$i+1]} >> /tmp/ping
    fi;    
  fi; 
done