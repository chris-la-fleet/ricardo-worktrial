locals {
  private_subnet_by_az = zipmap(var.availability_zones, module.vpc.private_subnets)
  gpu_subnet_id        = var.gpu_az != "" ? local.private_subnet_by_az[var.gpu_az] : module.vpc.private_subnets[0]
  autoscaler_tags = {
    "k8s.io/cluster-autoscaler/enabled"             = "true"
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
  }
}

# --- System node group ---
resource "aws_eks_node_group" "system" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-system"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = module.vpc.private_subnets
  ami_type        = "AL2_x86_64"
  instance_types  = [var.system_machine_type]
  disk_size       = 100
  capacity_type   = "ON_DEMAND"

  scaling_config {
    desired_size = var.system_desired_nodes
    min_size     = var.system_min_nodes
    max_size     = var.system_max_nodes
  }

  labels = {
    role = "system"
  }

  update_config {
    max_unavailable = 1
  }

  tags = local.autoscaler_tags

  depends_on = [
    aws_iam_role_policy_attachment.node_worker,
    aws_iam_role_policy_attachment.node_cni,
    aws_iam_role_policy_attachment.node_ecr,
    aws_iam_role_policy_attachment.node_ssm,
  ]
}

# --- Ray head node group ---
resource "aws_eks_node_group" "ray_head" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-ray-head"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = module.vpc.private_subnets
  ami_type        = "AL2_x86_64"
  instance_types  = [var.head_machine_type]
  disk_size       = 150
  capacity_type   = "ON_DEMAND"

  scaling_config {
    desired_size = var.head_desired_nodes
    min_size     = var.head_min_nodes
    max_size     = var.head_max_nodes
  }

  labels = {
    role               = "ray-head"
    "ray.io/node-type" = "head"
  }

  taint {
    key    = "ray.io/node-type"
    value  = "head"
    effect = "NO_SCHEDULE"
  }

  update_config {
    max_unavailable = 1
  }

  tags = local.autoscaler_tags

  depends_on = [
    aws_iam_role_policy_attachment.node_worker,
    aws_iam_role_policy_attachment.node_cni,
    aws_iam_role_policy_attachment.node_ecr,
    aws_iam_role_policy_attachment.node_ssm,
  ]
}

# --- CPU worker node group (scale-to-zero) ---
resource "aws_eks_node_group" "cpu_workers" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-cpu-workers"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = module.vpc.private_subnets
  ami_type        = "AL2_x86_64"
  instance_types  = [var.cpu_worker_machine_type]
  disk_size       = 200
  capacity_type   = "ON_DEMAND"

  scaling_config {
    desired_size = var.cpu_worker_desired_nodes
    min_size     = var.cpu_worker_min_nodes
    max_size     = var.cpu_worker_max_nodes
  }

  labels = {
    role               = "cpu-worker"
    "ray.io/node-type" = "worker"
  }

  taint {
    key    = "ray.io/node-type"
    value  = "worker"
    effect = "NO_SCHEDULE"
  }

  update_config {
    max_unavailable = 1
  }

  tags = local.autoscaler_tags

  depends_on = [
    aws_iam_role_policy_attachment.node_worker,
    aws_iam_role_policy_attachment.node_cni,
    aws_iam_role_policy_attachment.node_ecr,
    aws_iam_role_policy_attachment.node_ssm,
  ]
}

# --- GPU worker node group (scale-to-zero) ---
resource "aws_eks_node_group" "gpu_workers" {
  count = var.enable_gpu_node_group ? 1 : 0

  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-gpu-workers"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = [local.gpu_subnet_id]
  ami_type        = "AL2_x86_64_GPU"
  instance_types  = [var.gpu_machine_type]
  disk_size       = 500
  capacity_type   = "ON_DEMAND"

  scaling_config {
    desired_size = var.gpu_desired_nodes
    min_size     = var.gpu_min_nodes
    max_size     = var.gpu_max_nodes
  }

  labels = {
    role               = "gpu-worker"
    "ray.io/node-type" = "worker"
    accelerator        = "h100"
  }

  taint {
    key    = "nvidia.com/gpu"
    value  = "present"
    effect = "NO_SCHEDULE"
  }

  taint {
    key    = "ray.io/node-type"
    value  = "worker"
    effect = "NO_SCHEDULE"
  }

  update_config {
    max_unavailable = 1
  }

  tags = local.autoscaler_tags

  depends_on = [
    aws_iam_role_policy_attachment.node_worker,
    aws_iam_role_policy_attachment.node_cni,
    aws_iam_role_policy_attachment.node_ecr,
    aws_iam_role_policy_attachment.node_ssm,
  ]
}
