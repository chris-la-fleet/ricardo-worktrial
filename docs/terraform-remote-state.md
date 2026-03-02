# Terraform Remote State (S3 + Lockfile)

Use one shared S3 bucket for state and S3 native lockfile locking.

Set environment variables:

```bash
export AWS_REGION=us-west-2
export TF_STATE_BUCKET=replace-with-tf-state-bucket
```

Create the S3 bucket:

```bash
aws s3api create-bucket \
  --bucket "$TF_STATE_BUCKET" \
  --region "$AWS_REGION" \
  --create-bucket-configuration LocationConstraint="$AWS_REGION"
```

Enable bucket versioning:

```bash
aws s3api put-bucket-versioning \
  --bucket "$TF_STATE_BUCKET" \
  --versioning-configuration Status=Enabled
```

Enable default SSE-S3 encryption:

```bash
aws s3api put-bucket-encryption \
  --bucket "$TF_STATE_BUCKET" \
  --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
```

Block public access:

```bash
aws s3api put-public-access-block \
  --bucket "$TF_STATE_BUCKET" \
  --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
```

In your backend config (`backend.hcl`), set:

```hcl
bucket       = "your-state-bucket"
key          = "eks-dev/terraform.tfstate"
region       = "us-west-2"
encrypt      = true
use_lockfile = true
```
