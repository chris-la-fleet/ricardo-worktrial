variable "chart_version" {
  description = "Kueue Helm chart version"
  type        = string
  default     = "0.16.2"
}

variable "namespace" {
  description = "Namespace for Kueue controller"
  type        = string
  default     = "kueue-system"
}

variable "gpu_quota" {
  description = "Total GPU quota (nvidia.com/gpu) for the ClusterQueue"
  type        = number
  default     = 0
}

variable "cpu_quota" {
  description = "Total CPU quota for the CPU flavor"
  type        = string
  default     = "256"
}

variable "memory_quota" {
  description = "Total memory quota for the CPU flavor"
  type        = string
  default     = "1Ti"
}

variable "gpu_node_label_key" {
  description = "Node label key to select GPU nodes for the ResourceFlavor"
  type        = string
  default     = "accelerator"
}

variable "gpu_node_label_value" {
  description = "Node label value to select GPU nodes for the ResourceFlavor"
  type        = string
  default     = "gpu-t4"
}

variable "cpu_node_label_key" {
  description = "Node label key to select CPU nodes for the ResourceFlavor"
  type        = string
  default     = "role"
}

variable "cpu_node_label_value" {
  description = "Node label value to select CPU nodes for the ResourceFlavor"
  type        = string
  default     = "cpu-worker"
}

variable "cluster_queue_name" {
  description = "Name of the Kueue ClusterQueue"
  type        = string
  default     = "default-cluster-queue"
}

variable "local_queue_name" {
  description = "Name of the Kueue LocalQueue"
  type        = string
  default     = "default-queue"
}

variable "local_queue_namespace" {
  description = "Namespace for the default LocalQueue"
  type        = string
  default     = "default"
}
