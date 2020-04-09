#!/bin/bash

current_date=`date`
log_path='/home/pi/cuarentena/'
debug=1
zip_code=$1
mail=$2
super=$3

if [ "$#" -ne 3 ]; then
  echo "Illegal number of parameters"
  exit 1
fi

if [ -f $log_path/log.txt ]; then
  touch $log_path/log.txt
fi

slots_open=$(curl -s "https://www.$super.es/alimentacion/api/cart/get-delivery-slots-pc?postal_code=$zip_code&country=011&method=ADDRESS" | jq '.percentages.open')

if [ $debug -eq 1 ]; then
  #slots_open=$(cat $log_path/debug/hipercor.out | jq '.percentages.open')
  echo "ZIP code: $zip_code, mail: $mail, super: $super" >> $log_path/log.txt
  echo "$current_date: Slots at $super ($zip_code): " $slots_open >> $log_path/log.txt
fi

if [ $slots_open -gt 0 ]; then
  echo -e "From: owncloud.rys@gmail.com\nSubject:Hay $slots_open slots abiertos en $super ($zip_code)\n\n\nHaz la compra en $super.es/supermercado " | msmtp -C ~/.msmtprc "$mail"
fi  
