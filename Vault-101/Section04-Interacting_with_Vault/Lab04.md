# The Vault API

## Check Vault's Health
**Run this command:**
```bash
curl http://localhost:8200/v1/sys/health 
```

Use the `jq` utility to format `JSON`

If you don't have it installed, install it with:
```bash
sudo apt-get install jq
```

Now run the same command again with the `jq` utility
**Run this command:**
```bash
curl http://localhost:8200/v1/sys/health | jq
```

**Expected Output:**
```
{
  "initialized": true,
  "sealed": false,
  "standby": false,
  "performance_standby": false,
  "replication_performance_mode": "disabled",
  "replication_dr_mode": "disabled",
  "server_time_utc": 1642078329,
  "version": "1.9.2",
  "cluster_name": "vault-cluster-62a229ef",
  "cluster_id": "002d9778-8f10-5e17-8f6a-6067947cb680"
}
```

## Check System Mounts and use Auth
The `sys/health` endpoint didn't require any authentication, but most Vault API calls do require authentication. This is done with a Vault token that is provided with the X-Vault-Token header

**Run this command:**
```bash
curl -H "X-Vault-Request: true" -H "X-Vault-Token: root" http://127.0.0.1:8200/v1/sys/mounts | jq
```

**Expected Output:**
```
{
  "sys/": {
    "accessor": "system_8f4f7680",
    "config": {
      "default_lease_ttl": 0,
      "force_no_cache": false,
      "max_lease_ttl": 0,
      "passthrough_request_headers": [
        "Accept"
...truncated
```

## Try out the Vault API Explorer in the UI

This uses the OpenAPI standard to allow you to try different commands in the UI. It's very helpful when testing.

## The -output-curl-string Flag

This flag helps you figure out what API curl command to use if you know the equivalent Vault CLI command. Instead of executing the request, print an equivalent curl command string and exit. The default is false.

**Run this command:**
```bash
vault secrets list -output-curl-string
```

**Expected Output:**
```
curl -H "X-Vault-Request: true" -H "X-Vault-Token: $(vault print token)" http://127.0.0.1:8200/v1/sys/mounts
```

**Run this command:**
```bash
vault kv put -output-curl-string secret/test foo=bar
```

**Expected Output:**
```
curl -X PUT -H "X-Vault-Request: true" -H "X-Vault-Token: $(vault print token)" -d '{"data":{"foo":"bar"},"options":{}}' http://127.0.0.1:8200/v1/secret/data/test 
```