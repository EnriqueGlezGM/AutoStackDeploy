#!/bin/bash

# Ejecuta el script para obtener el tutorial de OpenStack
/lab/cnvr/bin/get-openstack-tutorial.sh
cd /mnt/tmp/openstack_lab-antelope_4n_classic_ovs-v04

# Crea y configura el entorno de VNX
sudo vnx -f openstack_lab.xml --create
sudo vnx -f openstack_lab.xml -x start-all,load-img
sudo vnx_config_nat ExtNet "$(ip route | grep default | cut -d' ' -f 5)"
sudo vnx -f openstack_lab-terraform.xml --create
sudo vnx -f openstack_lab-terraform.xml -x install-terraform

# Generar clave SSH sin contraseña para agilizar el ssh
ssh-keygen -t rsa -b 4096 -f "$HOME/.ssh/id_rsa" -N "" -y

# Usar expect para automatizar ssh-copy-id
/usr/bin/expect <<EOF
set timeout -1
spawn ssh-copy-id -i $HOME/.ssh/id_rsa.pub root@terraform
expect "password:"
send "xxxx\r"
expect eof
EOF

# Verificar acceso SSH y ejecutar comando en el servidor remoto
ssh -o "StrictHostKeyChecking no" root@terraform 'terraform --version'
