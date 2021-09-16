variable "vpc_name" { }

variable "region" { }

variable "AllowedSourceIPRange" { }

variable "cluster_name" { }

variable "vmSize" { }

variable "vpc_cidr" {
    default = "10.10.0.0/16"
}

variable "service_cidr" {
    default = "172.18.0.0/16"
}

variable "kubernetes_version" { }
