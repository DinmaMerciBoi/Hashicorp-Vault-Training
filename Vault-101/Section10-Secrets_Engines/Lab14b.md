# KV Secrets Engine Lab 2
In this lab we will explore the KV Secrets Engine. We will use the same Vault server that we configured in Section06 and Lab05 that uses Integrated Storage / Raft backend (not the one we created with Terraform for auto-unseal.)

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

## KV v2 Check-and-Set

Check and set (cas) is a feature of KV v2 to prevent secrets from getting overwritten by mistake.

### Enable cas_required on the kv-v2/castest path

**Run this command:**
```bash
vault kv metadata put -cas-required=true kv-v2/castest
```

### Write the first secret at this path with cas=0
**Run this command:**
```bash
vault kv put -cas=0 kv-v2/castest api=xyz
```

### Update the secret with cas enabled
**Run this command:**
```bash
vault kv put -cas=1 kv-v2/castest api=abc
```

### Try writing a secret without cas
**Run this command:**
```bash
vault kv put kv-v2/castest api=def
```

### Try writing a secret with the wrong cas version
**Run this command:**
```bash
vault kv put -cas=1 kv-v2/castest api=def
```

### Use the correct cas version to write the secret
**Run this command:**
```bash
vault kv put -cas=2 kv-v2/castest api=def
```

## Viewing Previous KV v2 Secret Versions
One of the key features of KV v2 is versioning.

### Create multiple versions of a Secret
**Run these commands:**
```bash
vault kv put kv-v2/webblog/mongo user=sam3 password=s3crt3
vault kv put kv-v2/webblog/mongo user=sam4 password=s3crt4
vault kv put kv-v2/webblog/mongo user=sam5 password=s3crt5
```

### Get the current version of the kv-v2/webblog/mongo secret
**Run this command:**
```bash
vault kv get kv-v2/webblog/mongo
```

### Get version 3 of the kv-v2/webblog/mongo secret
**Run this command:**
```bash
vault kv get -version=3 kv-v2/webblog/mongo
```

## KV v2 Delete, Undelete, and Destroy

### Delete the current version of a secret

**Run these commands:**
```bash
vault kv delete kv-v2/webblog/mongo
vault kv get kv-v2/webblog/mongo
```

### Delete a previous version of a secret

**Run these commands:**
```bash
vault kv delete -versions=3 kv-v2/webblog/mongo
vault kv get -version=3 kv-v2/webblog/mongo
```

### Undelete a previous version of a secret

**Run these commands:**
```bash
vault kv undelete -versions=3 kv-v2/webblog/mongo
vault kv get -version=3 kv-v2/webblog/mongo
```

### Destroy permanently deletes a secret

**Run these commands:**
```bash
vault kv destroy -versions=3 kv-v2/webblog/mongo
vault kv get -version=3 kv-v2/webblog/mongo
vault kv undelete -versions=3 kv-v2/webblog/mongo
vault kv get -version=3 kv-v2/webblog/mongo
```

### Permanently destroy all versions and metadata of a secret

**Run these commands:**
```bash
vault kv metadata delete kv-v2/webblog/mongo
vault kv get kv-v2/webblog/mongo
```

## KV v2 in the UI

Navigate to the UI and try out the features we just tested in the CLI.

> This concludes the KV Secrets Engine Lab 2