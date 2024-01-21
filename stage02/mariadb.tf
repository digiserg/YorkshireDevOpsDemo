locals {
  mariadb_hosts = {
    mariadb = {
      name          = "mariadb"
      host          = "mariadb.mariadb.svc.cluster.local"
      port          = 3306
      db            = "mysql"
      allowed_roles = ["writer", "admin", "readonly"]
      admin_user    = "root"
      admin_pass    = "RONA7Q63t5qBrxk84WT1KZno1Py09Z2pfKvvSAsd"
    }
  }
}

module "mariadb_secrets" {
  source     = "./mariadb"
  mariadb_hosts = local.mariadb_hosts
}

data "vault_policy_document" "mariadb-all-roles" {
  dynamic "rule" {
    for_each = toset(keys(local.mariadb_hosts))
    content {
      path         = "${rule.value}/creds/*"
      capabilities = ["read"]
      description  = "DB credentials"
    }
  }
}

resource "vault_policy" "mariadb-all-roles" {
  name   = "mariadb-all-roles"
  policy = data.vault_policy_document.mariadb-all-roles.hcl
}