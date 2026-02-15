terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"  # Minikube config
}

resource "kubernetes_deployment" "my_web_app" {
  metadata {
    name = "my-web-app"
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "web"
      }
    }
    template {
      metadata {
        labels = {
          app = "web"
        }
      }
      spec {
        container {
          image = "my-web-app:latest"  # Or remote
          name  = "web"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "my_web_service" {
  metadata {
    name = "my-web-service"
  }
  spec {
    selector = {
      app = "web"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}
