# The Vault CLI

The Vault Command Line Interface (CLI) allows you to interact with Vault servers.

Let's start with some basic vault commands

## Check the version of Vault
**Run this command:**
```bash
vault version
```

**Expected Output:**
```
Vault v1.9.2 (f4c6d873e2767c0d6853b5d9ffc77b0d297bfbdf)
```

## List the Vault CLI commands
**Run this command:**
```bash
vault
```

**Expected Output:**
```
Usage: vault <command> [args]

Common commands:
    read        Read data and retrieves secrets
    write       Write data, configuration, and secrets
    delete      Delete secrets and configuration
    list        List data or secrets
    login       Authenticate locally
    agent       Start a Vault agent
    server      Start a Vault server
    status      Print seal and HA status
    unwrap      Unwrap a wrapped secret

Other commands:
    audit          Interact with audit devices
    auth           Interact with auth methods
    debug          Runs the debug command
    kv             Interact with Vault's Key-Value storage
    lease          Interact with leases
    monitor        Stream log messages from a Vault server
    namespace      Interact with namespaces
    operator       Perform operator-specific tasks
    path-help      Retrieve API help for paths
    plugin         Interact with Vault plugins and catalog
    policy         Interact with policies
    print          Prints runtime configurations
    secrets        Interact with secrets engines
    ssh            Initiate an SSH session
    token          Interact with tokens
```

## Use the help flags

### Get help for the "vault secrets" command
**Run this command:**
```bash
vault secrets -h
```

**Expected Output:**
```
Usage: vault secrets <subcommand> [options] [args]

  This command groups subcommands for interacting with Vault's secrets engines.
  Each secret engine behaves differently. Please see the documentation for
  more information.

  List all enabled secrets engines:

      $ vault secrets list

  Enable a new secrets engine:

      $ vault secrets enable database

  Please see the individual subcommand help for detailed usage information.

Subcommands:
    disable    Disable a secret engine
    enable     Enable a secrets engine
    list       List enabled secrets engines
    move       Move a secrets engine to a new path
    tune       Tune a secrets engine configuration
```

Note that you can also use the "-help" and "--help" flags instead of "-h".

### Get help for the "vault read" command
**Run this command:**
```bash
vault read -h
```

**Expected Output:**
```
Usage: vault read [options] PATH

  Reads data from Vault at the given path. This can be used to read secrets,
  generate dynamic credentials, get configuration details, and more.

  Read a secret from the static secrets engine:

      $ vault read secret/my-secret

  For a full list of examples and paths, please see the documentation that
  corresponds to the secrets engine in use.

HTTP Options:

  -address=<string>
      Address of the Vault server. The default is https://127.0.0.1:8200. This
      can also be specified via the VAULT_ADDR environment variable.

  -agent-address=<string>
      Address of the Agent. This can also be specified via the
      VAULT_AGENT_ADDR environment variable.

  -ca-cert=<string>
      Path on the local disk to a single PEM-encoded CA certificate to verify
      the Vault server's SSL certificate. This takes precedence over -ca-path.
      This can also be specified via the VAULT_CACERT environment variable.

  -ca-path=<string>
      Path on the local disk to a directory of PEM-encoded CA certificates to
      verify the Vault server's SSL certificate. This can also be specified
      via the VAULT_CAPATH environment variable.

  -client-cert=<string>
      Path on the local disk to a single PEM-encoded CA certificate to use
      for TLS authentication to the Vault server. If this flag is specified,
      -client-key is also required. This can also be specified via the
      VAULT_CLIENT_CERT environment variable.

  -client-key=<string>
      Path on the local disk to a single PEM-encoded private key matching the
      client certificate from -client-cert. This can also be specified via the
      VAULT_CLIENT_KEY environment variable.

  -header=<key=value>
      Key-value pair provided as key=value to provide http header added to any
      request done by the CLI.Trying to add headers starting with 'X-Vault-'
      is forbidden and will make the command fail This can be specified
      multiple times.

  -mfa=<string>
      Supply MFA credentials as part of X-Vault-MFA header. This can also be
      specified via the VAULT_MFA environment variable.

  -namespace=<string>
      The namespace to use for the command. Setting this is not necessary
      but allows using relative paths. -ns can be used as shortcut. The
      default is (not set). This can also be specified via the VAULT_NAMESPACE
      environment variable.

  -output-curl-string
      Instead of executing the request, print an equivalent cURL command
      string and exit. The default is false.

  -policy-override
      Override a Sentinel policy that has a soft-mandatory enforcement_level
      specified The default is false.

  -tls-server-name=<string>
      Name to use as the SNI host when connecting to the Vault server via TLS.
      This can also be specified via the VAULT_TLS_SERVER_NAME environment
      variable.

  -tls-skip-verify
      Disable verification of TLS certificates. Using this option is highly
      discouraged as it decreases the security of data transmissions to and
      from the Vault server. The default is false. This can also be specified
      via the VAULT_SKIP_VERIFY environment variable.

  -unlock-key=<string>
      Key to unlock a namespace API lock. The default is (not set).

  -wrap-ttl=<duration>
      Wraps the response in a cubbyhole token with the requested TTL. The
      response is available via the "vault unwrap" command. The TTL is
      specified as a numeric string with suffix like "30s" or "5m". This can
      also be specified via the VAULT_WRAP_TTL environment variable.

Output Options:

  -field=<string>
      Print only the field with the given name. Specifying this option will
      take precedence over other formatting directives. The result will not
      have a trailing newline making it ideal for piping to other processes.

  -format=<string>
      Print the output in the given format. Valid formats are "table", "json",
      "yaml", or "pretty". The default is table. This can also be specified
      via the VAULT_FORMAT environment variable.
```