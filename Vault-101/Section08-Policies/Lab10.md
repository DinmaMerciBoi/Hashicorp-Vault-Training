# Policies Lab 1
Now let's take a closer look at policies in Vault. We will use the same Vault server that we configured in Section06 and Lab05 that uses Integrated Storage / Raft backend (not the one we created with Terraform for auto-unseal.)

**Run this command:**
```bash
export VAULT_TOKEN=<root_token>
export VAULT_ADDR=http://127.0.0.1:8200
```

If the Vault became sealed, unseal it with this command:
**Run this command:**
```bash
vault operator unseal
```

## Built-in Policies

You should be running with the root token. Run the following command to list all the policies:

**Run this command:**
```bash
vault policy list
```

**Expected Output:**
```
bob
default
jenkins
sam
root
```

The 2 built-in policies are `default` and `root`. Let's explore both of them:

### The default policy

**Run this command:**
```bash
vault policy read default
```

Notice that the `default` policy allows basic functionality such as letting the token look up data about itself and to use its cubbyhole data.

### The root policy

**Run this command:**
```bash
vault policy read root
```

**Expected Output:**
```
No policy named: root
```

Notice that you can't see the root policy as it does not contain any rules. It can't be removed nor modified.

You can also view the default policy in the UI, but the root policy is greyed out.

## Policy Paths

Create some secrets using the `root` account

**Run these commands:**
```bash
vault kv put kv/foo msg=hello
vault kv put kv/bar/zip msg=hi
vault kv put kv/bar/zip/zap msg=hola
vault kv put kv/zip-zap/zong msg=goodmorning
vault kv put kv/zip-zap msg=howdy
vault kv put kv/foo/teama msg=whatup
vault kv put kv/foo/bar/teamb msg=bonjour
vault kv put kv/zap/zip/teamb msg=goodnight
vault kv put kv/zap/teamb msg=bye
```

Create the policy `example-policy`:
**Run this command:**
```bash
vault policy write example-policy example-policy.hcl
```

Create a token with the `example-policy`:
**Run this command:**
```bash
vault token create -policy example-policy
```

Now take the token returned from the previous command and use it for the following tests. Please remember to replace the `s.ElgK4WiXWCLuzrogR9CzB5ou` token below with your token from the previous command and not the `root` token.

**Run these commands:**
```bash
# path "kv/data/foo" {
#   capabilities = ["read"]
# }

VAULT_TOKEN=s.ElgK4WiXWCLuzrogR9CzB5ou vault kv get kv/foo # works
VAULT_TOKEN=s.ElgK4WiXWCLuzrogR9CzB5ou vault kv get kv/food # fails
VAULT_TOKEN=s.ElgK4WiXWCLuzrogR9CzB5ou vault kv get kv/foo/bar # fails

# path "kv/data/bar/*" {
#   capabilities = ["read"]
# }
VAULT_TOKEN=s.ElgK4WiXWCLuzrogR9CzB5ou vault kv get kv/bar/zip # works
VAULT_TOKEN=s.ElgK4WiXWCLuzrogR9CzB5ou vault kv get kv/bar/zip/zap # works
VAULT_TOKEN=s.ElgK4WiXWCLuzrogR9CzB5ou vault kv get kv/bar # fails

# path "kv/data/zip-*" {
#   capabilities = ["read"]
# }
VAULT_TOKEN=s.ElgK4WiXWCLuzrogR9CzB5ou vault kv get kv/zip-zap # works
VAULT_TOKEN=s.ElgK4WiXWCLuzrogR9CzB5ou vault kv get kv/zip-zap/zong # works
VAULT_TOKEN=s.ElgK4WiXWCLuzrogR9CzB5ou vault kv get kv/zip/zap # fails

# path "kv/data/+/teama" {
#   capabilities = ["read"]
# }
VAULT_TOKEN=s.ElgK4WiXWCLuzrogR9CzB5ou vault kv get kv/foo/teama # works
VAULT_TOKEN=s.ElgK4WiXWCLuzrogR9CzB5ou vault kv get kv/foo/bar/teama # fails
VAULT_TOKEN=s.ElgK4WiXWCLuzrogR9CzB5ou vault kv get kv/foo/teamazap # fails

# path "kv/data/+/+/teamb" {
#   capabilities = ["read"]
# }
VAULT_TOKEN=s.ElgK4WiXWCLuzrogR9CzB5ou vault kv get kv/foo/bar/teamb # works
VAULT_TOKEN=s.ElgK4WiXWCLuzrogR9CzB5ou vault kv get kv/zap/zip/teamb # works
VAULT_TOKEN=s.ElgK4WiXWCLuzrogR9CzB5ou vault kv get kv/zap/teamb # fails
```