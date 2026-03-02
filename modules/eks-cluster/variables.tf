variable "region" {
  description = "AWS region. p5.48xlarge available in us-east-1, us-east-2, us-west-2."
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version. 1.32 is last with AL2 GPU AMI support."
  type        = string
  default     = "1.32"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of AZs for VPC subnets"
  type        = list(string)
}

variable "gpu_az" {
  description = "Single AZ for GPU placement group (EFA requires co-location)"
  type        = string
  default     = ""

  validation {
    condition     = var.gpu_az == "" || contains(var.availability_zones, var.gpu_az)
    error_message = "gpu_az must be empty or one of availability_zones."
  }
}

variable "public_access_cidrs" {
  description = "CIDRs allowed to access the EKS API endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "gpu_machine_type" {
  description = "Instance type for GPU workers"
  type        = string
  default     = "p5.48xlarge"
}

variable "enable_gpu_node_group" {
  description = "Whether to create the GPU worker node group"
  type        = bool
  default     = false
}

variable "gpu_desired_nodes" {
  description = "Desired number of GPU worker nodes"
  type        = number
  default     = 0
}

variable "gpu_min_nodes" {
  description = "Minimum number of GPU worker nodes"
  type        = number
  default     = 0
}

variable "gpu_max_nodes" {
  description = "Maximum number of GPU worker nodes"
  type        = number
  default     = 4
}

variable "cpu_worker_machine_type" {
  description = "Instance type for CPU workers"
  type        = string
  default     = "m5.4xlarge"
}

variable "cpu_worker_desired_nodes" {
  description = "Desired number of CPU worker nodes"
  type        = number
  default     = 0
}

variable "cpu_worker_min_nodes" {
  description = "Minimum number of CPU worker nodes"
  type        = number
  default     = 0
}

variable "cpu_worker_max_nodes" {
  description = "Maximum number of CPU worker nodes"
  type        = number
  default     = 8
}

variable "system_machine_type" {
  description = "Instance type for the system node group"
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

variable "enable_head_node_group" {
  description = "Whether to create the Ray head node group"
  type        = bool
  default     = false
}

variable "head_machine_type" {
  description = "Instance type for Ray head nodes"
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
