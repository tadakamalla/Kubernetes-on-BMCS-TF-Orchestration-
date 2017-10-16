provider "baremetal"{
region="${var.region}"
}
resource "baremetal_core_instance" "compute_instance" {
  availability_domain="${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "${var.instance_name}"
  #image_id = "${lookup(data.bmc_resources.images, var.image_name)}"
  #image = "${var.image_ocid}"
  image = "${lookup(data.baremetal_core_images.OLImageOCID.images[0], "id")}"
  shape = "${var.instance_shape}"
  subnet_id = "${var.subnet_ocid}"
  metadata {
         ssh_authorized_keys = "${var.ssh_public_key}"
}

}
