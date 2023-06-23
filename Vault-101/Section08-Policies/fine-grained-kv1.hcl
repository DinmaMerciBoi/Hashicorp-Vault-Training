path "kvv1/team1" {
  capabilities = ["create", "list", "update"]
  required_parameters = ["bar", "baz"]
}
path "kvv1/team2" {
  capabilities = ["create", "list", "update"]
  allowed_parameters = {
    "bar" = []
  }
}
path "kvv1/team3" {
  capabilities = ["create", "list", "update"]
  allowed_parameters = {
    "bar" = ["zip", "zap"]
    "*"   = []
  }
}
path "kvv1/team4" {
  capabilities = ["create", "list", "update"]
  denied_parameters = {
    "bar" = []
  }
}
path "kvv1/team5" {
  capabilities = ["create", "list", "update"]
  denied_parameters = {
    "bar" = ["zip", "zap"]
  }
}
path "kvv1/team6" {
  capabilities = ["create", "list", "update"]
  denied_parameters = { "*" = [] }
}