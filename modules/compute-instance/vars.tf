variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "subnet_ocid" {}
variable "ssh_public_key"{}
variable "instance_shape"{default= "VM.Standard1.1"}
variable "image_ocid" {default = "ocid1.image.oc1.iad.aaaaaaaajddos6sxjpjyaaqs6l7i7pph2xkphfadodeeyet3yoiumwseicda"}
variable "instance_name"{}
variable "AD" {
    default = "1"
}