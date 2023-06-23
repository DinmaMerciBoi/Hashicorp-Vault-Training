# Tokens Lab 1
In this lab we will explore tokens in Vault. We will use the same Vault server that we configured in Section06 and Lab05 that uses Integrated Storage / Raft backend (not the one we created with Terraform for auto-unseal.)

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

## Root Tokens

Remember that `root` tokens can do ANYTHING in Vault. Let's take a closer look. Make sure you're logged in as `root`.

**Run this command:**
```bash
vault token lookup
```

**Expected Output:**
```
Key                 Value
---                 -----
accessor            s1mDJrh2QzpPsxJPtLSLHfT8
creation_time       1644608592
creation_ttl        0s
display_name        root
entity_id           n/a
expire_time         <nil>
explicit_max_ttl    0s
id                  s.aJ81vI45UG3CaFWWRrItX5q8
meta                <nil>
num_uses            0
orphan              true
path                auth/token/root
policies            [root]
ttl                 0s
type                service
```

## Token Hierarchy

Let's update sam's policy from Section 07. Take a look at the file `sam-policy.hcl` in this folder. You will see that we added this to the policy:
```
path "auth/token/create" {
  capabilities = ["create", "update", "read", "delete"]
}
```

Now let's update this policy:
**Run this command:**
```bash
vault policy write sam sam-policy.hcl
```

Now it's time to test the token hierarchy, by following these steps:
- Login with the `userpass` auth method with username `sam`.
- Create a new token with policy `test`.
- Examine the new token created.
- Revoke user `sam's` token
- Observe that the token that `sam` created is also revoked. Remember that revoking a parent token also revokes all child tokens.

**Run these commands:**
```bash
unset VAULT_TOKEN
vault login -method=userpass username=sam password=samtest123 # save the parent token returned when logging in: s.3K8IfHsXLJLpHEWEepsx6C3x
vault token create # save the child token s.2qDdwjW7sMeUv3TTuIljg27o
vault token revoke -self # revoke the token associated with user sam
export VAULT_TOKEN=<root_token> # log back in as root
vault token lookup s.2qDdwjW7sMeUv3TTuIljg27o # lookup the child token and you should get an error saying it's a bad token
```

## Orphan Tokens

**Run these commands:**
```bash
vault policy write test test.hcl
vault token create -policy="test" -orphan
vault token lookup s.qx9yVmyjqVBkBKwdS12NaRad # replace s.qx9yVmyjqVBkBKwdS12NaRad with your token id
```

**Expected Output:**
```
Key                 Value
---                 -----
accessor            JljUh7Xp5blJQNcSYmNugd68
creation_time       1645017673
creation_ttl        768h
display_name        token
entity_id           n/a
expire_time         2022-03-20T09:21:13.4103484-04:00
explicit_max_ttl    0s
id                  s.qx9yVmyjqVBkBKwdS12NaRad
issue_time          2022-02-16T08:21:13.4103866-05:00
meta                <nil>
num_uses            0
orphan              true
path                auth/token/create
policies            [default test]
renewable           true
ttl                 767h59m39s
type                service
```

Notice the output shows that orphan is true.

Also record the token accessor from the previous output as we will use it in the next section. In this case it is: `JljUh7Xp5blJQNcSYmNugd68`

## Token Accessors
A token accessor is a reference to a token. It’s used to perform some actions such as:
- Look up a token's properties (not including the actual token ID)
- Look up a token's capabilities on a path
- Renew the token
- Revoke the token


**Run this command:**
```bash
vault token lookup -accessor JljUh7Xp5blJQNcSYmNugd68
```

**Expected Output:**
```
Key                 Value
---                 -----
accessor            JljUh7Xp5blJQNcSYmNugd68
creation_time       1645017673
creation_ttl        768h
display_name        token
entity_id           n/a
expire_time         2022-03-20T09:21:13.4103484-04:00
explicit_max_ttl    0s
id                  n/a
issue_time          2022-02-16T08:21:13.4103866-05:00
meta                <nil>
num_uses            0
orphan              true
path                auth/token/create
policies            [default test]
renewable           true
ttl                 767h55m29s
type                service
```

Notice that the token ID is not present. Now let's revoke this token using its accessor:

**Run these commands:**
```bash
vault token revoke -accessor JljUh7Xp5blJQNcSYmNugd68
vault token lookup -accessor JljUh7Xp5blJQNcSYmNugd68
```

Now you'll find that you will get an error saying that this is an invalid accessor.
