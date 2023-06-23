path "kv/data/bob/*" {
  capabilities = ["create", "update", "read", "delete"]
}
path "kv/delete/bob/*" {
  capabilities = ["update"]
}
path "kv/metadata/bob/*" {
  capabilities = ["list", "read", "delete"]
}
path "kv/destroy/bob/*" {
  capabilities = ["update"]
}

# Additional access for UI
path "kv/metadata" {
  capabilities = ["list"]
}
