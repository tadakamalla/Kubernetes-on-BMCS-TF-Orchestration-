provider "baremetal"{
region="us-phoenix-1"
}
resource "baremetal_load_balancer" "kubelb" {
  shape          = "100Mbps"
  compartment_id = "${var.compartment_ocid}"
  subnet_ids     = ["${var.slave-1-subnet2-ocid}","${var.slave-2-subnet3-ocid}"]
  display_name   = "kubelb"
}

resource "baremetal_load_balancer_backendset" "lb-bes1" {
  name             = "lb-bes1"
  load_balancer_id = "${baremetal_load_balancer.kubelb.id}"
  policy           = "ROUND_ROBIN"

  health_checker {
    port     = "31401"
    protocol = "HTTP"
    response_body_regex = ""
    url_path = "/"
  }
}
resource "baremetal_load_balancer_listener" "lb-listener1" {
  load_balancer_id         = "${baremetal_load_balancer.kubelb.id}"
  name                     = "http"
  default_backend_set_name = "${baremetal_load_balancer_backendset.lb-bes1.id}"
  port                     = 80
  protocol                 = "HTTP"
}

resource "baremetal_load_balancer_backend" "lb-be1" {
  load_balancer_id = "${baremetal_load_balancer.kubelb.id}"
  backendset_name  = "${baremetal_load_balancer_backendset.lb-bes1.id}"
  ip_address       = "${var.slave-1-private-ip}"
  port             = 31401
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

resource "baremetal_load_balancer_backend" "lb-be2" {
  load_balancer_id = "${baremetal_load_balancer.kubelb.id}"
  backendset_name  = "${baremetal_load_balancer_backendset.lb-bes1.id}"
  ip_address       = "${var.slave-2-private-ip}"
  port             = 31401
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}


output "lb_public_ip" {
  value = ["${baremetal_load_balancer.kubelb.ip_addresses}"]
}
