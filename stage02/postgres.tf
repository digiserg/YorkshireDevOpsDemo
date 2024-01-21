locals {
  psql_hosts = {
    postgres = {
      name          = "postgres"
      host          = "demo-rw.cloudnative-pg.svc.cluster.local"
      port          = 5432
      db            = "postgres"
      allowed_roles = ["writer", "admin", "readonly"]
      admin_user    = data.kubernetes_secret.demo.data.username
      admin_pass    = data.kubernetes_secret.demo.data.password
    }
  }
}

data "kubernetes_secret" "demo" {
  metadata {
    name = "demo-superuser"
    namespace = "cloudnative-pg"
  }
}

module "psql_secrets" {
  source     = "./psql"
  psql_hosts = local.psql_hosts
}

data "vault_policy_document" "psql-all-roles" {
  dynamic "rule" {
    for_each = toset(keys(local.psql_hosts))
    content {
      path         = "${rule.value}/creds/*"
      capabilities = ["read"]
      description  = "DB credentials"
    }
  }
}

resource "vault_policy" "psql-all-roles" {
  name   = "psql-all-roles"
  policy = data.vault_policy_document.psql-all-roles.hcl
}