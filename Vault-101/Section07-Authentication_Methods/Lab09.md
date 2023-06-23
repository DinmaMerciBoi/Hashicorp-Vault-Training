# Vault Entities, Aliases, and Identity Groups

Most of this lab is done via the Vault UI.

We are following this [HashiCorp learn guide.](https://learn.hashicorp.com/tutorials/vault/identity)

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