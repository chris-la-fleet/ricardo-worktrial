provider "aws" {
  region = var.region
}

module "eks_cluster" {
  source = "../../modules/eks-cluster"

  region              = var.region
  cluster_name        = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  public_access_cidrs = var.public_access_cidrs

  system_machine_type  = var.system_machine_type
  system_desired_nodes = var.system_desired_nodes
  system_min_nodes     = var.system_min_nodes
  system_max_nodes     = var.system_max_nodes
  system_ami_type      = var.system_ami_type

  enable_head_node_group = var.enable_head_node_group
  head_machine_type      = var.head_machine_type
  head_desired_nodes     = var.head_desired_nodes
  head_min_nodes         = var.head_min_nodes
  head_max_nodes         = var.head_max_nodes
  head_ami_type          = var.head_ami_type

  cpu_worker_machine_type  = var.cpu_worker_machine_type
  cpu_worker_desired_nodes = var.cpu_worker_desired_nodes
  cpu_worker_min_nodes     = var.cpu_worker_min_nodes
  cpu_worker_max_nodes     = var.cpu_worker_max_nodes
  cpu_worker_ami_type      = var.cpu_worker_ami_type

  enable_gpu_node_group = var.enable_gpu_node_group
  gpu_az                = var.gpu_az
  gpu_machine_type      = var.gpu_machine_type
  gpu_node_label_key    = var.gpu_node_label_key
  gpu_node_label_value  = var.gpu_node_label_value
  gpu_desired_nodes     = var.gpu_desired_nodes
  gpu_min_nodes         = var.gpu_min_nodes
  gpu_max_nodes         = var.gpu_max_nodes
  gpu_ami_type          = var.gpu_ami_type
}

data "aws_eks_cluster" "selected" {
  name       = module.eks_cluster.cluster_name
  depends_on = [module.eks_cluster]
}

data "aws_eks_cluster_auth" "selected" {
  name       = module.eks_cluster.cluster_name
  depends_on = [module.eks_cluster]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.selected.endpoint
  token                  = data.aws_eks_cluster_auth.selected.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.selected.certificate_authority[0].data)
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.selected.endpoint
    token                  = data.aws_eks_cluster_auth.selected.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.selected.certificate_authority[0].data)
  }
}

module "kueue" {
  source = "../../modules/kueue"

  namespace             = var.kueue_namespace
  gpu_quota             = var.kueue_gpu_quota
  gpu_node_label_key    = var.gpu_node_label_key
  gpu_node_label_value  = var.gpu_node_label_value
  local_queue_namespace = var.kueue_local_queue_namespace
  local_queue_name      = var.kueue_local_queue_name
  cluster_queue_name    = var.kueue_cluster_queue_name

  depends_on = [module.eks_cluster]
}

module "kuberay" {
  count  = var.enable_kuberay ? 1 : 0
  source = "../../modules/kuberay"

  namespace = var.kuberay_namespace

  depends_on = [module.eks_cluster]
}
