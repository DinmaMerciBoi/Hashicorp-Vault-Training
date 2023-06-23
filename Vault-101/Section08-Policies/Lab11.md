# Policies Lab 2

## Managing Policies

### Create a Policy
**Run this command:**
```bash
vault policy write policy-name policy-file.hcl
```

### List Policies (list all registered policies)
**Run this command:**
```bash
vault policy list
```

### Read a Policy
**Run this command:**
```bash
vault policy read policy-name
```

### Update a Policy
**Run these commands:**
```bash
vault write sys/policy/policy-name policy=@update-policy-file.hcl
vault policy read policy-name
```

### Delete a Policy:
**Run these commands:**
```bash
vault policy delete policy-name
vault policy read policy-name
```

## Fine-Grained Controls

>This only works with kv-v1 and NOT kv-v2.

Create a new policy called `fine-grained-policy`

**Run these commands:**
```bash
vault secrets enable -path=kvv1 kv
vault policy write fine-grained-kv1 fine-grained-kv1.hcl
vault token create -policy=fine-grained-kv1
```

Get the token returned and replace the `s.itksMwkdL51fLy7aXzpNPysu` token below with the one you got.

Try to create the following secrets and notice which ones succeed and which ones fail.

**Run these commands:**
```bash
# path "kvv1/team1" {
#   capabilities = ["create", "list", "update"]
#   required_parameters = ["bar", "baz"]
# }
VAULT_TOKEN=s.itksMwkdL51fLy7aXzpNPysu vault kv put kvv1/team1 foo=zip # fails
VAULT_TOKEN=s.itksMwkdL51fLy7aXzpNPysu vault kv put kvv1/team1 bar=zip # fails
VAULT_TOKEN=s.itksMwkdL51fLy7aXzpNPysu vault kv put kvv1/team1 bar=zip baz=foo # works

# path "kvv1/team2" {
#   capabilities = ["create", "list", "update"]
#   allowed_parameters = {
#     "bar" = []
#   }
# }
VAULT_TOKEN=s.itksMwkdL51fLy7aXzpNPysu vault kv put kvv1/team2 foo=zip # fails
VAULT_TOKEN=s.itksMwkdL51fLy7aXzpNPysu vault kv put kvv1/team2 bar=zip # works

# path "kvv1/team3" {
#   capabilities = ["create", "list", "update"]
#   allowed_parameters = {
#     "bar" = ["zip", "zap"]
#     "*"   = []
#   }
# }
VAULT_TOKEN=s.itksMwkdL51fLy7aXzpNPysu vault kv put kvv1/team3 bar=hello # fails
VAULT_TOKEN=s.itksMwkdL51fLy7aXzpNPysu vault kv put kvv1/team3 bar=zip # works
VAULT_TOKEN=s.itksMwkdL51fLy7aXzpNPysu vault kv put kvv1/team3 bar=zap # works
VAULT_TOKEN=s.itksMwkdL51fLy7aXzpNPysu vault kv put kvv1/team3 foo=hi # works

# path "kvv1/team4" {
#   capabilities = ["create", "list", "update"]
#   denied_parameters = {
#     "bar" = []
#   }
# }
VAULT_TOKEN=s.itksMwkdL51fLy7aXzpNPysu vault kv put kvv1/team4 foo=hi # works
VAULT_TOKEN=s.itksMwkdL51fLy7aXzpNPysu vault kv put kvv1/team4 bar=hi # fails

# path "kvv1/team5" {
#   capabilities = ["create", "list", "update"]
#   denied_parameters = {
#     "bar" = ["zip", "zap"]
#   }
# }
VAULT_TOKEN=s.itksMwkdL51fLy7aXzpNPysu vault kv put kvv1/team5 bar=hi # works
VAULT_TOKEN=s.itksMwkdL51fLy7aXzpNPysu vault kv put kvv1/team5 bar=zip # fails
VAULT_TOKEN=s.itksMwkdL51fLy7aXzpNPysu vault kv put kvv1/team5 bar=zap # fails
VAULT_TOKEN=s.itksMwkdL51fLy7aXzpNPysu vault kv put kvv1/team5 foo=zap # works

# path "kvv1/team6" {
#   capabilities = ["create", "list", "update"]
#   denied_parameters = { "*" = [] }
# }
VAULT_TOKEN=s.itksMwkdL51fLy7aXzpNPysu vault kv put kvv1/team6 foo=zap # fails
VAULT_TOKEN=s.itksMwkdL51fLy7aXzpNPysu vault kv put kvv1/team6 bar=foo # fails
```

## Check Token Capabilities

**Run these commands:**
```bash
vault token capabilities s.itksMwkdL51fLy7aXzpNPysu kvv1/team1 # returns create, list, update
vault token capabilities s.itksMwkdL51fLy7aXzpNPysu kvv1/team0 # returns deny
```
