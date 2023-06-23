# AppRole Auth Method

Assume an app (Jenkins) needs to authenticate into Vault to retrieve secrets. AppRole is a good choice for application authentication.

We will use the same Vault server that we configured in Section06 and Lab05 that uses Integrated Storage / Raft backend (not the one we created with Terraform for auto-unseal.)

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

## Create a KV secret for a mysql DB
**Run this command:**
```bash
vault kv put kv/mysql/webapp db_name="users" username="admin" password="passw0rd"
```

## Enable the AppRole auth method

**Run this command:**
```bash
vault auth enable approle
```

## Create a role with a policy attached

### Create the Policy
**Run this command:**
```bash
vault policy write jenkins ./jenkins-policy.hcl
```

### Create the role with the policy
**Run this command:**
```bash
vault write auth/approle/role/jenkins token_policies="jenkins" token_ttl=1h token_max_ttl=4h
```

### Verify the role by reading it
**Run this command:**
```bash
vault read auth/approle/role/jenkins
```

### Get the RoleID and SecretID
The RoleID and SecretID are like a username and password that a machine or app uses to authenticate.

To get the role-id, **run this command:**
```bash
vault read auth/approle/role/jenkins/role-id
```

To generate the secret-id, **run this command:**
```bash
vault write -force auth/approle/role/jenkins/secret-id
```

## Login with RoleID and SecretID
**Run this command:**
```bash
vault write auth/approle/login role_id=<role-id> secret_id=<secret-id>
```

**Example output:**

Key                     Value
---                     -----
token                   s.ncEw5bAZJqvGJgl8pBDM0C5h
token_accessor          gIQFfVhUd8fDsZjC7gLBMnQu
token_duration          1h
token_renewable         true
token_policies          ["default" "jenkins"]
identity_policies       []
policies                ["default" "jenkins"]
token_meta_role_name    jenkins

Vault returns a client token with default and jenkins policies attached.

Store the generated token value in an environment variable named, APP_TOKEN:

**Run this command:**
```bash
export APP_TOKEN=<token_returned_from_the_command_above>
```

## Read secrets using the AppRole token
**Run this command:**
```bash
VAULT_TOKEN=$APP_TOKEN vault kv get kv/mysql/webapp
```

Try deleting the secret will fail due to the policy not allowing this operation:
**Run this command:**
```bash
VAULT_TOKEN=$APP_TOKEN vault kv delete kv/mysql/webapp
```

## Closing Remarks
This was a very simplistic demo of AppRole. In production environments, you would want to have a proper mechanism of securely distributing the RoleID and the SecretID. Refer to the [Advanced Features section](https://learn.hashicorp.com/tutorials/vault/approle#response-wrap-the-secretid) for further discussion on distributing the RoleID and SecretID to the client app securely.

I also wrote a [detailed blog post about this with a demo video.](https://tekanaid.com/posts/secret-zero-problem-solved-for-hashiCorp-vault)
