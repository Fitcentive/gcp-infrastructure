terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

resource "kubernetes_namespace" "cert-manager-namespace" {
  metadata {
    name = var.chart_namespace
  }
}

resource "helm_release" "cert-manager" {
  name       = var.release_name
  chart      = var.chart_name
  repository = var.chart_repository
  version    = var.chart_version
  namespace  = var.chart_namespace

  max_history = var.max_history
  timeout     = var.chart_timeout

  values = [
    templatefile("${path.module}/resources/custom_CertManager.yaml", {
      PSP_ENABLE         = var.psp_enable,
      PSP_APPARMOR       = var.psp_apparmor,
      INSTALL_CRDS       = var.install_crds
      PROMETHEUS_ENABLED = var.prometheus_enabled
    }),
  ]

  depends_on = [
    kubernetes_namespace.cert-manager-namespace
  ]
}

# Note - YAML not in separate file so that ssl policy can be interpolated in TF
resource "kubectl_manifest" "cert-manager-cluster-issuer" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-cluster-issuer
spec:
  acme:
    email: vdhysgr@gmail.com
    # ACME server URL for Let’s Encrypt’s staging environment.
    # The staging environment will not issue trusted certificates but is
    # used to ensure that the verification process is working properly
    # before moving to production
    # server:      https://acme-staging-v02.api.letsencrypt.org/directory  # < use this staging issuer when testing to avoid hitting rate limits on prod (50 per week).
    # prod-server: https://acme-v02.api.letsencrypt.org/directory  # < use this staging issuer when testing to avoid hitting rate limits on prod (50 per week).
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      # Secret resource used to store the account's private key.
      name: cluster-issuer-account-key
    # Enable the HTTP-01 challenge provider
    # you prove ownership of a domain by ensuring that a particular
    # file is present at the domain
    solvers:
    - http01:
        ingress:
          class: nginx

YAML

  depends_on = [
    helm_release.cert-manager
  ]
}