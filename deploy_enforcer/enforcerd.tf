resource "kubernetes_namespace" "aporeto" {
  metadata {
    annotations = {
      name = "enforcerd"
    }

    labels = {
      name = "enforcerd"
    }

    name = "aporeto"
  }
}

resource "kubernetes_service_account" "enforcerd" {
  metadata {
    name      = "enforcerd"
    namespace = "aporeto"
  }

  depends_on = [ kubernetes_namespace.aporeto ]
}

resource "kubernetes_cluster_role" "enforcerd" {
  metadata {
    name = "enforcerd"
  }

  rule {
    verbs      = ["get"]
    api_groups = [""]
    resources  = ["nodes"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["pods"]
  }

  rule {
    verbs      = ["create", "patch", "update"]
    api_groups = [""]
    resources  = ["events"]
  }

  depends_on = [ kubernetes_namespace.aporeto ]
}

resource "kubernetes_cluster_role_binding" "enforcerd" {
  metadata {
    name = "enforcerd"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "enforcerd"
    namespace = "aporeto"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "enforcerd"
  }

  depends_on = [ kubernetes_namespace.aporeto ]
}

resource "kubernetes_daemonset" "enforcerd" {
  metadata {
    name      = "enforcerd"
    namespace = "aporeto"

    labels = {
      app = "enforcerd"

      instance = "enforcerd"

      vendor = "aporeto"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "enforcerd"

        instance = "enforcerd"

        vendor = "aporeto"
      }
    }

    template {
      metadata {
        labels = {
          app = "enforcerd"

          instance = "enforcerd"

          vendor = "aporeto"
        }

        annotations = {
          "container.apparmor.security.beta.kubernetes.io/enforcerd" = "unconfined"
        }
      }

      spec {
        volume {
          name = "working-dir"

          host_path {
            path = "/var/lib/prisma-enforcer/enforcerd"
            type = "DirectoryOrCreate"
          }
        }

        volume {
          name = "cni-bin-dir"

          host_path {
            path = "/opt/cni/bin"
          }
        }

        volume {
          name = "cni-conf-dir"

          host_path {
            path = "/etc/cni/net.d"
          }
        }

        volume {
          name = "var-run"

          host_path {
            path = "/var/run"
          }
        }

        volume {
          name = "run"

          host_path {
            path = "/run"
          }
        }

        volume {
          name = "var-lib"

          host_path {
            path = "/var/lib"
          }
        }

        volume {
          name = "cgroups"

          host_path {
            path = "/sys/fs/cgroup"
          }
        }

        container {
          name    = "enforcerd"
          image   = var.cns_enforcerd_image
          command = ["/enforcerd"]
          args    = ["--tag=clustertype=${var.cns_enforcerd_clustertype}"]

          env {
            name  = "ENFORCERD_NAMESPACE"
            value = var.cns_namespace
          }

          env {
            name  = "ENFORCERD_API"
            value = var.cns_api
          }

          env {
            name  = "ENFORCERD_LOG_FORMAT"
            value = "json"
          }

          env {
            name  = "ENFORCERD_LOG_LEVEL"
            value = "info"
          }

          env {
            name  = "ENFORCERD_WORKING_DIR"
            value = "/var/lib/prisma-enforcer/enforcerd"
          }

          env {
            name  = "ENFORCERD_LOG_TO_CONSOLE"
            value = "true"
          }

          env {
            name  = "ENFORCERD_ENABLE_KUBERNETES"
            value = "true"
          }

          env {
            name  = "ENFORCERD_TRANSMITTER_QUEUE_COUNT"
            value = "2"
          }

          env {
            name  = "ENFORCERD_RECEIVER_QUEUE_COUNT"
            value = "2"
          }

          env {
            name  = "ENFORCERD_FLOW_REPORTING_INTERVAL"
            value = "5m"
          }

          env {
            name  = "ENFORCERD_API_SKIP_VERIFY"
            value = "false"
          }

          env {
            name = "ENFORCERD_KUBENODE"

            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          env {
            name = "K8S_POD_NAME"

            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "K8S_POD_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name  = "ENFORCERD_ACTIVATE_KUBE_SYSTEM_PUS"
            value = "false"
          }

          env {
            name  = "ENFORCERD_ACTIVATE_OPENSHIFT_PUS"
            value = "false"
          }

          env {
            name  = "ENFORCERD_KUBERNETES_MONITOR_WORKERS"
            value = "4"
          }

          env {
            name  = "ENFORCERD_INSTALL_CNI_PLUGIN"
            value = var.cns_enforcerd_install_cni_plugin
          }

          env {
            name  = "ENFORCERD_INSTALL_RUNC_PROXY"
            value = var.cns_enforcerd_install_runc_proxy
          }

          env {
            name  = "ENFORCERD_CNI_BIN_DIR"
            value = var.cns_enforcerd_cni_bin_dir
          }

          env {
            name  = "ENFORCERD_CNI_CONF_DIR"
            value = var.cns_enforcerd_cni_conf_dir
          }

          env {
            name  = "ENFORCERD_CNI_CHAINED"
            value = "true"
          }

          env {
            name  = "ENFORCERD_CNI_MULTUS_DEFAULT_NETWORK"
            value = "false"
          }

          env {
            name  = "ENFORCERD_CNI_CONF_FILENAME"
            value = var.cns_enforcerd_cni_conf_filename
          }

          env {
            name  = "ENFORCERD_CNI_PRIMARY_CONF_FILE"
            value = var.cns_enforcerd_cni_primary_conf_file
          }

          volume_mount {
            name       = "working-dir"
            mount_path = "/var/lib/prisma-enforcer/enforcerd"
          }

          volume_mount {
            name       = "cni-bin-dir"
            mount_path = "/opt/cni/bin"
          }

          volume_mount {
            name       = "cni-conf-dir"
            mount_path = "/etc/cni/net.d"
          }

          volume_mount {
            name              = "var-run"
            mount_path        = "/var/run"
            mount_propagation = "HostToContainer"
          }

          volume_mount {
            name              = "run"
            mount_path        = "/run"
            mount_propagation = "HostToContainer"
          }

          volume_mount {
            name              = "var-lib"
            read_only         = true
            mount_path        = "/var/lib"
            mount_propagation = "HostToContainer"
          }

          volume_mount {
            name       = "cgroups"
            mount_path = "/sys/fs/cgroup"
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              add = ["KILL", "SYS_PTRACE", "NET_ADMIN", "NET_RAW", "SYS_RESOURCE", "SYS_ADMIN", "SYS_MODULE"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 600
        dns_policy                       = "ClusterFirstWithHostNet"
        service_account_name             = "enforcerd"
        host_network                     = true
        host_pid                         = true
      }
    }

    strategy {
      type = "RollingUpdate"
    }
  }

  depends_on = [ kubernetes_namespace.aporeto ]
}
