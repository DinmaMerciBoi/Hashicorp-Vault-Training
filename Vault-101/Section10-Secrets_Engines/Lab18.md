# Cubbyhole Response Wrapping Lab

In this lab we will examine cubbyhole response wrapping. We will use the same Vault server that we configured in Section06 and Lab05 that uses Integrated Storage / Raft backend (not the one we created with Terraform for auto-unseal.)

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

> This lab is based on the [Cubbyhole Response Wrapping Learn Guide](https://learn.hashicorp.com/tutorials/vault/cubbyhole-response-wrapping)

## Admin Creates and Wraps a Token

An admin user creates a token using response wrapping. 

### Create a policy for the app.

**Run this command:**
```bash
vault policy write apps apps-policy.hcl
```

### Write some test data at `kv/dev`

**Run this command:**
```bash
vault kv put kv/dev username="webapp" password="my-long-password"
```

### Generate a token for an app using response wrapping with TTL of 30 minutes

The wrap TTL indicates the life of the wrapping token.

**Run this command:**
```bash
vault token create -policy=apps -wrap-ttl=30m
```

**Expected Output:**
```
Key                              Value
---                              -----
wrapping_token:                  s.s6zV3zz6XBQiwsBDN7FVrGUx
wrapping_accessor:               PYCS6EOd4zalPz1ahTIM6ryu
wrapping_token_ttl:              30m
wrapping_token_creation_time:    2022-03-02 15:08:36.8151591 -0500 EST
wrapping_token_creation_path:    auth/token/create
wrapped_accessor:                0XjjnJmxifQrZ680uOJc8hcR
```

## App Unwraps the Secret

The app receives a wrapping token from the admin. In order for the app to acquire a valid token to read secrets from `kv/dev` path, it must run the unwrap operation using this token.

### Create a token with the `default` policy

**Run this command:**
```bash
vault token create -policy=default
```

Remember that the `default` policy is very limited and only gives access to the cubbyhole secrets engine.

**Expected Output:**
```
Key                  Value
---                  -----
token                s.tgOq1Ws2CSAEXWKCa6HUCwLW
token_accessor       OKHroVoCtdVU4Dk6awbIcOqE
token_duration       768h
token_renewable      true
token_policies       ["default"]
identity_policies    []
policies             ["default"]
```

### Authenticate using the generated token

**Run these commands:**
```bash
unset VAULT_TOKEN
vault login s.VR3mwdk9miJ6VRLFbQe0Duwq
```

### Unwrap the secret by passing the wrapping token

**Run this command:**
```bash
VAULT_TOKEN="s.s6zV3zz6XBQiwsBDN7FVrGUx" vault unwrap
```

**Expected Output:**
```
Key                  Value
---                  -----
token                s.0MrHGwR2IKGmLi1e8gKnk6yK
token_accessor       0XjjnJmxifQrZ680uOJc8hcR
token_duration       768h
token_renewable      true
token_policies       ["apps" "default"]
identity_policies    []
policies             ["apps" "default"]
```

Notice that the token has the `apps` policy attached.

### Access the secret

Now that we have the unwrapped token, we can login with it and access the secret at `kv/dev`.

**Run these commands:**
```bash
vault login s.0MrHGwR2IKGmLi1e8gKnk6yK
vault kv get kv/dev
```

> This concludes the Cubbyhole Response Wrapping Lab