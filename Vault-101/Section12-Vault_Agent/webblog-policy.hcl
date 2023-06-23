path "kv/data/webblog" {
  capabilities = [ "read", "update" ]
}
path "aws/creds/*" {
  capabilities = ["read", "update"]
}
path "sys/leases/*" {
  capabilities = ["create", "update"]
}
path "auth/token/*" {
  capabilities = ["create", "update"]
}