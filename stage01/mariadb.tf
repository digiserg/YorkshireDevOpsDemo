resource "helm_release" "mariadb" {
  name       = "mariadb"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mariadb"
  version    = "15.2.0"

  create_namespace = true
  namespace        = "mariadb"
  wait             = true
  wait_for_jobs    = true

  set {
    name = "auth.rootPassword"
    value = "RONA7Q63t5qBrxk84WT1KZno1Py09Z2pfKvvSAsd"
  }
  set {
    name = "primary.persistence.size"
    value = "1Gi"
  }
}