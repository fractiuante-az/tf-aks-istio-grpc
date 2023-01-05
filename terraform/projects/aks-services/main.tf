locals {
  dns_config = null
}

data "template_file" "cert_manager_values" {
  count = local.dns_config == null ? 1 : 0
  template = <<EOF
podLabels:
  aadpodidbinding: certman-label
serviceAccount:
  name: cert-manager
extraArgs:
  - --cluster-resource-namespace=commons
  - --dns01-recursive-nameservers-only
  - --dns01-recursive-nameservers=1.1.1.1:53,8.8.8.8:53
installCRDs: true
rbac:
  create: true
resources:
  requests:
    memory: 300Mi
    cpu: 300m
  limits:
    memory: 300Mi
    cpu: 300m
strategy:
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
  type: RollingUpdate
EOF
}

resource "kubernetes_namespace" "tools" {
  metadata {
    name = "tools"
  }
}

resource "helm_release" "cert_manager" {
  count = local.dns_config == null ? 1 : 0
  name  = "cert-manager"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.10.1"

  cleanup_on_fail = true
  namespace       = kubernetes_namespace.tools.metadata.0.name

  values = [data.template_file.cert_manager_values.0.rendered]
}
