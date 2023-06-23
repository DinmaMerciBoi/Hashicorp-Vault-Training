# For testing, read-only on kv/dev path
path "kv/data/dev" {
  capabilities = [ "read" ]
}
