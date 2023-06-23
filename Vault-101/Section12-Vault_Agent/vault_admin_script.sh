# This script is to be run by a Vault admin to get Vault ready.
#!/bin/bash
export VAULT_ADDR=http://127.0.0.1:8200
# Replace the token below with your root token
export VAULT_TOKEN=s.aJ81vI45UG3CaFWWRrItX5q8
# Create an approle
vault auth enable approle
# Create a policies one for the vault agent used with the app
vault policy write webblog webblog-policy.hcl
# Create an approle role for the vault agent's app (webblog)
# Check parameters: https://www.vaultproject.io/api/auth/approle#parameters

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

# Create a KV secret
vault kv put kv/webblog username=sam password=s3cr3t!

# Read the role_id and create a wrapped secret_id and store them in the proper location for the vault agent
vault read -field=role_id auth/approle/role/webblog/role-id > ./webblog_role_id
# Uncomment below to use secret_id directly
# vault write -field=secret_id -f auth/approle/role/webblog/secret-id > ./webblog_secret_id
# Uncomment below to use the wrapped secret_id
vault write -field=wrapping_token -wrap-ttl=200s -f auth/approle/role/webblog/secret-id > ./webblog_wrapped_secret_id