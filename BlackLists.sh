#!/bin/bash

#Copyright 2012 David Trigo Chavez
#This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.

#Fichero de las lisitas negras
FICHERO="blacklist.txt"

#Fichero temporal para guardar las ocurrencias
TEMP_FILE=$(tempfile)

#Creamos el fichero para que no de errores
touch $TEMP_FILE

#Mirar lista de IP's que envian spam
#http://www.senderbase.org/home/detail_spam_source

echo "Introduce la IP del servidor: "
read IP

#IP="83.55.107.54"


#Funcion para comprobar la ip en la lista
function revisar(){
    result=`dig +short $IP_INVERSA.$SERVER`
    if [ "$result" != "" ]; then
        echo "$IP listed in $SERVER" >> $TEMP_FILE
        #echo "1" >> $TEMP_FILE
    fi
}

#Invertimos la IP
IP_INVERSA=$(echo "$(echo $IP|cut -d . -f 4).$(echo $IP|cut -d . -f 3).$(echo $IP|cut -d . -f 2).$(echo $IP|cut -d . -f 1)")

#Comprobamos la IP en todos los servidores
for SERVER in $(cat $FICHERO); do
    revisar &
done

#Esperamos las comprobaciones
wait $revisar


#Contamos todas las veces que esta el servidor en listas negras
let NUM2=$(wc -l $TEMP_FILE | cut -d " " -f 1)

echo "Numero de listas negras $NUM2"

cat $TEMP_FILE

#Borramos el fichero temporal
rm $TEMP_FILE
