variable "region" {
  description = "AWS region for EKS"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "ray-eks-dev"
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.32"
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
  description = "GPU worker instance type"
  type        = string
  default     = "p5.48xlarge"
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
