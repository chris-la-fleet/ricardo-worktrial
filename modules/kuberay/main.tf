resource "helm_release" "kuberay_operator" {
  name             = "kuberay-operator"
  repository       = "https://ray-project.github.io/kuberay-helm/"
  chart            = "kuberay-operator"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true
  wait             = true
  timeout          = 600
  atomic           = true
  cleanup_on_fail  = true

  values = [
    yamlencode({
      image = {
        tag = "v${var.chart_version}"
      }
      leaderElectionEnabled = true
      resources = {
        limits = {
          cpu    = "200m"
          memory = "1Gi"
        }
      }
    })
  ]
}
