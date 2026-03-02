locals {
  env_list = [
    for k, v in var.env : {
      name  = k
      value = v
    }
  ]

  resource_requests = merge(
    {
      cpu    = var.cpu
      memory = var.memory
    },
    var.gpu_count > 0 ? { "nvidia.com/gpu" = tostring(var.gpu_count) } : {},
  )
}

resource "kubernetes_manifest" "job" {
  count = var.create ? 1 : 0

  manifest = {
    apiVersion = "batch/v1"
    kind       = "Job"
    metadata = {
      name      = var.name
      namespace = var.namespace
      labels = {
        "kueue.x-k8s.io/queue-name" = var.queue_name
      }
    }
    spec = {
      suspend                 = true
      completions             = var.replicas
      parallelism             = var.replicas
      completionMode          = "Indexed"
      backoffLimit            = var.backoff_limit
      ttlSecondsAfterFinished = var.ttl_seconds_after_finished
      template = {
        metadata = {
          labels = {
            app = var.name
          }
        }
        spec = {
          restartPolicy = "Never"
          nodeSelector  = var.node_selector
          tolerations   = var.tolerations
          containers = [
            {
              name    = "trainer"
              image   = var.image
              command = var.command
              args    = var.args
              env     = local.env_list
              resources = {
                requests = local.resource_requests
                limits   = local.resource_requests
              }
            },
          ]
        }
      }
    }
  }
}

output "name" {
  description = "Created distributed Job name"
  value       = var.name
}
