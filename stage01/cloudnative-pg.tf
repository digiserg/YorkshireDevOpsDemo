resource "helm_release" "cnpg" {
  name       = "cloudnative-pg"
  repository = "https://cloudnative-pg.github.io/charts"
  chart      = "cloudnative-pg"
  version    = "0.19.0"

  create_namespace = true
  namespace        = "cloudnative-pg"
  wait             = true
  wait_for_jobs    = true
}

resource "kubectl_manifest" "psql" {
  yaml_body = <<END
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: demo
  namespace: cloudnative-pg
spec:
  instances: 3
  enableSuperuserAccess: true

  # Example of rolling update strategy:
  # - unsupervised: automated update of the primary once all
  #                 replicas have been upgraded (default)
  # - supervised: requires manual supervision to perform
  #               the switchover of the primary
  primaryUpdateStrategy: unsupervised

  # Require 1Gi of space
  storage:
    size: 1Gi
END
  depends_on = [ helm_release.cnpg ]
}