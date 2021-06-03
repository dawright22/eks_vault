# terraform {
#   backend "remote" {
#     organization = "hashicorp-vault"

#     workspaces {
#       name = "terraform-vault-demo"
#     }
#   }
#   required_providers {
#     helm = {
#       source  = "hashicorp/helm"
#       version = "~> 2.0.2"
#     }
#   }

#   required_version = "~> 0.14"
# }


resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"

  values = [ "${file("templates/vault.yaml")}"] 

# set {
#     name = "server.image.repository"
#     value = "hashicorp/vault-enterprise"
#   }

# set {
#     name = "server.image.tag"
#     value = "latest"
#   }

  set {
    name = "server.standalone.enabled"
    value = "true"
  }
}
