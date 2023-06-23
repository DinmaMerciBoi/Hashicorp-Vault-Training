# Userpass Auth Method

It's time to learn how to authenticate users. We will use the same Vault server that we configured in Section06 and Lab05 that uses Integrated Storage / Raft backend (not the one we created with Terraform for auto-unseal.)

## Enable a kv v2 secrets engine

Use the root token to enable a kv v2 secrets engine at the `kv/` path. In a terminal window:

**Run this command:**
```bash
export VAULT_TOKEN=<root_token>
export VAULT_ADDR=http://127.0.0.1:8200
vault secrets enable -version=2 kv
vault kv put kv/foo bar=baz
```

If the Vault became sealed, unseal it with this command:
**Run this command:**
```bash
vault operator unseal
```

## Enable the userpass auth method

Continue to use the root token to configure the userpass auth method:

**Run this command:**
```bash
vault auth enable userpass
```

## Add a Vault user without any policies

**Run this command:**
```bash
vault write auth/userpass/users/sam password=samtest123
```

## Logging in
Now, you can sign into the Vault UI by selecting the Username method and providing your username and password.

You can also login with the Vault CLI:
**Run this command:**
```bash
vault login -method=userpass username=sam password=samtest123
```

This login method gives you a Vault token with Vault's `default` policy that grants some very limited capabilities. A yellow warning message tells us that we currently have the VAULT_TOKEN environment variable set and that we should either unset it or set it to the new token. Let's unset it:

**Run this command:**
```bash
unset VAULT_TOKEN
```

To confirm that your new token is being used, **run this command:**
```bash
vault token lookup
```

You will see that the display_name of the current token is `userpass-sam` where `sam` is your username and that the only policy listed for the token is the `default` policy.

Try to read the secret you wrote to the kv v2 secrets engine when you were logged in as `root`:

```bash
vault kv get kv/foo
```

You will get an error message because your token is not authorized to read any secrets yet. That is because Vault policies are "deny by default", meaning that a token can only read or write a secret if it is explicitly given permission to do so by one of its policies.

## Use Vault Policies

Now that you have the userpass authentication method configured, you can add policies to give different users access to different secrets. Go back to using the `root` token:
**Run this command:**
```bash
export VAULT_TOKEN=<root_token>
```

### Add another Vault user
You already created a username for `sam` to use with the userpass auth method. Now, create a second user `bob` with the same command you used before.

**Run this command:**
```bash
vault write auth/userpass/users/bob password=bobtest123
```

Notice we have 2 policy files, one called `sam-policy.hcl` and the other is `bob-policy.hcl`.

### Add policies to Vault
Next, you are going to add the policies to the Vault server:

**Run this command:**
```bash
vault policy write sam ./sam-policy.hcl
vault policy write bob ./bob-policy.hcl
```

### Assign policies to users
Now, you can assign the new policies to the users by updating the policies assigned to the users:

**Run this command:**
```bash
vault write auth/userpass/users/sam/policies policies=sam
vault write auth/userpass/users/bob/policies policies=bob
```

Now, let's see what happens when you log into the Vault UI as the two different users.

Log in as `sam`. Remember to specify the login method as `Username`.

Click the "Create secret +" button, enter `sam/age` for the path, `age` for the key in the `Version data` section of the screen, and your age for the value associated with that key. Then click the "Save" button. You should be allowed to do this.

Logout and log back in as the `bob` user. Try to access `sam's` secret. You should not be able to.

Now, while still logged in as the `bob` user, repeat the above steps to create a secret, specifying the `bob` user's name for <user> in the path. You should be allowed to do this.

If you would like to see what happens when using the Vault CLI, try the following:

**Run this command:**
```bash
unset VAULT_TOKEN
```

Login as user `bob` with:

**Run this command:**
```bash
vault login -method=userpass username=bob password=bobtest123
```

and then **try commands like the following:**

```bash
vault kv get kv/bob/age
vault kv get kv/sam/age
vault kv put kv/bob/weight weight=150
vault kv put kv/sam/weight weight=150
```

These will only succeed when using the `bob` user in the path.

**The idea is that Vault protects each user's secrets from other users.**