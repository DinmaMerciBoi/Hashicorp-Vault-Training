# Tokens Lab 2
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

## Explicit Max TTL and Use Limit

**Run these commands:**
```bash
vault token create -policy="test" -use-limit=5 -explicit-max-ttl=24h -ttl=1h
vault token lookup s.7ApJH1AKUa1rjM319VCtBHvm
```

**Expected Output:**
```
Key                 Value
---                 -----
accessor            GprpeZ9N7C29Mpg8iK7i4BUz
creation_time       1645018302
creation_ttl        1h
display_name        token
entity_id           n/a
expire_time         2022-02-16T09:31:42.5102145-05:00
explicit_max_ttl    24h
id                  s.7ApJH1AKUa1rjM319VCtBHvm
issue_time          2022-02-16T08:31:42.5102377-05:00
meta                <nil>
num_uses            5
orphan              false
path                auth/token/create
policies            [default test]
renewable           true
ttl                 59m29s
type                service
```

## Periodic Tokens

**Run these commands:**
```bash
vault token create -policy="test" -period=6h
vault token lookup s.fsZPHABi7ZEySGM62QGK57kW
```

**Expected Output:**
```
Key                 Value
---                 -----
accessor            NE5EFF6eUX6S2r7FL2sYj7jY
creation_time       1645018396
creation_ttl        6h
display_name        token
entity_id           n/a
expire_time         2022-02-16T14:33:16.7798933-05:00
explicit_max_ttl    0s
id                  s.fsZPHABi7ZEySGM62QGK57kW
issue_time          2022-02-16T08:33:16.7799134-05:00
meta                <nil>
num_uses            0
orphan              false
path                auth/token/create
period              6h
policies            [default test]
renewable           true
ttl                 5h59m10s
type                service
```

## Service and Batch Tokens

### Service Token Creation

**Run these commands:**
```bash
vault token create -policy="test"
vault token lookup s.JrAYW3SuaeifkoVa9y0vYqfO
```

**Expected Output:**
```
Key                  Value
---                  -----
token                s.JrAYW3SuaeifkoVa9y0vYqfO
token_accessor       qUujhrOdDkZjGskacGhpewcE
token_duration       768h
token_renewable      true
token_policies       ["default" "test"]
identity_policies    []
policies             ["default" "test"]
(⎈ |k3s-vmware:vault-raft)
Gabrail-Windows:sam:~/Deployment_Linux/Vault/Training/vault-101/Section09-Tokens$vault token lookup s.JrAYW3SuaeifkoVa9y0vYqfO
Key                 Value
---                 -----
accessor            qUujhrOdDkZjGskacGhpewcE
creation_time       1645018578
creation_ttl        768h
display_name        token
entity_id           n/a
expire_time         2022-03-20T09:36:18.213688-04:00
explicit_max_ttl    0s
id                  s.JrAYW3SuaeifkoVa9y0vYqfO
issue_time          2022-02-16T08:36:18.2137113-05:00
meta                <nil>
num_uses            0
orphan              false
path                auth/token/create
policies            [default test]
renewable           true
ttl                 767h58m56s
type                service
```

### Batch Token Creation

**Run these commands:**
```bash
vault token create -policy="test" -type="batch"
vault token lookup b.AAAAAQK-qz8ZPCUf5amy16vGfzO_OTWGR9uGn588zJVsk83LFOmArIUqjpjPR21qxhCSrYQHcGdHKPoIMPy4DPmWA3s9QrXKXuiJjYlQmtePZ7jCZ8-PN_PLvxP5hef1F3aqbGxOGjau36sFw5gLZAIb1-loPnZu5o-QOo_WCA
```

**Expected Output:**
```
Key                 Value
---                 -----
accessor            n/a
creation_time       1645018706
creation_ttl        768h
display_name        token
entity_id           n/a
expire_time         2022-03-20T09:38:26-04:00
explicit_max_ttl    0s
id                  b.AAAAAQK-qz8ZPCUf5amy16vGfzO_OTWGR9uGn588zJVsk83LFOmArIUqjpjPR21qxhCSrYQHcGdHKPoIMPy4DPmWA3s9QrXKXuiJjYlQmtePZ7jCZ8-PN_PLvxP5hef1F3aqbGxOGjau36sFw5gLZAIb1-loPnZu5o-QOo_WCA
issue_time          2022-02-16T08:38:26-05:00
meta                <nil>
num_uses            0
orphan              false
path                auth/token/create
policies            [default test]
renewable           false
ttl                 767h59m29s
type                batch
```