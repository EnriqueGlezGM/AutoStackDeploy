#!/bin/bash

# Asigna "admin" como valor predeterminado si no se pasa ningún argumento
instance_name=${1:-admin}

# Copia la clave SSH y configura las variables de entorno de OpenStack
scp root@10.0.0.12:~/.ssh/mykey $HOME/Desktop/AutoStackDeploy/
source /mnt/tmp/openstack_lab-antelope_4n_classic_ovs-v04/bin/admin-openrc.sh

# Obtener la IP de admin para conectarse directamente
admin_ip=$(openstack server show admin -c addresses -f value | grep -oP "'net1': \['[0-9.]+', '\K[0-9.]+")
# Condicional para realizar la conexión adecuada
if [ "$instance_name" == "admin" ]; then
    # Conéctate solo a admin
    ssh -t -i mykey root@$admin_ip -p 2022
else
    if [ "$instance_name" == "BBDD" ]; then
    	server_id=$(openstack server show BBDD -c id -f value)
    	port_id=$(openstack port show port-net1-BBDD -c id -f value)
    	openstack server add port $server_id $port_id
    fi
    # Si se proporciona un nombre de instancia, obtener su IP flotante y hacer SSH a admin y luego a la instancia
    floating_ip=$(openstack server show "$instance_name" -c addresses -f value | grep -oP "(?<='net1': \[')[^']+")
    
    # Copiar la clave a admin y hacer SSH desde admin a la instancia especificada
    scp -P 2022 -i mykey mykey root@$admin_ip:~
    ssh -p 2022 -t -i mykey -o "StrictHostKeyChecking no" root@$admin_ip "ssh -i ~/mykey -o 'StrictHostKeyChecking no' root@$floating_ip"
fi

