# Run a Vault Production Server

Let's run a production Vault sever.

A production Vault server gets its configuration from a configuration file. Open the `vault-config.hcl` configuration file in this folder

## Start the Vault Server with a config file

Open a terminal tab and run a Vault server that uses the configuration file:

**Run these commands:**
```bash
cd Section06-Starting_a_Production_Vault_Server
mkdir -p vault/data
vault server -config=./vault-config.hcl
```

Since that tab is now running the Vault server, you'll run the rest of the CLI commands on a new terminal tab.

## Initialize the Vault Server

In a new terminal tab, run the following commands to store the Vault address:

**Run this command:**
```bash
export VAULT_ADDR=http://localhost:8200
```

Initialize the new server, indicating that you want to use one unseal key:

**Run this command:**
```bash
vault operator init -key-shares=1 -key-threshold=1
```

This gives you back an unseal key and an initial root token. **Please save these** for further use.

In order to use most Vault commands, you need to set the `VAULT_TOKEN` environment variable, using the initial root token that the `init` command returned:

```bash
export VAULT_TOKEN=<root_token>
```

being sure to use your own root token instead of <root_token>.

## Unseal Vault

You next need to unseal your Vault server, providing the unseal key that the `init` command returned:

```bash
vault operator unseal
```

This will return the status of the server which should show that "Initialized" is "true" and that "Sealed` is "false".

To check the status of your Vault server at any time, you can run the `vault status` command. If it shows that "Sealed" is "true", re-run the `vault operator unseal` command.

You can also log into the Vault UI with your root token.

## Check the Vault status

```bash
vault status
```

## Enable audit logging

```bash
mkdir logs
vault audit enable file file_path=./logs/vault_audit.log
```

Open a third terminal and check the logs:

```bash
tail -f ./logs/vault_audit.log | jq
```

**Please note that this will be the Vault server we will use through out the course, keep the root key and unseal key in a safe place.**
