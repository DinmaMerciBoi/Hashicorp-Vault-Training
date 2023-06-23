path "kv/data/foo" {
  capabilities = ["read"]
}
path "kv/data/bar/*" {
  capabilities = ["read"]
}
path "kv/data/zip-*" {
  capabilities = ["read"]
}
path "kv/data/+/teama" {
  capabilities = ["read"]
}
path "kv/data/+/+/teamb" {
  capabilities = ["read"]
}
