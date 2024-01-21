locals {
  vals_helm_version = "0.7.8"
  vals_image_tag    = "v0.7.9-beta1"
}

resource "helm_release" "vals-operator" {
  name  = "vals-operator"
  chart = "https://digitalis-io.github.io/helm-charts/charts/vals-operator-${local.vals_helm_version}.tgz"

  create_namespace = false
  namespace        = "vault"
  wait             = true
  wait_for_jobs    = true

  set {
    name  = "image.tag"
    value = local.vals_image_tag
  }
  set {
    name  = "fullNameOverride"
    value = "vals-operator"
  }
  set {
    name  = "prometheusRules.enabled"
    value = false
  }
  set {
    name  = "podMonitor.enabled"
    value = false
  }
  set {
    name  = "env[0].name"
    value = "VAULT_ADDR"
  }
  set {
    name  = "env[0].value"
    value = "http://vault.vault.svc.cluster.local:8200"
  }
  set {
    name  = "env[1].name"
    value = "VAULT_TOKEN"
  }
  set {
    name  = "env[1].value"
    value = var.vault_token
  }
  set {
    name  = "env[2].name"
    value = "VAULT_SKIP_VERIFY"
  }
  set {
    name  = "env[2].value"
    value = "true"
    type  = "string"
  }
  set {
    name  = "args[0]"
    value = "-zap-log-level=info"
    type  = "string"
  }
  set {
    name  = "args[1]"
    value = "-zap-stacktrace-level=error"
    type  = "string"
  }
  set {
    name  = "args[2]"
    value = "-record-changes"
    type  = "string"
  }
  set {
    name  = "args[3]"
    value = "-reconcile-period=30s"
    type  = "string"
  }
}
