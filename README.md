# Vault in Kubernetes

This repo provides a demo non prodcution app that works with HashiCoprs Vault 

### Install
Deploy this follow these steps

Edit the Variables to suit your envrioment and account detail

1. clone this repo
2. Run Terrafom init
3. Run Terraform apply 

Once the apply is compelete connect to your Kubenetes envrioment via your cloud shell and verify the pods are up using kubectl get pods

Now

1. clone this repo into your shell https://github.com/dawright22/app_stack.git
2. change into this repo and run ./full_stack_deploy.sh

### What you get!
A standalone vault instance that can be either OSS (default) or Enterprise to demonstrate dynamic user credentials and trasit data encryption as a service 

### Vault
You can connect to the Vault UI and see the secrets engines enabled using http://<EXTERNAL_IP:8200>

You will need to login in using the ROOT TOKEN from the init.json file located in app_stack/vault/init.json to authenticate

it should look like this:

![](/images/vault.png)

### Transit-app

Execute kubectl get svc transit-app to see the ip address to connect too

You can connect to the app UI and add or change record using http://<EXTERNAL_IP:5000>

![](/images/tranist-app.png)


### Clean up
in the app_stack repo run the ./cleanup.sh
