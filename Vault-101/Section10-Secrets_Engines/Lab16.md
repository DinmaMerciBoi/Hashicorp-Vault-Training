# Transit Secrets Engine Lab

In this lab we will explore the transit secrets engine. We will use the same Vault server that we configured in Section06 and Lab05 that uses Integrated Storage / Raft backend (not the one we created with Terraform for auto-unseal.)

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

## Enable the transit secrets engine

**Run this command:**
```bash
vault secrets enable transit
```

## Create a named encryption key (aes256-gcm96) used by default

**Run these commands:**
```bash
vault write -f transit/keys/my-key
vault read transit/keys/my-key
```

## Create a named encryption key and specify key type

**Run these commands:**
```bash
vault write transit/keys/my-key2 type=rsa-2048
vault read transit/keys/my-key2
```

## Encrypt Data

**Run this command:**
```bash
vault write transit/encrypt/my-key plaintext=$(base64 <<< "my secret data")
```

**Expected Output:**
```
Key            Value
---            -----
ciphertext     vault:v1:Ed2hbpHuBSIe3cv9M3e5oEancg5t3a3M74JTz+6rFll155TCT5eRDwNQBg==
key_version    1
```

## Decrypt Data

**Run this command:**
```bash
vault write -field=plaintext transit/decrypt/my-key \
  ciphertext=vault:v1:Ed2hbpHuBSIe3cv9M3e5oEancg5t3a3M74JTz+6rFll155TCT5eRDwNQBg== \
  | base64 --decode
```

**Expected Output:**
```
my secret data
```

## Key Rotation

### Rotate the key (generates new key and adds it to the keyring)

**Run these commands:**
```bash
vault write -f transit/keys/my-key/rotate
vault read transit/keys/my-key
```

**Expected Output:**
```
Key                       Value
---                       -----
allow_plaintext_backup    false
deletion_allowed          false
derived                   false
exportable                false
keys                      map[1:1646236374 2:1646236910]
latest_version            2
min_available_version     0
min_decryption_version    1
min_encryption_version    0
name                      my-key
supports_decryption       true
supports_derivation       true
supports_encryption       true
supports_signing          false
type                      aes256-gcm96
```

## Specify a Minimum Decryption Version of the Key

**Run these commands:**
```bash
vault write transit/keys/my-key/config min_decryption_version=2
vault read transit/keys/my-key
```

**Expected Output:**
```
Key                       Value
---                       -----
allow_plaintext_backup    false
deletion_allowed          false
derived                   false
exportable                false
keys                      map[2:1646236910]
latest_version            2
min_available_version     0
min_decryption_version    2
min_encryption_version    0
name                      my-key
supports_decryption       true
supports_derivation       true
supports_encryption       true
supports_signing          false
type                      aes256-gcm96
```

### Try to decrypt the old data `my secret data` that was generated with v1

**Run this command:**
```bash
vault write -field=plaintext transit/decrypt/my-key \
  ciphertext=vault:v1:Ed2hbpHuBSIe3cv9M3e5oEancg5t3a3M74JTz+6rFll155TCT5eRDwNQBg== \
  | base64 --decode
```

**Expected Output:**
```
Error writing data to transit/decrypt/my-key: Error making API request.

URL: PUT http://127.0.0.1:8200/v1/transit/decrypt/my-key
Code: 400. Errors:

* ciphertext or signature version is disallowed by policy (too old)
```

Vault refused to decrypt because the minimum decryption version of the key is v2 and the ciphertext used v1. This prevents old ciphertext from being decrypted in case they fall in the wrong hands.


## Data Re-wrap

Data can be re-encrypted with a new key version using the rewrap endpoint

### Bring back the min decryption version of the key to v1

**Run these commands:**
```bash
vault write transit/keys/my-key/config min_decryption_version=1
vault read transit/keys/my-key
```

### Try to decrypt the old data `my secret data` with the new version of the key

**Run this command:**
```bash
vault write -field=plaintext transit/decrypt/my-key \
  ciphertext=vault:v1:Ed2hbpHuBSIe3cv9M3e5oEancg5t3a3M74JTz+6rFll155TCT5eRDwNQBg== \
  | base64 --decode
```

### Re-encrypt the ciphertext with the new key version (Data Re-wrap)

**Run this command:**
```bash
vault write transit/rewrap/my-key \
  ciphertext=vault:v1:Ed2hbpHuBSIe3cv9M3e5oEancg5t3a3M74JTz+6rFll155TCT5eRDwNQBg==
```

**Expected Output:**
```
Key            Value
---            -----
ciphertext     vault:v2:9lAlv4Xcss7fcr9hd1nf5LHDrmK5pQcozS2A9U5sgpgpfZElu2KLWw5IGw==
key_version    2
```

### Decrypt the re-wrapped data

**Run this command:**
```bash
vault write -field=plaintext transit/decrypt/my-key \
  ciphertext=vault:v2:9lAlv4Xcss7fcr9hd1nf5LHDrmK5pQcozS2A9U5sgpgpfZElu2KLWw5IGw== \
  | base64 --decode
```

**Expected Output:**
```
my secret data
```

> This concludes the Transit Secrets Engine Lab