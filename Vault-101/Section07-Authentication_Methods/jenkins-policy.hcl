# Read-only permission on secrets stored at 'kv/data/mysql/webapp'
path "kv/data/mysql/webapp" {
  capabilities = [ "read" ]
}