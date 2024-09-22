# resource "kubernetes_cluster_role_v1" "nginx-sa" {
#   metadata {
#     name = "nginx-sa"
#   }

#   rule {
#     api_groups = [""]
#     resources  = ["configmaps", "endpoints", "pods", "secrets", "nodes"]
#     verbs      = ["list", "watch"]
#   }

#   rule {
#     api_groups = [""]
#     resources  = ["nodes"]
#     verbs      = ["get"]
#   }

#   rule {
#     api_groups = [""]
#     resources  = ["services"]
#     verbs      = ["get", "list", "watch"]
#   }

#   rule {
#     api_groups = ["discovery.k8s.io"]
#     resources  = ["endpointslices"]
#     verbs      = ["get", "list", "watch"]
#   }

#   rule {
#     api_groups = ["networking.k8s.io"]
#     resources  = ["ingresses", "ingressclasses"]
#     verbs      = ["get", "list", "watch"]
#   }

#   rule {
#     api_groups = ["networking.k8s.io"]
#     resources  = ["ingresses/status"]
#     verbs      = ["update"]
#   }

#   rule {
#     api_groups = [""]
#     resources  = ["events"]
#     verbs      = ["create", "patch"]
#   }

#   rule {
#     api_groups = ["coordination.k8s.io"]
#     resources  = ["leases"]
#     verbs      = ["list", "watch"]
#   }
# }


# resource "kubernetes_role_v1" "nginx-sa" {
#   metadata {
#     name = "nginx-sa"
#   }  

#   rule {
#     api_groups = [""]
#     resources  = ["configmaps", "pods", "secrets"]
#     verbs      = ["get"]
#   }

#   rule {
#     api_groups = ["coordination.k8s.io"]
#     resources  = ["leases"]
#     resource_names = "ingress-controller-leader"
#     verbs      = ["create"]
# }
# }

# resource "kubernetes_cluster_role_binding_v1" "nginx-role-binding" {
#   depends_on = [ kubernetes_cluster_role_v1.nginx-role, kubernetes_service_account.nginx-sa ]
#   metadata {
#     name = "nginx-role-binding"
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "ClusterRole"
#     name      = "nginx-role"
#   }

#   subject {
#     kind      = "ServiceAccount"
#     name      = "nginx-sa"
#     namespace = "default"
#   }
# }
