variable "cns_api" {}

variable "cns_namespace" {}

variable "cns_enforcerd_clustertype" {
    default = "eks"
}

variable "cns_enforcerd_image" {}

variable "cns_enforcerd_cni_bin_dir" {}

variable "cns_enforcerd_cni_conf_dir" {}

variable "cns_enforcerd_install_cni_plugin" {
    default = ""
}

variable "cns_enforcerd_install_runc_proxy" {
    default = ""
}

variable "cns_enforcerd_cni_conf_filename" {
    default = ""
}

variable "cns_enforcerd_cni_primary_conf_file" {
    default = ""
}
