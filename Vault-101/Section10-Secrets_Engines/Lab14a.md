# KV Secrets Engine Lab 1
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

## Check KV Commands Options
**Run this command:**
```bash
vault kv -h
```

## KV v1 CLI Commands

### Enable KV v1 secrets engine at the default path kv/
**Run this command:**
```bash
vault secrets enable kv
```

### Enable KV v1 secrets engine at the custom path of local/
**Run this command:**
```bash
vault secrets enable -path=local/ kv
```

### Write a secret
**Run this command:**
```bash
vault kv put local/webblog/mongo user=sam password=s3cr3t!
```

### Read a secret
**Run this command:**
```bash
vault kv get local/webblog/mongo
```

## KV v2 CLI Commands

### Enable KV v2 secrets engine at the default path kv-v2/
**Run this command:**
```bash
vault secrets enable kv-v2
```

### Enable KV v2 secrets engine at the custom path of localkv2/
**Run this command:**
```bash
vault secrets enable -version=2 -path=localkv2/ kv
```

### Write a secret
**Run this command:**
```bash
vault kv put localkv2/webblog/mongo user=sam password=s3cr3t!
```

### Read a secret
**Run this command:**
```bash
vault kv get localkv2/webblog/mongo
```

## KV v1 API Commands

### Write a secret

> Remember to substitute my root tokenL `s.HxBpF9n45NlRePewBec7Z5FF` with yours for the remainder of the lab.

**Run this command:**
```bash
curl --header "X-Vault-Token:s.HxBpF9n45NlRePewBec7Z5FF" \
    --request POST \
    --data '{ "user": "sam2", "password": "s3crt2" }' \
    http://127.0.0.1:8200/v1/local/webblog/mongo
```

### Read a secret
**Run this command:**
```bash
curl --header "X-Vault-Token:s.HxBpF9n45NlRePewBec7Z5FF" \
    --request GET \
    http://127.0.0.1:8200/v1/local/webblog/mongo | jq
```

## KV v2 API Commands

### Write a secret
**Run this command:**
```bash
curl --header "X-Vault-Token:s.HxBpF9n45NlRePewBec7Z5FF" \
    --request POST \
    --data '{"data": { "user": "sam2", "password": "s3crt2" }}' \
    http://127.0.0.1:8200/v1/localkv2/data/webblog/mongo | jq
```

### Read a secret
**Run this command:**
```bash
curl --header "X-Vault-Token:s.HxBpF9n45NlRePewBec7Z5FF" \
    --request GET \
    http://127.0.0.1:8200/v1/localkv2/data/webblog/mongo | jq
```

### Write meta data
**Run this command:**
```bash
curl --header "X-Vault-Token:s.HxBpF9n45NlRePewBec7Z5FF" \
    --request POST \
    --data '{"custom_metadata":{"team":"engineering"}}' \
    http://127.0.0.1:8200/v1/localkv2/metadata/webblog/mongo
```

### Read a secret
**Run this command:**
```bash
curl --header "X-Vault-Token:s.HxBpF9n45NlRePewBec7Z5FF" \
    --request GET \
    http://127.0.0.1:8200/v1/localkv2/data/webblog/mongo | jq
```

You can also check the metadata only:
**Run this command:**
```bash
curl --header "X-Vault-Token:s.HxBpF9n45NlRePewBec7Z5FF" \
    --request GET \
    http://127.0.0.1:8200/v1/localkv2/metadata/webblog/mongo | jq
```


> This concludes the KV Secrets Engine Lab 1