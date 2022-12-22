resource "kubernetes_namespace" "functional-namespace" {
  for_each = toset(var.kubernetes_namespaces)

  metadata {
    name = each.key
  }
}