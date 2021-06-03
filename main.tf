terraform {
  # backend "remote" {
  #   organization = "hashicorp-learn"    
  #   workspaces {
  #     name = "learn-terraform-pipelines-k8s"
  #   }
  # }
required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0.2"
    }
}

required_version = "~> 0.14"
}


provider "aws" {
  region  = var.aws_region
  #version = ">= 2.38.0"
}

# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

resource "random_pet" "name" {
  prefix = "k8s-vault"
  length = 1
}

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.demo.name
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.demo.name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  }
}