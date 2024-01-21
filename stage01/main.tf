terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.12.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "3.2.0"
    }
  }
}

provider "cloudflare" {
  # Configuration options
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
