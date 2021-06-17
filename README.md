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

#### Via Terraform Cloud (TFC)
If you are new to TFC, complete this tutorial: https://learn.hashicorp.com/collections/terraform/cloud-get-started

1. Fork this repo
2. Set Up your TFC Account and Organization
3. Create a new Workspace and select the "Version control workflow" 
4. Choose the repo you forked
5. Update Variables
6. Queue and Run the plan
7. Once the apply is complete connect to your Kubenetes envrioment via your cloud shell and verify the pods are up using kubectl get pods </br>

**Retrieve and update the Variables in TFC**

Review variables.tf

Note: If you choose to change the region of deployment and intend to use the Cloud Shell to access the Kubernetes cluster later on, the Cloud Shell is only available in selected regions! https://docs.aws.amazon.com/cloudshell/latest/userguide/faq-list.html#regions-available

Add Environment Variables

Retrieve your keys here: https://console.aws.amazon.com/iam/home?#security_credential
* AWS_ACCESS_KEY_ID 
* AWS_SECRET_ACCESS_KEY 

**Connecting to Cloud K8s Environment**

Navigate to Elastic Kubernetes Services then select your newly created cluster, select the connect button and connect via the Cloud Shell</br>
Note: 
*** If you do not know what is your cluster name, refer to TFC's Workspace Run Log

![](/images/cloud-shell.png)

1. Install kubectl: https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html < Refer to the Linux steps
2. Run `aws eks --region <region> update-kubeconfig --name <cluster_name>` to configure your kubeconfig
3. Run `kubectl get pods` and see that Terraform has used helm to install Vault in the cluster
![](/images/get-pods.png)
2. Clone this repo into your shell `git clone https://github.com/dawright22/app_stack.git`
3. cd into the app_stack directory and run `./full_stack_deploy.sh` </br>
4. Running `kubectl get svc` will show the ip address to connect to for both the demo application and vault UI

### What you get!
A standalone vault instance that can be either OSS (default) or Enterprise to demonstrate dynamic user credentials and trasit data encryption as a service 

### Vault

#### Locally

You can connect to the Vault UI and see the secrets engines enabled using http://<EXTERNAL_IP:8200>

#### Via Terraform Cloud

Steps to retrieve external IP:
1. Run `kubectl get svc` in the AWS Cloud Shell
2. Connect to the Vault UI and see the secrets engines enabled using http://<<EXTERNAL-IP:8200>>

You will need to login in using the ROOT TOKEN from the init.json file located in app_stack/vault/init.json to authenticate

it should look like this:

![](/images/vault.png)

### Transit-app

Execute kubectl get svc transit-app to see the ip address to connect too

You can connect to the app UI and add or change record using http://<EXTERNAL_IP:5000>

![](/images/tranist-app.png)


### Clean up

#### Locally
in the app_stack repo run the ./cleanup.sh

#### Via TFC
1. Using the AWS Cloud Shell, in the app_stack repo run the ./cleanup.sh
2. Using TFC, Settings > Destruction and Deletion > Queue destroy plan
