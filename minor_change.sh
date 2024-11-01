ssh -o "StrictHostKeyChecking no" root@10.0.0.12 'terraform destroy -auto-approve'
ssh -o "StrictHostKeyChecking no" root@10.0.0.12 'rm *.tf ~'
scp $HOME/Desktop/AutoStackDeploy/recursos_tf/* root@10.0.0.12:~
ssh -o "StrictHostKeyChecking no" root@10.0.0.12 'terraform init'
ssh -o "StrictHostKeyChecking no" root@10.0.0.12 'terraform apply -auto-approve'
