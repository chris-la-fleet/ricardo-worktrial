resource "helm_release" "kueue" {
  name             = "kueue"
  chart            = "oci://registry.k8s.io/kueue/charts/kueue"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true
  wait             = true
  timeout          = 600
  atomic           = true
  cleanup_on_fail  = true

  values = [
    yamlencode({
      integrations = {
        frameworks = [
          "batch/job",
          "ray.io/rayjob",
          "ray.io/raycluster",
        ]
      }
    })
  ]
}

# --- ResourceFlavor: CPU nodes ---
resource "kubernetes_manifest" "flavor_cpu" {
  depends_on = [helm_release.kueue]

  manifest = {
    apiVersion = "kueue.x-k8s.io/v1beta2"
    kind       = "ResourceFlavor"
    metadata = {
      name = "cpu"
    }
    spec = {
      nodeLabels = {
        (var.cpu_node_label_key) = var.cpu_node_label_value
      }
      tolerations = [
        {
          key      = "ray.io/node-type"
          operator = "Exists"
          effect   = "NoSchedule"
        },
      ]
    }
  }
}

# --- ResourceFlavor: GPU nodes ---
resource "kubernetes_manifest" "flavor_gpu" {
  depends_on = [helm_release.kueue]

  manifest = {
    apiVersion = "kueue.x-k8s.io/v1beta2"
    kind       = "ResourceFlavor"
    metadata = {
      name = "gpu"
    }
    spec = {
      nodeLabels = {
        (var.gpu_node_label_key) = var.gpu_node_label_value
      }
      tolerations = [
        {
          key      = "nvidia.com/gpu"
          operator = "Exists"
          effect   = "NoSchedule"
        },
        {
          key      = "ray.io/node-type"
          operator = "Exists"
          effect   = "NoSchedule"
        },
      ]
    }
  }
}

# --- ClusterQueue ---
resource "kubernetes_manifest" "cluster_queue" {
  depends_on = [
    kubernetes_manifest.flavor_cpu,
    kubernetes_manifest.flavor_gpu,
  ]

  manifest = {
    apiVersion = "kueue.x-k8s.io/v1beta2"
    kind       = "ClusterQueue"
    metadata = {
      name = var.cluster_queue_name
    }
    spec = {
      namespaceSelector = {}
      resourceGroups = [
        {
          coveredResources = ["cpu", "memory"]
          flavors = [
            {
              name = "cpu"
              resources = [
                {
                  name         = "cpu"
                  nominalQuota = var.cpu_quota
                },
                {
                  name         = "memory"
                  nominalQuota = var.memory_quota
                },
              ]
            },
          ]
        },
        {
          coveredResources = ["nvidia.com/gpu"]
          flavors = [
            {
              name = "gpu"
              resources = [
                {
                  name         = "nvidia.com/gpu"
                  nominalQuota = tostring(var.gpu_quota)
                },
              ]
            },
          ]
        },
      ]
    }
  }
}

# --- LocalQueue ---
resource "kubernetes_manifest" "local_queue" {
  depends_on = [kubernetes_manifest.cluster_queue]

  manifest = {
    apiVersion = "kueue.x-k8s.io/v1beta2"
    kind       = "LocalQueue"
    metadata = {
      name      = var.local_queue_name
      namespace = var.local_queue_namespace
    }
    spec = {
      clusterQueue = var.cluster_queue_name
    }
  }
}
