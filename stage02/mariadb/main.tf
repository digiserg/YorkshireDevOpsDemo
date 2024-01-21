locals {
  mariadb_read_write = [
    "SELECT",
  ]
  // "GRANT ALL ON ALL TABLES IN SCHEMA public TO \"{{name}}\";"
  mariadb_read_write_sql = [for sql in local.mariadb_read_write : "GRANT SELECT ON *.* TO '{{name}}'@'%';"]
  max_ttl             = 45 * 86400
  ttl                 = 30 * 86400
  admin_ttl           = 3600 # admin only for one hour
  cluster_names       = keys(var.mariadb_hosts)
}

resource "vault_mount" "default" {
  for_each = {
    for p in var.mariadb_hosts : p.name => p
  }
  path = each.value.name
  type = "database"
}

resource "vault_database_secret_backend_connection" "default" {
  for_each = {
    for p in var.mariadb_hosts : p.name => p
  }
  backend           = vault_mount.default[each.value.name].path
  name              = each.value.name
  allowed_roles     = each.value.allowed_roles
  verify_connection = true # This is required if the mariadb cluster is down

  mysql {
    connection_url = "{{username}}:{{password}}@tcp(${each.value.host}:${each.value.port})/${each.value.db}"
    # "{{username}}:{{password}}@tcp(127.0.0.1:3306)/" \
    username       = each.value.admin_user
    password       = each.value.admin_pass
  }
}

/* List of roles and permisisons */
resource "vault_database_secret_backend_role" "admin" {
  for_each    = toset(local.cluster_names)
  backend     = vault_mount.default[each.value].path
  name        = "admin"
  db_name     = vault_database_secret_backend_connection.default[each.value].name
  default_ttl = local.max_ttl
  max_ttl     = local.admin_ttl
  creation_statements = [
    "CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';",
    "GRANT ALL ON *.* TO '{{name}}'@'%';"
  ]
  revocation_statements = [
    "DROP USER IF EXISTS '{{username}}';",
  ]
}

resource "vault_database_secret_backend_role" "readonly" {
  for_each    = toset(local.cluster_names)
  backend     = vault_mount.default[each.value].path
  name        = "readonly"
  db_name     = vault_database_secret_backend_connection.default[each.value].name
  default_ttl = local.max_ttl
  max_ttl     = local.ttl
  creation_statements = [
    "CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';",
    "GRANT SELECT ON *.* TO '{{name}}'@'%';"
  ]
  revocation_statements = [
    "DROP USER IF EXISTS '{{username}}';",
  ]
}

resource "vault_database_secret_backend_role" "writer" {
  for_each    = toset(local.cluster_names)
  backend     = vault_mount.default[each.value].path
  name        = "writer"
  db_name     = vault_database_secret_backend_connection.default[each.value].name
  default_ttl = local.max_ttl
  max_ttl     = local.ttl
  creation_statements = [
    "CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';",
    "GRANT SELECT,INSERT,UPDATE ON *.* TO '{{name}}'@'%';"
  ]
  revocation_statements = [
    "DROP USER IF EXISTS '{{username}}';",
  ]
}
