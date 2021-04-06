resource "kubernetes_deployment" "application_deployment" {

  // depends_on = [ kubernetes_persistent_volume_claim.wordpress_eks_cluster_pvc ]

  metadata {
    name = "application-deployment"
    labels = {
      app = "wp-frontend"
    }
  }

  spec {

    replicas = 2

    selector {
      match_labels = {
        app = "wp-frontend"
      }
    }

    template {

      metadata {
        labels = {
          app = "wp-frontend"
        }
      }

      # Spec for container
      spec {
//        volume {
//          name = "wordpress_persistent_storage"
//          persistent_volume_claim {
//            claim_name = kubernetes_persistent_volume_claim.wordpress_eks_cluster_pvc.metadata.0.name
//          }
//
//        }

        container {
          # Image to be used
          image = var.docker_image_version

          # Providing host, credentials and database name in environment variable
          env {
            name  = "WORDPRESS_DB_HOST"
            value = aws_db_instance.wordpress_database.address
          }
          env {
            name  = "WORDPRESS_DB_USER"
            value = aws_db_instance.wordpress_database.username
          }
          env {
            name  = "WORDPRESS_DB_PASSWORD"
            value = aws_db_instance.wordpress_database.password
          }
          env {
            name  = "WORDPRESS_DB_NAME"
            value = aws_db_instance.wordpress_database.name
          }

          name = "wp-container"
          port {
            container_port = 80
          }

          volume_mount {
            name       = "wordpress_persistent_storage"
            mount_path = "/var/www/html"
          }

        }

      }

    }

  }

}
