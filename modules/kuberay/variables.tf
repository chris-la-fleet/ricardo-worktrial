variable "chart_version" {
  description = "KubeRay operator Helm chart version"
  type        = string
  default     = "1.5.1"
}

variable "namespace" {
  description = "Namespace for KubeRay operator"
  type        = string
  default     = "ray-system"
}
