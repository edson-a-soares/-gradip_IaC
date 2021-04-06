resource "kubernetes_storage_class" "kube_sc" {

  depends_on = [aws_db_instance.wordpress_database]

  metadata {
    name = "generic"
  }

  parameters = {
    type = "gp2"
    zone: var.region
  }
  reclaim_policy      = "Retain"
  storage_provisioner = "kubernetes.io/aws-ebs"

}

resource "kubernetes_persistent_volume_claim" "wordpress_eks_cluster_pvc" {

  depends_on = [kubernetes_storage_class.kube_sc]

  metadata {
    name = "wp-pvc"
    labels = {
      app = "wp-frontend"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = kubernetes_storage_class.kube_sc.metadata.0.name
    resources {
      requests = {
        storage = "3Gi"
      }
    }
  }

}

