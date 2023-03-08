resource "kubernetes_deployment" "FASTAPI-test" {
  metadata {
    name = "fastapi-test"
    labels = {
      nome = "fastapi"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        nome = "fastapi"
      }
    }

    template {
      metadata {
        labels = {
          nome = "fastapi"
        }
      }

      spec {
        container {
          image = "yourimage"
          name  = "fastapi"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }

            initial_delay_seconds = 300
            period_seconds        = 30
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "LoadBalancer" {
  metadata {
    name = "load-balancer-fast-api"
  }
  spec {
    selector = {
      nome = "fastapi"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}

data "kubernetes_service" "nameDNS" { 
  metadata {
    name = "fastapi-test"
    
  }
}

output "URL" {
  value = data.kubernetes_service.nameDNS.status
}