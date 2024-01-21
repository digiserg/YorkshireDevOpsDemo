terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.19.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10.0"
    }
  }
}

provider "vault" {
  address = "http://localhost:8200" 
}

provider "kubernetes" {
  config_path = "../kubeconfig.yaml"
}

provider "kubectl" {
  config_path = "../kubeconfig.yaml"
}

provider "helm" {
  kubernetes {
    config_path = "../kubeconfig.yaml"
  }
}
