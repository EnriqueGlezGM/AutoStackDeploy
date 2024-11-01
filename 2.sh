#!/bin/bash
# root@10.0.0.12 debido al cambio en hosts que impide usar root@terraform
ssh -o "StrictHostKeyChecking no" root@10.0.0.12 'ssh-keygen -t rsa -b 2048 -f ~/.ssh/my_new_key -N ""'

scp $HOME/Desktop/AutoStackDeploy/recursos_tf/* root@10.0.0.12:~
ls /mnt/tmp/openstack_lab-antelope_4n_classic_ovs-v04/shared
ssh -o "StrictHostKeyChecking no" root@10.0.0.12 'terraform init'
ssh -o "StrictHostKeyChecking no" root@10.0.0.12 'terraform plan'
ssh -o "StrictHostKeyChecking no" root@10.0.0.12 'terraform apply -auto-approve'
open "http://10.0.10.11/"
