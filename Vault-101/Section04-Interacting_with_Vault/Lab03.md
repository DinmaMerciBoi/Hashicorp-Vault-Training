# Vault Server in Dev Mode
In this challenge, you will run your first Vault server in `dev` mode and write your first secret to Vault.

[More info on Vault's `dev` mode here.](https://www.vaultproject.io/docs/concepts/dev-server/)

You will use the default KV v2 secrets engine that Vault automatically creates in `dev` mode. It is used to store multiple versions of static secrets.

[More info on the KV v2 secrets engine here.](https://www.vaultproject.io/docs/secrets/kv/kv-v2/)

## Start the Server
**Run this command:**
```bash
vault server -dev -dev-root-token-id=root
```

**Expected Output:**
```
==> Vault server configuration:

             Api Address: http://127.0.0.1:8200
                     Cgo: disabled
         Cluster Address: https://127.0.0.1:8201
              Listener 1: tcp (addr: "127.0.0.1:8200", cluster address: "127.0.0.1:8201", max_request_duration: "1m30s", max_request_size: "33554432", tls: "disabled")
               Log Level: info
                   Mlock: supported: false, enabled: false
           Recovery Mode: false
                 Storage: inmem
                 Version: Vault v1.4.1

WARNING! dev mode is enabled! In this mode, Vault runs entirely in-memory
and starts unsealed with a single unseal key. The root token is already
authenticated to the CLI, so you can immediately begin using Vault.

You may need to set the following environment variable:

    $ export VAULT_ADDR='http://127.0.0.1:8200'

The unseal key and root token are displayed below in case you want to
seal/unseal the Vault or re-authenticate.

Unseal Key: 1+yv+v5mz+aSCK67X6slL3ECxb4UDL8ujWZU/ONBpn0=
Root Token: root

Development mode should NOT be used in production installations!

==> Vault server started! Log data will stream in below:

# ...
```

Save the unseal key somewhere. Don't worry about how to save this securely. For now, just save it anywhere. Your root token is: `root`.

## Start Interacting with the Server
Launch a new terminal session

### Define the Vault Address in the CLI
**Run this command:**
```bash
export VAULT_ADDR='http://127.0.0.1:8200'
```

Vault CLI determines which Vault servers to send requests using the VAULT_ADDR environment variable.

### Verify the Server is Running

**Run this command:**
```bash
vault status
```

### Log in to Vault

**Run this command:**
```bash
vault login
```

**Expected Output:**
```
Token (will be hidden): 
```

Enter `root` when prompted for the token.

## Your First Secret

### Get Help with the KV Secrets Engine
**Run this command:**
```bash
vault kv --help
```

**Expected Output:**
```
Usage: vault kv <subcommand> [options] [args]

  This command has subcommands for interacting with Vault's key-value
  store. Here are some simple examples, and more detailed examples are
  available in the subcommands or the documentation.

  Create or update the key named "foo" in the "secret" mount with the value
  "bar=baz":

      $ vault kv put secret/foo bar=baz

  Read this value back:

      $ vault kv get secret/foo

  Get metadata for the key:

      $ vault kv metadata get secret/foo

  Get a specific version of the key:

      $ vault kv get -version=1 secret/foo

  Please see the individual subcommand help for detailed usage information.

Subcommands:
    delete               Deletes versions in the KV store
    destroy              Permanently removes one or more versions in the KV store
    enable-versioning    Turns on versioning for a KV store
    get                  Retrieves data from the KV store
    list                 List data or secrets
    metadata             Interact with Vault's Key-Value storage
    patch                Sets or updates data in the KV store without overwriting
    put                  Sets or updates data in the KV store
    rollback             Rolls back to a previous version of data
    undelete             Undeletes versions in the KV stor
```

### Write a Secret
**Run this command:**
```bash
vault kv put --help
```

**Expected Output:**
```
Usage: vault kv put [options] KEY [DATA]

  Writes the data to the given path in the key-value store. The data can be of
  any type.

      $ vault kv put secret/foo bar=baz
...truncated
```

Write your first secret with `key: bar` and `value: baz`
**Run this command:**
```bash
vault kv put secret/foo bar=baz
```

**Expected Output:**
```
Key                Value
---                -----
created_time       2022-02-04T13:08:50.0805439Z
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            1
```

Update the secret by adding another key/value secret at the same path:

**Run this command:**
```bash
vault kv put secret/foo bar=baz hello=world
```

**Expected Output:**
```
Key                Value
---                -----
created_time       2022-02-04T13:09:05.8061969Z
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            2
```

Notice that the `version` of the secret is now `2`.

### Read a Secret

You can retrieve a secret with the command: `vault kv get <path>`.

**Run this command:**
```bash
vault kv get secret/foo
```

**Expected Output:**
```
======= Metadata =======
Key                Value
---                -----
created_time       2022-02-04T13:09:05.8061969Z
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            2

==== Data ====
Key      Value
---      -----
bar      baz
hello    world
```

Vault returns the latest version (in this case version 2) of the secrets at secret/foo

### Delete a Secret

**Run this command:**
```bash
vault kv delete secret/foo
```

**Expected Output:**
```
Success! Data deleted (if it existed) at: secret/foo
```

Try to read the secret you just deleted.

**Run this command:**
```bash
vault kv get secret/foo
```

**Expected Output:**
```
======= Metadata =======
Key                Value
---                -----
created_time       2022-02-04T13:09:05.8061969Z
custom_metadata    <nil>
deletion_time      2022-02-04T13:12:30.3926773Z
destroyed          false
version            2
```

The output only displays the metadata with `deletion_time`. It does not display the data itself once it is deleted. Notice that the `destroyed` parameter is `false` which means that you can recover the deleted data if the deletion was unintentional.

### UnDelete a Secret

**Run this command:**
```bash
vault kv undelete -versions=2 secret/foo
```

**Expected Output:**
```
Success! Data written to: secret/undelete/foo
```

Now the secret is recovered.

**Run this command:**
```bash
vault kv get secret/foo
```

**Expected Output:**
```
======= Metadata =======
Key                Value
---                -----
created_time       2022-02-04T13:09:05.8061969Z
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            2

==== Data ====
Key      Value
---      -----
bar      baz
hello    world
```