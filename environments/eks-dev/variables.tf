variable "region" {
  description = "AWS region for EKS"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "k8s-dev"
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.35"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones for EKS subnets"
  type        = list(string)
}

variable "public_access_cidrs" {
  description = "CIDRs allowed to access the EKS API endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_gpu_node_group" {
  description = "Whether to create the GPU worker node group"
  type        = bool
  default     = false
}

variable "gpu_az" {
  description = "Single AZ for the GPU node group"
  type        = string
  default     = ""
}

variable "gpu_machine_type" {
  description = "GPU worker instance type (for example p5.48xlarge for gpu-h100 or g4dn.xlarge for gpu-t4)"
  type        = string
  default     = "g4dn.xlarge"
}

variable "gpu_node_label_key" {
  description = "Node label key for GPU workers"
  type        = string
  default     = "accelerator"
}

variable "gpu_node_label_value" {
  description = "Node label value for GPU workers (for example gpu-h100 or gpu-t4)"
  type        = string
  default     = "gpu-t4"
}

variable "gpu_desired_nodes" {
  description = "Desired number of GPU workers"
  type        = number
  default     = 0
}

variable "gpu_min_nodes" {
  description = "Minimum number of GPU workers"
  type        = number
  default     = 0
}

variable "gpu_max_nodes" {
  description = "Maximum number of GPU workers"
  type        = number
  default     = 4
}

variable "cpu_worker_machine_type" {
  description = "CPU worker instance type"
  type        = string
  default     = "m5.4xlarge"
}

variable "cpu_worker_desired_nodes" {
  description = "Desired number of CPU workers"
  type        = number
  default     = 0
}

variable "cpu_worker_min_nodes" {
  description = "Minimum number of CPU workers"
  type        = number
  default     = 0
}

variable "cpu_worker_max_nodes" {
  description = "Maximum number of CPU workers"
  type        = number
  default     = 8
}

variable "system_machine_type" {
  description = "System node group instance type"
  type        = string
  default     = "m5.xlarge"
}

variable "system_desired_nodes" {
  description = "Desired number of system nodes"
  type        = number
  default     = 1
}

variable "system_min_nodes" {
  description = "Minimum number of system nodes"
  type        = number
  default     = 1
}

variable "system_max_nodes" {
  description = "Maximum number of system nodes"
  type        = number
  default     = 2
}

variable "system_ami_type" {
  description = "System node group AMI family"
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "enable_head_node_group" {
  description = "Whether to create the Ray head node group"
  type        = bool
  default     = false
}

variable "head_machine_type" {
  description = "Ray head node group instance type"
  type        = string
  default     = "m5.2xlarge"
}

variable "head_desired_nodes" {
  description = "Desired number of Ray head nodes"
  type        = number
  default     = 1
}

variable "head_min_nodes" {
  description = "Minimum number of Ray head nodes"
  type        = number
  default     = 1
}

variable "head_max_nodes" {
  description = "Maximum number of Ray head nodes"
  type        = number
  default     = 2
}

variable "head_ami_type" {
  description = "Ray head node group AMI family"
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "cpu_worker_ami_type" {
  description = "CPU worker node group AMI family"
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "gpu_ami_type" {
  description = "GPU worker node group AMI family"
  type        = string
  default     = "AL2023_x86_64_NVIDIA"
}

variable "enable_kuberay" {
  description = "Whether to install the optional KubeRay operator"
  type        = bool
  default     = false
}

variable "kuberay_namespace" {
  description = "Namespace for KubeRay operator"
  type        = string
  default     = "ray-system"
}

variable "kueue_namespace" {
  description = "Namespace for Kueue controller"
  type        = string
  default     = "kueue-system"
}

variable "kueue_local_queue_namespace" {
  description = "Namespace for default Kueue LocalQueue"
  type        = string
  default     = "default"
}

variable "kueue_local_queue_name" {
  description = "Default Kueue LocalQueue name"
  type        = string
  default     = "default-queue"
}

variable "kueue_cluster_queue_name" {
  description = "Default Kueue ClusterQueue name"
  type        = string
  default     = "default-cluster-queue"
}

variable "kueue_gpu_quota" {
  description = "GPU quota configured in Kueue ClusterQueue"
  type        = number
  default     = 0
}

variable "enable_ray_cluster" {
  description = "Whether to create an optional RayCluster for infra-only wiring"
  type        = bool
  default     = false
}

variable "ray_cluster_name" {
  description = "RayCluster name used for infra-only wiring"
  type        = string
  default     = "default-ray-cluster"
}

variable "ray_cluster_namespace" {
  description = "Namespace where the RayCluster will be created"
  type        = string
  default     = "default"
}

variable "ray_cluster_ray_version" {
  description = "Ray version for the optional RayCluster"
  type        = string
  default     = "2.41.0"
}

variable "ray_cluster_ray_image" {
  description = "Optional Ray image override for the RayCluster (empty uses module default)"
  type        = string
  default     = ""
}

variable "ray_cluster_queue_name" {
  description = "Kueue LocalQueue name used by the RayCluster"
  type        = string
  default     = "default-queue"
}

variable "ray_cluster_head_cpu" {
  description = "CPU request for the RayCluster head pod"
  type        = string
  default     = "4"
}

variable "ray_cluster_head_memory" {
  description = "Memory request for the RayCluster head pod"
  type        = string
  default     = "16Gi"
}

variable "ray_cluster_cpu_worker_replicas" {
  description = "Number of RayCluster CPU worker replicas"
  type        = number
  default     = 0
}

variable "ray_cluster_cpu_worker_cpu" {
  description = "CPU request for each RayCluster CPU worker"
  type        = string
  default     = "14"
}

variable "ray_cluster_cpu_worker_memory" {
  description = "Memory request for each RayCluster CPU worker"
  type        = string
  default     = "48Gi"
}

variable "ray_cluster_cpu_worker_label_key" {
  description = "Node selector label key for RayCluster CPU workers"
  type        = string
  default     = "role"
}

variable "ray_cluster_cpu_worker_label_value" {
  description = "Node selector label value for RayCluster CPU workers"
  type        = string
  default     = "cpu-worker"
}

variable "ray_cluster_gpu_worker_replicas" {
  description = "Number of RayCluster GPU worker replicas"
  type        = number
  default     = 0
}

variable "ray_cluster_gpu_worker_cpu" {
  description = "CPU request for each RayCluster GPU worker"
  type        = string
  default     = "24"
}

variable "ray_cluster_gpu_worker_memory" {
  description = "Memory request for each RayCluster GPU worker"
  type        = string
  default     = "128Gi"
}

variable "ray_cluster_gpu_worker_gpu_count" {
  description = "GPU count for each RayCluster GPU worker"
  type        = number
  default     = 8
}

variable "ray_cluster_gpu_worker_label_key" {
  description = "Node selector label key for RayCluster GPU workers"
  type        = string
  default     = "accelerator"
}

variable "ray_cluster_gpu_worker_label_value" {
  description = "Node selector label value for RayCluster GPU workers"
  type        = string
  default     = "gpu-t4"
}
