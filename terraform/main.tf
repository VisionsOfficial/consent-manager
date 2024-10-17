provider "kubernetes" {
  config_path = var.kubeconfig_path
}

resource "kubernetes_namespace" "consent_manager" {
  metadata {
    name = "consent-manager"
  }
}

resource "kubernetes_secret" "env_vars" {
  metadata {
    name      = "env-vars"
    namespace = kubernetes_namespace.consent_manager.metadata[0].name
  }

  data = {
    NODE_ENV                          = base64encode("development")
    PORT                              = base64encode("3000")
    APP_ENDPOINT                      = base64encode("http://localhost:3000")
    MONGO_URI                         = base64encode("mongodb://consent-manager-mongodb:27017/consent-manager")
    MONGO_URI_TEST                    = base64encode("mongodb://consent-manager-mongodb:27017/consent-manager-test")
    API_PREFIX                        = base64encode("/v1")
    SALT_ROUNDS                       = base64encode("10")
    PDI_ENDPOINT                      = base64encode("http://localhost:3331")
    APPLICATION_NAME                  = base64encode("consentmanager-pdi")
    FEDERATED_APPLICATION_IDENTIFIER  = base64encode("http://localhost:3000")
    SESSION_COOKIE_NAME               = base64encode("consentmanagersessid")
    SESSION_SECRET                    = base64encode("secret123")
    JWT_SECRET_KEY                    = base64encode("secret123")
    OAUTH_SECRET_KEY                  = base64encode("abc123secret")
    OAUTH_TOKEN_EXPIRES_IN            = base64encode("1h")
    CONTRACT_SERVICE_BASE_URL         = base64encode("http://localhost:3000/contracts")
    WINSTON_LOGS_MAX_FILES            = base64encode("14d")
    WINSTON_LOGS_MAX_SIZE             = base64encode("20m")
    NODEMAILER_HOST                   = base64encode("")
    NODEMAILER_PORT                   = base64encode("")
    NODEMAILER_USER                   = base64encode("abc@domain.com")
    NODEMAILER_PASS                   = base64encode("pass")
    NODEMAILER_FROM_NOREPLY           = base64encode("\"abc <abc@domain.com>\"")
    MANDRILL_ENABLED                  = base64encode("false")
    MANDRILL_API_KEY                  = base64encode("yourkey")
    MANDRILL_FROM_EMAIL               = base64encode("noreply@visionstrust.com")
    MANDRILL_FROM_NAME                = base64encode("noreply")
    PRIVACY_RIGHTS                    = base64encode("")
    WITHDRAWAL_METHOD                 = base64encode("")
    CODE_OF_CONDUCT                   = base64encode("")
    IMPACT_ASSESSMENT                 = base64encode("")
    AUTHORITY_PARTY                   = base64encode("")
  }
}

resource "kubernetes_deployment" "consent_manager" {
  metadata {
    name      = "consent-manager"
    namespace = kubernetes_namespace.consent_manager.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "consent-manager"
      }
    }

    template {
      metadata {
        labels = {
          app = "consent-manager"
        }
      }

      spec {
        container {
          image = "consent-manager:latest"
          name  = "consent-manager"

          port {
            container_port = var.port
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.env_vars.metadata[0].name
            }
          }

          volume_mount {
            mount_path = "/data/db"
            name       = "consent-data"
          }
        }

        container {
          image = "mongo:latest"
          name  = "mongodb"

          volume_mount {
            mount_path = "/data/db"
            name       = "consent-data"
          }
        }

        volume {
          name = "consent-data"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.mongo_data.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "consent_manager" {
  metadata {
    name      = "consent-manager"
    namespace = kubernetes_namespace.consent_manager.metadata[0].name
  }

  spec {
    selector = {
      app = "consent-manager"
    }

    port {
      port        = var.port
      target_port = var.port
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_persistent_volume" "mongo_data" {
  metadata {
    name = "mongo-data"
  }

  spec {
    capacity = {
      storage = "5Gi"
    }

    access_modes = ["ReadWriteOnce"]

    persistent_volume_reclaim_policy = "Retain"

    host_path {
      path = "/mnt/data"
    }
  }
}

resource "kubernetes_persistent_volume_claim" "mongo_data" {
  metadata {
    name      = "mongo-data"
    namespace = kubernetes_namespace.consent_manager.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}
