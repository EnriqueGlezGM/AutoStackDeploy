ssh -o "StrictHostKeyChecking no" root@10.0.0.12 'terraform destroy -auto-approve'
ssh -o "StrictHostKeyChecking no" root@10.0.0.12 'rm topology.tf'
scp $HOME/Desktop/AutoStackDeploy/recursos_tf/topology.tf root@terraform:~
ssh -o "StrictHostKeyChecking no" root@10.0.0.12 'terraform apply -auto-approve'
