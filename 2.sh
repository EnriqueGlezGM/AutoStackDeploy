#!/bin/bash
# root@10.0.0.12 debido al cambio en hosts que impide usar root@terraform
ssh -o "StrictHostKeyChecking no" root@10.0.0.12 'ssh-keygen -t rsa -b 2048 -f ~/.ssh/mykey -N ""'

scp $HOME/Desktop/AutoStackDeploy/recursos_tf/* root@10.0.0.12:~
ls /mnt/tmp/openstack_lab-antelope_4n_classic_ovs-v04/shared
ssh -o "StrictHostKeyChecking no" root@10.0.0.12 'terraform init'
ssh -o "StrictHostKeyChecking no" root@10.0.0.12 'terraform plan'
ssh -o "StrictHostKeyChecking no" root@10.0.0.12 'terraform apply -auto-approve'
open "http://10.0.10.11/"
echo 'Iniciando...'
sleep 300
echo 'Ahora desconectamos BBDD de net1'
source /mnt/tmp/openstack_lab-antelope_4n_classic_ovs-v04/bin/admin-openrc.sh
server_id=$(openstack server show BBDD -c id -f value)
port_id=$(openstack port show port-net1-BBDD -c id -f value)
openstack server remove port $server_id $port_id
