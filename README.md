# Vault in Kubernetes

This repo provides a demo non prodcution app that works with HashiCorp Vault 

### Installation 
#### Locally
Deploy this follow these steps

Edit the Variables to suit your envrioment and account detail

1. clone this repo
2. Run Terrafom init
3. Run Terraform apply 

Once the apply is compelete connect to your Kubenetes envrioment via your cloud shell and verify the pods are up using kubectl get pods

Now

1. clone this repo into your shell https://github.com/dawright22/app_stack.git
2. change into this repo and run ./full_stack_deploy.sh </br>

#### Via Terraform Cloud (TFC)
If you are new to TFC, complete this tutorial: https://learn.hashicorp.com/collections/terraform/cloud-get-started

1. Fork this repo
2. Set Up your TFC Account and Organization
3. Create a new Workspace and select the "Version control workflow" 
4. Choose the repo you forked
5. Update Variables
6. Queue and Run the plan
7. Once the apply is compelete connect to your Kubenetes envrioment via your cloud shell and verify the pods are up using kubectl get pods </br>

**Retrieve and update the Variables in TFC**
Review variables.tf

Create a Service Principal in Azure: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret

What you will require:</br>
```
{
  "appId": "00000000-0000-0000-0000-000000000000",
  "displayName": "azure-cli-2017-06-05-10-41-15",
  "name": "http://azure-cli-2017-06-05-10-41-15",
  "password": "0000-0000-0000-0000-000000000000",
  "tenant": "00000000-0000-0000-0000-000000000000"
}

Add Terraform Variables 
appId : "<appId>"
password : "<password>"`

Add Environment Variables
ARM_SUBSCRIPTION_ID : "<subscription-id>"
ARM_TENANT_ID : "<tenant>"
ARM_CLIENT_SECRET : "<password>"
ARM_CLIENT_ID : "<appId>"
```

**Connecting to Cloud K8s Environment**

Navigate to Kubernetes services then select your newly created cluster and select the connect button and connect via the Cloud Shell</br>
Note: If you do not know what is your cluster name, refer to TFC's workspace output
![](/images/az-k8s-connect.png)

1. Run `kubectl get pods` and see that Terraform has used helm to install Vault in the cluster
![](/images/get-pods.png)
2. Clone this repo into your shell `git clone https://github.com/dawright22/app_stack.git`
3. cd into the app_stack directory and run `./full_stack_deploy.sh` </br>
4. Running `kubectl get svc` will show the ip address to connect to for both the demo application and vault UI

### What you get!
A standalone vault instance that can be either OSS (default) or Enterprise to demonstrate dynamic user credentials and trasit data encryption as a service 

### Vault

#### Locally
You can connect to the Vault UI and see the secrets engines enabled using http://<EXTERNAL_IP:8200>

You will need to login in using the ROOT TOKEN from the init.json file located in app_stack/vault/init.json to authenticate

#### Via Terraform Cloud

Steps to retrieve external IP:
1. Run `kubectl get svc` in the Azure Cloud Shell
2. Connect to the Vault UI and see the secrets engines enabled using http://<<EXTERNAL-IP:8200>>

it should look like this:

![](/images/vault.png)

### Transit-app

Execute `kubectl get svc transit-app` to see the ip address to connect too

You can connect to the app UI and add or change record using http://<EXTERNAL_IP:5000>

![](/images/tranist-app.png)


### Clean up

#### Locally
in the app_stack repo run the ./cleanup.sh

#### Via TFC
1. Using the Azure Cloud Shell, in the app_stack repo run the ./cleanup.sh
2. Using TFC, Settings > Destruction and Deletion > Queue destroy plan
