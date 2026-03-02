variable "create" {
  description = "Whether to create the RayCluster resource"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of the RayCluster"
  type        = string
  default     = "default-ray-cluster"
}

variable "namespace" {
  description = "Namespace for the RayCluster"
  type        = string
  default     = "default"
}

variable "ray_version" {
  description = "Ray version for the container image"
  type        = string
  default     = "2.41.0"
}

variable "ray_image" {
  description = "Ray container image (overrides default rayproject/ray image)"
  type        = string
  default     = ""
}

variable "kueue_queue_name" {
  description = "Kueue LocalQueue name for gang scheduling"
  type        = string
  default     = "default-queue"
}

variable "head_cpu" {
  description = "CPU request/limit for head node"
  type        = string
  default     = "4"
}

variable "head_memory" {
  description = "Memory request/limit for head node"
  type        = string
  default     = "16Gi"
}

variable "gpu_worker_replicas" {
  description = "Number of GPU worker replicas"
  type        = number
  default     = 0
}

variable "gpu_worker_cpu" {
  description = "CPU request/limit per GPU worker"
  type        = string
  default     = "24"
}

variable "gpu_worker_memory" {
  description = "Memory request/limit per GPU worker"
  type        = string
  default     = "128Gi"
}

variable "gpu_worker_gpu_count" {
  description = "Number of GPUs per GPU worker"
  type        = number
  default     = 8
}

variable "cpu_worker_replicas" {
  description = "Number of CPU worker replicas"
  type        = number
  default     = 0
}

variable "cpu_worker_cpu" {
  description = "CPU request/limit per CPU worker"
  type        = string
  default     = "14"
}

variable "cpu_worker_memory" {
  description = "Memory request/limit per CPU worker"
  type        = string
  default     = "48Gi"
}
