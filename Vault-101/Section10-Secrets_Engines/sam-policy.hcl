path "auth/token/create" {
  capabilities = ["create", "update", "read", "delete"]
}
path "auth/token/lookup" {
  capabilities = ["create", "update", "read", "delete"]
}

path "kv/data/sam/*" {
  capabilities = ["create", "update", "read", "delete"]
}
path "kv/delete/sam/*" {
  capabilities = ["update"]
}
path "kv/metadata/sam/*" {
  capabilities = ["list", "read", "delete"]
}
path "kv/destroy/sam/*" {
  capabilities = ["update"]
}

# Additional access for UI
path "kv/metadata" {
  capabilities = ["list"]
}
