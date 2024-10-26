#!/bin/bash
#source /mnt/tmp/openstack_lab-antelope_4n_classic_ovs-v04/bin/admin-openrc.sh
#for i in $(seq 1 6); do
#  echo S$i
#  openstack keypair create s$i
#done
#echo BBDD
#openstack keypair create bbdd
#echo ADMIN
#openstack keypair create admin
scp $HOME/Desktop/AutoStackDeploy/recursos_tf/* root@terraform:~
ls /mnt/tmp/openstack_lab-antelope_4n_classic_ovs-v04/shared
ssh -o "StrictHostKeyChecking no" root@terraform 'terraform init'
ssh -o "StrictHostKeyChecking no" root@terraform 'terraform plan'
ssh -o "StrictHostKeyChecking no" root@terraform 'terraform apply -auto-approve'
open "http://10.0.10.11/"
