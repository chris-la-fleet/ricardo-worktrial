variable "create" {
  description = "Whether to create the distributed training Job"
  type        = bool
  default     = true
}

variable "name" {
  description = "Kubernetes Job name"
  type        = string
}

variable "namespace" {
  description = "Namespace where the Job will run"
  type        = string
  default     = "default"
}

variable "queue_name" {
  description = "Kueue LocalQueue name used for admission"
  type        = string
  default     = "default-queue"
}

variable "image" {
  description = "Container image for training workload"
  type        = string
}

variable "command" {
  description = "Entrypoint command list"
  type        = list(string)
  default     = []
}

variable "args" {
  description = "Command argument list"
  type        = list(string)
  default     = []
}

variable "env" {
  description = "Environment variables map"
  type        = map(string)
  default     = {}
}

variable "replicas" {
  description = "Number of pods for distributed training"
  type        = number
  default     = 1
}

variable "cpu" {
  description = "CPU request/limit for each pod"
  type        = string
  default     = "4"
}

variable "memory" {
  description = "Memory request/limit for each pod"
  type        = string
  default     = "16Gi"
}

variable "gpu_count" {
  description = "GPU request/limit for each pod (0 disables GPU requests)"
  type        = number
  default     = 0
}

variable "node_selector" {
  description = "Node selector for pod placement"
  type        = map(string)
  default     = {}
}

variable "tolerations" {
  description = "Pod tolerations"
  type = list(object({
    key      = optional(string)
    operator = optional(string)
    value    = optional(string)
    effect   = optional(string)
  }))
  default = []
}

variable "backoff_limit" {
  description = "Number of retries before marking Job failed"
  type        = number
  default     = 0
}

variable "ttl_seconds_after_finished" {
  description = "TTL for finished Job cleanup (seconds)"
  type        = number
  default     = 86400
}
