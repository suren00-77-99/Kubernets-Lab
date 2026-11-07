# Modular AWS EKS with Terraform + GitHub Actions

This project creates and destroys an AWS EKS environment using reusable Terraform modules.

## Architecture

GitHub Actions
  -> GitHub OIDC
  -> AWS IAM role
  -> Terraform
  -> VPC
  -> IAM
  -> EKS cluster
  -> Managed node group

## Modules

- modules/vpc: VPC, public/private subnets, IGW, NAT gateways and route tables
- modules/iam: EKS cluster and node IAM roles/policies
- modules/eks: EKS control plane, managed node group and core add-ons

## Before first apply

1. Create an S3 bucket for Terraform state.
2. Replace `REPLACE_WITH_YOUR_TF_STATE_BUCKET` in `environments/dev/backend.tf`.
3. Configure GitHub OIDC and an AWS IAM role trusted by your repository.
4. Add the IAM role ARN as GitHub repository secret `AWS_ROLE_ARN`.
5. Review `environments/dev/terraform.tfvars`.
6. Verify `cluster_version` is supported in your AWS region.
7. Restrict `public_access_cidrs` to your IP instead of `0.0.0.0/0` for real use.

## Local deployment

```bash
cd environments/dev

terraform init
terraform fmt -recursive ../..
terraform validate
terraform plan
terraform apply

aws eks update-kubeconfig --region ap-south-1 --name dev-eks
kubectl get nodes
```

## Destroy

```bash
terraform plan -destroy
terraform destroy
```

Or use the GitHub Actions `workflow_dispatch` action `destroy`.

## GitHub Actions

- Pull request: format check, validate, plan
- Push to main: apply
- Manual workflow: plan, apply or destroy

For production, protect a GitHub Environment and require manual approval before apply/destroy.

## State

The project uses S3 remote state with `use_lockfile = true`.

Protect the state bucket with versioning, encryption, public-access blocking and least-privilege IAM.

## Cost warning

EKS and NAT gateways incur AWS charges. Destroy the dev environment when you finish testing.
