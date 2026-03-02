locals {
  resolved_ray_image = var.ray_image != "" ? var.ray_image : "rayproject/ray:${var.ray_version}"
}

resource "kubernetes_manifest" "ray_cluster" {
  count = var.create ? 1 : 0

  manifest = {
    apiVersion = "ray.io/v1"
    kind       = "RayCluster"
    metadata = {
      name      = var.name
      namespace = var.namespace
      labels = {
        "kueue.x-k8s.io/queue-name" = var.kueue_queue_name
      }
    }
    spec = {
      rayVersion = var.ray_version
      headGroupSpec = {
        rayStartParams = {
          "dashboard-host" = "0.0.0.0"
        }
        template = {
          spec = {
            tolerations = [
              {
                key      = "ray.io/node-type"
                operator = "Equal"
                value    = "head"
                effect   = "NoSchedule"
              },
            ]
            nodeSelector = {
              "ray.io/node-type" = "head"
            }
            containers = [
              {
                name  = "ray-head"
                image = local.resolved_ray_image
                resources = {
                  requests = {
                    cpu    = var.head_cpu
                    memory = var.head_memory
                  }
                  limits = {
                    cpu    = var.head_cpu
                    memory = var.head_memory
                  }
                }
                ports = [
                  { containerPort = 6379, name = "gcs-server" },
                  { containerPort = 8265, name = "dashboard" },
                  { containerPort = 10001, name = "client" },
                ]
              },
            ]
          }
        }
      }
      workerGroupSpecs = concat(
        var.gpu_worker_replicas > 0 ? [
          {
            groupName      = "gpu-workers"
            replicas       = var.gpu_worker_replicas
            minReplicas    = var.gpu_worker_replicas
            maxReplicas    = var.gpu_worker_replicas
            rayStartParams = {}
            template = {
              spec = {
                tolerations = [
                  {
                    key      = "nvidia.com/gpu"
                    operator = "Exists"
                    effect   = "NoSchedule"
                  },
                  {
                    key      = "ray.io/node-type"
                    operator = "Equal"
                    value    = "worker"
                    effect   = "NoSchedule"
                  },
                ]
                nodeSelector = {
                  "ray.io/node-type" = "worker"
                  accelerator        = "h100"
                }
                containers = [
                  {
                    name  = "ray-worker"
                    image = local.resolved_ray_image
                    resources = {
                      requests = {
                        cpu              = var.gpu_worker_cpu
                        memory           = var.gpu_worker_memory
                        "nvidia.com/gpu" = tostring(var.gpu_worker_gpu_count)
                      }
                      limits = {
                        cpu              = var.gpu_worker_cpu
                        memory           = var.gpu_worker_memory
                        "nvidia.com/gpu" = tostring(var.gpu_worker_gpu_count)
                      }
                    }
                  },
                ]
              }
            }
          },
        ] : [],
        var.cpu_worker_replicas > 0 ? [
          {
            groupName      = "cpu-workers"
            replicas       = var.cpu_worker_replicas
            minReplicas    = var.cpu_worker_replicas
            maxReplicas    = var.cpu_worker_replicas
            rayStartParams = {}
            template = {
              spec = {
                tolerations = [
                  {
                    key      = "ray.io/node-type"
                    operator = "Equal"
                    value    = "worker"
                    effect   = "NoSchedule"
                  },
                ]
                nodeSelector = {
                  "ray.io/node-type" = "worker"
                  role               = "cpu-worker"
                }
                containers = [
                  {
                    name  = "ray-worker"
                    image = local.resolved_ray_image
                    resources = {
                      requests = {
                        cpu    = var.cpu_worker_cpu
                        memory = var.cpu_worker_memory
                      }
                      limits = {
                        cpu    = var.cpu_worker_cpu
                        memory = var.cpu_worker_memory
                      }
                    }
                  },
                ]
              }
            }
          },
        ] : [],
      )
    }
  }
}
