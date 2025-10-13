resource "helm_release" "metrics_server" {

  name       = "metrics-server"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.11.0"

  set {
    name  = "args"
    value = "{--kubelet-insecure-tls}"
  }
}
