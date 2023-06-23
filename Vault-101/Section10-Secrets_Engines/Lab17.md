# Cubbyhole Secrets Engine Lab

In this lab we will take a look at the cubbyhole secrets engine. We will use the same Vault server that we configured in Section06 and Lab05 that uses Integrated Storage / Raft backend (not the one we created with Terraform for auto-unseal.)

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

## CLI Usage

### Create a token with the default policy

**Run this command:**
```bash
vault token create -policy=default
```

### Write some arbitrary key value pair at a given path

**Run this command:**
```bash
VAULT_TOKEN=s.mxNmUW5i93TI56nS30UZIp59 vault write \
    cubbyhole/private/access-token mytoken="abc123"
```

### Read the value

**Run this command:**
```bash
VAULT_TOKEN=s.mxNmUW5i93TI56nS30UZIp59 vault read \
    cubbyhole/private/access-token
```

### Try to read the value with the root token

**Run this command:**
```bash
vault read cubbyhole/private/access-token
```

**Expected Output:**
```
No value found at cubbyhole/private/access-token
```

This shows that even the root token can't read the content of a cubbyhole secret.

### Check the default policy's behaviour towards cubbyhole

**Run this command:**
```bash
vault policy read default
```

**Expected output:**
```
...truncated
# Allow a token to manage its own cubbyhole
path "cubbyhole/*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}
...truncated
```

> This concludes the Cubbyhole Secrets Engine Lab