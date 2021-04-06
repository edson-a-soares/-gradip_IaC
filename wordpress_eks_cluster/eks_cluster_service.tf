resource "kubernetes_service" "wordpress_eks_cluster_service" {

  depends_on = [kubernetes_deployment.application_deployment]

  metadata {
    name = "wp-service"
    labels = {
      app = "wp-frontend"
    }
  }

  spec {
    selector = {
      app = "wp-frontend"
    }
    port {
      port = 80
    }
    type = "LoadBalancer"
  }

}
