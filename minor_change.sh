ssh -o "StrictHostKeyChecking no" root@10.0.0.12 'terraform destroy -auto-approve'
ssh -o "StrictHostKeyChecking no" root@10.0.0.12 'rm * ~'
ssh -o "StrictHostKeyChecking no" root@10.0.0.12 'rm -rf ~/scripts'
scp $HOME/Desktop/AutoStackDeploy/recursos_tf/* root@terraform:~
ssh -o "StrictHostKeyChecking no" root@10.0.0.12 'terraform init'
ssh -o "StrictHostKeyChecking no" root@10.0.0.12 'terraform apply -auto-approve'
