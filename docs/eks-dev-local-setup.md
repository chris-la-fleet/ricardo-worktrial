# EKS Dev Local Setup Runbook

This runbook documents the exact local steps to provision the AWS-first stack in `environments/eks-dev`.

These terraform files are for infrastructure only. Data scientists should not submit training jobs via Terraform.

## 1) Prerequisites

- macOS with Homebrew
- AWS CLI v2
- Access to AWS account `416291743083`
- Logged in with `aws login`

## 2) Install Terraform

Install Terraform from the HashiCorp Homebrew tap.

```bash
brew tap hashicorp/tap
brew uninstall terraform || true
brew install hashicorp/tap/terraform
terraform -version
```

Expected: Terraform `>= 1.9` (we used `1.14.6`).

## 3) Verify AWS authentication

```bash
aws sts get-caller-identity
```

Expected output includes:
- `Account: 416291743083`
- `Arn: arn:aws:iam::416291743083:user/worktrial-ricardo`

## 4) Configure `eks-dev` variables

From repo root:

```bash
cp -n environments/eks-dev/terraform.tfvars.example environments/eks-dev/terraform.tfvars
```

Review and adjust values in `environments/eks-dev/terraform.tfvars`:
- `region`
- `availability_zones`
- `public_access_cidrs`
- Keep CPU-first defaults unless needed:
  - `enable_gpu_node_group = false`
  - `enable_head_node_group = false`
  - `enable_kuberay = false`

## 5) Initialize and validate Terraform

```bash
cd environments/eks-dev
terraform init
terraform validate
```

## 6) Bootstrap apply (cluster first)

Because `module.kueue` uses `kubernetes_manifest`, a full first-time plan fails before the cluster exists.
Bootstrap with a targeted EKS plan/apply:

```bash
terraform plan -target=module.eks_cluster -out tfplan.eks
terraform apply -auto-approve tfplan.eks
```

This creates the VPC/EKS/node groups first.

## 7) Configure kubeconfig

After EKS is created:

```bash
aws eks update-kubeconfig --region us-west-2 --name k8s-dev
kubectl get nodes
```

## 8) Full stack plan and apply

Now that Kubernetes API is reachable, apply the full infra stack:

```bash
terraform plan -out tfplan
terraform apply -auto-approve tfplan
```

This should install:
- Kueue (`module.kueue`)
- Optional KubeRay only if `enable_kuberay = true`

## 9) Post-apply checks

```bash
kubectl get pods -n kueue-system
kubectl get clusterqueue
kubectl get localqueue -A
```

If enabled:

```bash
kubectl get pods -n ray-system
```

## 10) Job submission model in this phase

- Terraform is only for platform infrastructure.
- User jobs should be submitted through Kubernetes-native manifests (for example via `kubectl apply`) in a later workflow.
- Kustomize/API/UI job submission ergonomics are explicitly deferred to a later phase.
