resource "kubernetes_namespace" "vault" {
  metadata {
    annotations = {
      name                = "vault"
      "linkerd.io/inject" = "disabled"
    }

    labels = {
      managed_by     = "terraform"
      terraform_repo = "eks"
    }

    name = "vault"
  }
  lifecycle {
    ignore_changes = [
      metadata,
    ]
  }
}

resource "kubernetes_service_account" "vault" {
  metadata {
    name      = "vault"
    namespace = "vault"
  }
  automount_service_account_token = "true"
  depends_on = [
    kubernetes_namespace.vault,
  ]
}

resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com/"
  chart      = "vault"
  version    = "0.25.0"

  create_namespace = false
  namespace        = "vault"
  wait             = true
  wait_for_jobs    = true

  set {
    name  = "server.serviceAccount.create"
    value = "false"
  }

  set {
    name  = "server.serviceAccount.name"
    value = kubernetes_service_account.vault.metadata[0].name
  }

  set {
    name  = "server.image.tag"
    value = "1.14.3"
  }

  depends_on = [
    kubernetes_namespace.vault,
    kubernetes_service_account.vault,
  ]
}
