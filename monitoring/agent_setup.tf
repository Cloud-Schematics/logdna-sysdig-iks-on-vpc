##############################################################################
# Sysdig instance
##############################################################################

module sysdig {
  source            = "../resource_data"
  use_data          = var.use_data
  name              = var.name
  service           = "sysdig-monitor"
  resource_group_id = var.resource_group_id
  end_points        = var.use_data ? null : var.end_points
  plan              = var.use_data ? null : var.monitor_plan
  ibm_region        = var.ibm_region
  tags              = var.use_data ? null : var.tags
}

##############################################################################


##############################################################################
# Create sysdig access key
##############################################################################

resource ibm_resource_key sysdig_secret {
  name                 = "${var.name}_monitor_key"
  role                 = var.sysdig_role
  resource_instance_id = module.sysdig.id
}

##############################################################################


##############################################################################
# Create sysdig agent service account 
##############################################################################

resource kubernetes_service_account sysdig_agent {
  metadata {
    name      = "sysdig-agent"
    namespace = "ibm-observe"
  }
  depends_on = [kubernetes_secret.copy_image_pull_secret, ibm_resource_key.sysdig_secret]
}

##############################################################################


##############################################################################
# Create Cluster Role and Binding
##############################################################################
resource kubernetes_cluster_role sysdig_agent {
  metadata {
    name = "sysdig-agent"
  }
  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = [
      "pods", 
      "replicationcontrollers", 
      "services", 
      "events", 
      "limitranges", 
      "namespaces", 
      "nodes", 
      "resourcequotas", 
      "persistentvolumes", 
      "persistentvolumeclaims", 
      "configmaps", 
      "secrets"
    ]
  }
  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["apps"]
    resources  = ["daemonsets", "deployments", "replicasets", "statefulsets"]
  }
  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
  }
  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["batch"]
    resources  = ["cronjobs", "jobs"]
  }
  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["extensions"]
    resources  = ["daemonsets", "deployments", "ingresses", "replicasets"]
  }
  depends_on = [kubernetes_service_account.sysdig_agent]
}
##############################################################################


##############################################################################
# Bind cluster role to agent account
##############################################################################

resource kubernetes_cluster_role_binding sysdig_agent {
  metadata {
    name = "sysdig-agent"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "sysdig-agent"
    namespace = "ibm-observe"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "sysdig-agent"
  }

  depends_on = ["kubernetes_cluster_role.sysdig_agent"]
}

##############################################################################


##############################################################################
# Create sysdig secret
##############################################################################

resource kubernetes_secret sysdig_agent {
  metadata {
    name      = "sysdig-agent"
    namespace = "ibm-observe"
  }
  data = {
    access-key = ibm_resource_key.sysdig_secret.credentials["Sysdig Access Key"]
  }
  type = "Opaque"

  depends_on = [kubernetes_cluster_role_binding.sysdig_agent]
}

##############################################################################


##############################################################################
# Add Configmap
##############################################################################

resource kubernetes_config_map sysdig_config_map {
  metadata {
    name      = "sysdig-agent"
    namespace = "ibm-observe"
    labels = {
      app = kubernetes_secret.sysdig_agent.metadata.0.name
    }
  }
  data = {
    "dragent.yaml" = <<YAML
    tags: "app:sysdig-agent"
    collector: "ingest.${var.sysdig_endpoint}.${var.ibm_region}.monitoring.cloud.ibm.com"
    collector_port: 6443
    ssl: true
    ssl_verify_certificate: true
    new_k8s: true
    k8s_cluster_name: "${var.cluster_name}"
    sysdig_capture_enabled: false
    YAML
  }


}

##############################################################################


##############################################################################
# Apply daemonset
##############################################################################

resource kubernetes_daemonset sysdig_agent {
  metadata {
    name      = "sysdig-agent"
    namespace = "ibm-observe"
    labels = {
      app = "sysdig-agent"
    }
  }
  spec {
    selector {
      match_labels = {
        app = "sysdig-agent"
      }
    }
    template {
      metadata {
        labels = {
          app = "sysdig-agent"
        }
      }
      spec {
        image_pull_secrets {
          name = "ibm-observe-icr-io"
        }
        volume {
          name = "osrel"
          host_path {
            path = "/etc/os-release"
            type = "FileOrCreate"
          }
        }
        volume {
          name = "dshm"
          empty_dir {
            medium = "Memory"
          }
        }
        volume {
          name = "dev-vol"
          host_path {
            path = "/dev"
          }
        }
        volume {
          name = "proc-vol"
          host_path {
            path = "/proc"
          }
        }
        volume {
          name = "boot-vol"
          host_path {
            path = "/boot"
          }
        }
        volume {
          name = "modules-vol"
          host_path {
            path = "/lib/modules"
          }
        }
        volume {
          name = "usr-vol"
          host_path {
            path = "/usr"
          }
        }
        volume {
          name = "run-vol"
          host_path {
            path = "/run"
          }
        }
        volume {
          name = "varrun-vol"
          host_path {
            path = "/var/run"
          }
        }
        volume {
          name = "sysdig-agent-config"
          config_map {
            name = "sysdig-agent"
          }
        }
        volume {
          name = "sysdig-agent-secrets"
          secret {
            secret_name = "sysdig-agent"
          }
        }
        container {
          name  = "sysdig-agent"
          image = var.sysdig_image
          resources {
            limits {
              cpu    = "2"
              memory = "1536Mi"
            }
            requests {
              cpu    = "600m"
              memory = "512Mi"
            }
          }
          volume_mount {
            name       = "dev-vol"
            mount_path = "/host/dev"
          }
          volume_mount {
            name       = "proc-vol"
            read_only  = true
            mount_path = "/host/proc"
          }
          volume_mount {
            name       = "boot-vol"
            read_only  = true
            mount_path = "/host/boot"
          }
          volume_mount {
            name       = "modules-vol"
            read_only  = true
            mount_path = "/host/lib/modules"
          }
          volume_mount {
            name       = "usr-vol"
            read_only  = true
            mount_path = "/host/usr"
          }
          volume_mount {
            name       = "run-vol"
            mount_path = "/host/run"
          }
          volume_mount {
            name       = "varrun-vol"
            mount_path = "/host/var/run"
          }
          volume_mount {
            name       = "dshm"
            mount_path = "/dev/shm"
          }
          volume_mount {
            name       = "sysdig-agent-config"
            mount_path = "/opt/draios/etc/kubernetes/config"
          }
          volume_mount {
            name       = "sysdig-agent-secrets"
            mount_path = "/opt/draios/etc/kubernetes/secrets"
          }
          volume_mount {
            name       = "osrel"
            read_only  = true
            mount_path = "/host/etc/os-release"
          }
          readiness_probe {
            exec {
              command = ["test", "-e", "/opt/draios/logs/running"]
            }
            initial_delay_seconds = 10
          }
          image_pull_policy = "Always"
          security_context {
            privileged = true
          }
        }
        termination_grace_period_seconds = 5
        dns_policy                       = "ClusterFirstWithHostNet"
        host_network                     = true
        host_pid                         = true
        toleration {
          key    = "node-role.kubernetes.io/master"
          effect = "NoSchedule"
        }
      }
    }
    strategy {
      type = "RollingUpdate"
    }
  }

  depends_on = [kubernetes_config_map.sysdig_config_map]
}

##############################################################################