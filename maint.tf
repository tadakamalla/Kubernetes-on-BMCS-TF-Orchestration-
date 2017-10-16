provider "baremetal" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  private_key_password="${var.private_key_password}"
}

module "vcn" {
  source = "./modules/vcn"
  tenancy_ocid = "${var.tenancy_ocid}"
  compartment_ocid = "${var.compartment_ocid}"
  region = "${var.region}"
}
module "kubernetes-master" {
  AD="1"
  source = "./modules/compute-instance"
  tenancy_ocid = "${var.tenancy_ocid}"
  subnet_ocid = "${module.vcn.subnet1_ocid}"
  compartment_ocid = "${var.compartment_ocid}"
  ssh_public_key = "${file(var.ssh_public_key_path)}"  
  instance_name = "kube-master"
  InstanceOS = "${var.InstanceOS}"
  InstanceOSVersion = "${var.InstanceOSVersion}"
  region = "${var.region}"
}

module "kubernetes-minion1" {
  AD="2"
  source = "./modules/compute-instance"
  tenancy_ocid = "${var.tenancy_ocid}"
  subnet_ocid = "${module.vcn.subnet2_ocid}"
  compartment_ocid = "${var.compartment_ocid}"
  ssh_public_key = "${file(var.ssh_public_key_path)}"  
  instance_name = "kube-minion1"
  InstanceOS = "${var.InstanceOS}"
  InstanceOSVersion = "${var.InstanceOSVersion}"
  region = "${var.region}"
}
module "kubernetes-minion2" {
  AD="3"
  source = "./modules/compute-instance"
  tenancy_ocid = "${var.tenancy_ocid}"
  subnet_ocid = "${module.vcn.subnet3_ocid}"
  compartment_ocid = "${var.compartment_ocid}"
  ssh_public_key = "${file(var.ssh_public_key_path)}"  
  instance_name = "kube-minion2"
  InstanceOS = "${var.InstanceOS}"
  InstanceOSVersion = "${var.InstanceOSVersion}"
  region = "${var.region}"
}


module "kubernetes-config" {
    source = "./modules/kubernetes-config"
    tenancy_ocid = "${var.tenancy_ocid}"
    compartment_ocid = "${var.compartment_ocid}"
    master-public-ip = "${module.kubernetes-master.public_ip}"
    slave-1-public-ip = "${module.kubernetes-minion1.public_ip}"
    slave-2-public-ip = "${module.kubernetes-minion2.public_ip}"
    ssh_private_key_path = "${var.ssh_private_key_path}"
}

module "kubelb-config" {
    source = "./modules/kubelb-config"
    tenancy_ocid = "${var.tenancy_ocid}"
    compartment_ocid = "${var.compartment_ocid}"
    slave-1-private-ip = "${module.kubernetes-minion1.private_ip}"
    slave-2-private-ip = "${module.kubernetes-minion2.private_ip}"
    slave-1-subnet2-ocid = "${module.vcn.subnet2_ocid}"
    slave-2-subnet3-ocid = "${module.vcn.subnet3_ocid}"
    region = "${var.region}"
}



output "Kubernetes Master URL" {
  value = "http://${module.kubernetes-master.public_ip}:8080/api/v1/"
}


output "Load Balancer IP" {
  value = "http://${module.kubelb-config.lb_public_ip[0]}"
  }

output "Application URL on Node1" {
  value = "http://${module.kubernetes-minion1.public_ip}:31401"
}
output "Application URL on Node2" {
  value = "http://${module.kubernetes-minion2.public_ip}:31401"
}



