# Auto Unseal with AWS KMS

### Restart Vault with Shamir Unseal

Let's restart the Vault server to see how it comes back up in a sealed state. This requires us to unseal it with Shamir keys which adds operational complexity.

Stop the server that's running in the first terminal tab from the previous lab. Use CTRL+C to do that and notice the output of the logs showing that the vault is sealed.

Output:
```
^C==> Vault shutdown triggered
2022-01-18T07:26:13.995-0500 [INFO]  core: marked as sealed
2022-01-18T07:26:13.995-0500 [INFO]  core: pre-seal teardown starting
2022-01-18T07:26:13.995-0500 [INFO]  rollback: stopping rollback manager
2022-01-18T07:26:13.995-0500 [INFO]  core: pre-seal teardown complete
2022-01-18T07:26:13.995-0500 [INFO]  core: stopping cluster listeners
2022-01-18T07:26:13.995-0500 [INFO]  core.cluster-listener: forwarding rpc listeners stopped
2022-01-18T07:26:14.071-0500 [INFO]  core.cluster-listener: rpc listeners successfully shut down
2022-01-18T07:26:14.071-0500 [INFO]  core: cluster listeners successfully shut down
2022-01-18T07:26:14.072-0500 [INFO]  core: vault is sealed
```

Re-start the Vault server by running the command:

```bash
vault server -config=./vault-config.hcl
```

In the second tab, run the `vault status` command and noticed how the value `Sealed` is true:

Output:

```
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       1
Threshold          1
Unseal Progress    0/1
Unseal Nonce       n/a
Version            1.9.2
Storage Type       file
HA Enabled         false
```

### Use Auto Unseal with AWS KMS

Now let's use Terraform to create a new Vault server in AWS and use AWS KMS to auto unseal Vault. Please note that you can still use AWS KMS with an on-prem Vault instance.

You can use your own AWS account or launch an AWS account as part of your TeKanAid Academy Subscription. If you choose to use your own AWS account, then please read the disclaimer below.

> **Disclaimer:** This lab section uses AWS. A Vault EC2 instance of type `t2.micro` is used which is within the AWS free tier, but be aware that other charges may apply. We are not responsible for charges incurred as a result of running this section of the lab.

This is based on the [HashiCorp learn guide for AWS auto unseal](https://learn.hashicorp.com/tutorials/vault/autounseal-aws-kms?in=vault/auto-unseal)

Set your AWS Access Key ID and your AWS Secret Access Key values in an environment variables named AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY, respectively.

```bash
export AWS_ACCESS_KEY_ID="<YOUR_AWS_ACCESS_KEY_ID>"
export AWS_SECRET_ACCESS_KEY="<YOUR_AWS_SECRET_ACCESS_KEY>"
```

Change directory into the `aws_auto_unseal` folder:

```bash
cd aws_auto_unseal
```

By default, AWS resources will be provisioned in the us-east-1 region. If you wish to use another AWS region, rename the `terraform.tfvars.example` file to `terraform.tfvars` and update your variables.

Ensure Terraform is installed on your local machine. If not, you can [download it here.](https://www.terraform.io/downloads)

#### Steps

```bash
# Pull necessary plugins
$ terraform init

$ terraform plan

# Output provides the SSH instruction
$ terraform apply --auto-approve

# SSH into the EC2 machine
$ ssh ubuntu@<IP_ADDRESS> -i private.key

#----------------------------------
# Once inside the EC2 instance...
$ export VAULT_ADDR=http://127.0.0.1:8200

$ vault status

# Initialize Vault
$ vault operator init -recovery-shares=1 -recovery-threshold=1

# Restart the Vault server
$ sudo systemctl restart vault

# Check to verify that the Vault is auto-unsealed
$ vault status

$ vault login <INITIAL_ROOT_TOKEN>

# Explore the Vault configuration file
$ cat /etc/vault.d/vault.hcl

$ exit
#----------------------------------

# Clean up...
$ terraform destroy
$ rm -rf .terraform* terraform.tfstate* private.key
```