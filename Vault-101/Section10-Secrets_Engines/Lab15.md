# AWS Secrets Engine Lab

In this lab we will generate dynamic secrets for AWS. We will use the same Vault server that we configured in Section06 and Lab05 that uses Integrated Storage / Raft backend (not the one we created with Terraform for auto-unseal.)

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

## Enable the AWS secrets engine

**Run this command:**
```bash
vault secrets enable -path=aws aws
```

## Configure the AWS secrets engine

If you are going to use your own AWS account then you will need to create an IAM user in AWS that has the permissions below and retrieve the AWS_ACCESS_KEY_ID and the AWS_SECRET_ACCESS_KEY credentials.
[Here is a list](https://www.vaultproject.io/docs/secrets/aws#example-iam-policy-for-vault) of the required IAM permissions that Vault will need in order to perform the actions on the rest of this page.

If you are using the TeKanAid Academy Subscription to access an AWS environment, then you can directly use the AWS_ACCESS_KEY_ID and the AWS_SECRET_ACCESS_KEY provided to you directly as those will have the necessary permissions.

Set the AWS_ACCESS_KEY_ID and the AWS_SECRET_ACCESS_KEY environment variables to hold your AWS access key ID and secret, respectively.

**Run these commands:**
```bash
export AWS_ACCESS_KEY_ID=<aws_access_key_id>
export AWS_SECRET_ACCESS_KEY=<aws_secret_key>
```



**Run these commands:**
```bash
vault write aws/config/root access_key=$AWS_ACCESS_KEY_ID secret_key=$AWS_SECRET_ACCESS_KEY region=us-east-1
```

## Create a role

**Run these commands:**
```bash
vault write aws/roles/my-role \
        credential_type=iam_user \
        policy_document=-<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1426528957000",
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
```

Notice the AWS IAM policy above enables all actions on EC2, but not IAM or other AWS services.

## Generate the secret

You can ask Vault to generate an access key pair for that role by reading from aws/creds/:name, where :name corresponds to the name of an existing role:

**Run this command:**
```bash
vault read aws/creds/my-role
```

## Revoke the secret

**Run this command:**
```bash
vault lease revoke aws/creds/my-role/0bce0782-32aa-25ec-f61d-c026ff22106
```

> This concludes the AWS Secrets Engine Lab