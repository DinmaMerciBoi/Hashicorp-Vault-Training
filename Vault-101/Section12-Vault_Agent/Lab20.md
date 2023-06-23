# The Vault Agent Lab

In this Lab you will learn about:
- Auto-Auth
- Caching
- Templates

We will use the same Vault server that we configured in Section06 and Lab05 that uses Integrated Storage / Raft backend (not the one we created with Terraform for auto-unseal.)

**Run these commands:**
```bash
export VAULT_TOKEN=<root_token>
export VAULT_ADDR=http://127.0.0.1:8200
```

If the Vault became sealed, unseal it with this command:
**Run this command:**
```bash
vault operator unseal
```

## Prepare the Vault Server

In the file `vault_admin_script.sh`, replace the root token on line 5 with yours.

In a new terminal window **run this command**:
```bash
./vault_admin_script.sh
```

## Start the vault agent

In a new terminal window **run this command**:

```bash
vault agent -config=./agent-config.hcl -log-level=debug
```

## Check the agent logs

### The Vault Token and the Sink File

Notice in the logs how the agent is authenticating to Vault and dropping a Vault token for the application at the sink file path of `./vault_token`. 

```
2022-02-17T11:46:12.140-0500 [INFO]  sink.file: creating file sink
2022-02-17T11:46:12.140-0500 [INFO]  sink.file: file sink configured: path=./vault_token mode=-rw-r--r--
```

Open that `vault_token` file to see the Vault token there.

Recall that your app can use this token to authenticate into Vault directly or via the agent.

### AppRole Parameters

Now take another look at the `vault_admin_script.sh` file. You'll see the role we created has a few parameters.

```bash
vault write auth/approle/role/webblog \
    secret_id_ttl=2h \
    token_num_uses=5 \
    token_ttl=5s \
    token_max_ttl=24h \
    token_policies="webblog"
```

the `token_num_uses=5` appears in the logs below where you see the Vault agent renewing the token up to a point where in needs to reauthenticate and generate a new token. If you keep watching the `vault_token` file, you will see how it changes.

```
2022-02-17T11:47:18.114-0500 [INFO]  auth.handler: renewed auth token
2022-02-17T11:47:21.669-0500 [INFO]  auth.handler: renewed auth token
2022-02-17T11:47:25.229-0500 [INFO]  auth.handler: renewed auth token
2022-02-17T11:47:28.767-0500 [INFO]  auth.handler: lifetime watcher done channel triggered
2022-02-17T11:47:28.767-0500 [INFO]  auth.handler: authenticating
2022-02-17T11:47:29.066-0500 [INFO]  auth.handler: authentication successful, sending token to sinks
2022-02-17T11:47:29.066-0500 [INFO]  auth.handler: starting renewal process
```

## Vault Agent Caching

For this portion of the lab, we want to increase the `token_num_uses` to 25 and the `token_ttl` to 1005s. In the `vault_admin_script.sh` file, comment and uncomment to get the config below:

```
# Comment below for caching demo
# vault write auth/approle/role/webblog \
#     secret_id_ttl=2h \
#     token_num_uses=5 \
#     token_ttl=5s \
#     token_max_ttl=24h \
#     token_policies="webblog"

# Uncomment below for caching demo
vault write auth/approle/role/webblog \
    secret_id_ttl=2h \
    token_num_uses=25 \
    token_ttl=1005s \
    token_max_ttl=24h \
    token_policies="webblog"
```

Now rerun the `vault_admin_script.sh`:
**Run the following command:**
```bash
./vault_admin_script.sh
```

> **To test caching we will need to read secrets from the AWS secrets engine as we did in Lab15 in Section 10. Please make sure that you've done that lab to proceed.**

Let's test the usage of caching. In a new terminal run the following making sure you have the VAULT_TOKEN env variable unset:

**Run the following commands:**
```bash
unset VAULT_TOKEN
./getSecrets.sh
```

Notice how only the AWS dynamic secret is cached whereas the KV secret is not. Take a look at the logs below:

```
2022-02-17T17:13:06.953-0500 [DEBUG] cache.leasecache: pass-through response; secret not renewable: method=GET path=/v1/kv/data/webblog
2022-02-17T17:13:07.025-0500 [DEBUG] cache.leasecache: returning cached response: path=/v1/aws/creds/my-role
```

## Vault Agent Templating

Uncomment the last section of the `agent-config.hcl` file to add templating.

```hcl
template {
source = "./app-config.tmpl"
destination = "./app-config.yml"
}
```

Follow these steps:
1. Stop the agent with CTRL+C.
2. Run the `vault_admin_script.sh` script again
3. Start the agent again by running: 
    ```bash
    vault agent -config=./agent-config.hcl -log-level=debug
    ```

Notice a file called `app-config.yml` is created and it contains the secrets `USERNAME` and `PASSWORD` stored at `kv/data/webblog` path in the KV store.

Take a look at the template file `app-config.tmpl` to see how the secrets get populated into the `app-config.yml` file.

You can see how the application can be Vault unaware. All iti needs to do is read the content of the `app-config.yml` file. It can then use the `USERNAME` and `PASSWORD` credentials to connect to a database as an example. The Vault agent did all the work of retrieving the secrets and populating the `app-config.yml` file.

## Wrapped Secret ID

A few notes on the wrapped secret_id:

- Notice in the `vault_admin_script.sh` how we can deliver either the secret_id or the wrapped secret_id
- It's a good practice to use a wrapped secret_id instead of the secret_id
- The Vault agent can unwrap the wrapped secret_id, take a look at the Vault agent's config in the `agent-config.hcl` file to see how.
- There is also a `remove_secret_id_file_after_reading=true` setting to remove the file where the secret_id gets unwrapped which is `./webblog_wrapped_secret_id`

> This concludes the Vault Agent Lab
