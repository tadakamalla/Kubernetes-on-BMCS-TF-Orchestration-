resource "null_resource" "config_node_1" {
provisioner "file" {
        connection {
            host="${var.master-public-ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key_path)}"
            }
        source     = "userdata/"
        destination = "/tmp/"
      }
provisioner "remote-exec" {
 connection {
            host="${var.master-public-ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key_path)}"
            }

    inline = [
      "chmod +x /tmp/master_bootstrap.sh",
      "sudo /tmp/master_bootstrap.sh ",
    ]

  }

provisioner "file" {
        connection {
            host="${var.slave-1-public-ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key_path)}"
            }
        source     = "userdata/slave_bootstrap.sh"
        destination = "/tmp/slave_bootstrap.sh"
      }
provisioner "remote-exec" {
 connection {
            host="${var.slave-1-public-ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key_path)}"
            }

    inline = [
      "chmod +x /tmp/slave_bootstrap.sh",
      "sudo yum -y install flannel kubernetes",    
      "sudo sed -i 's|FLANNEL_ETCD_ENDPOINTS=\"http://127.0.0.1:2379\"|FLANNEL_ETCD_ENDPOINTS=\"http://${var.master-public-ip}:2379\"|'  /etc/sysconfig/flanneld",
     "sudo sed -i 's|KUBE_MASTER=\"--master=http://127.0.0.1:8080\"|KUBE_MASTER=\"--master=http://${var.master-public-ip}:8080\"|'  /etc/kubernetes/config",
"sudo sed -i 's/KUBELET_ADDRESS=\"--address=127.0.0.1\"/KUBELET_ADDRESS=\"--address=0.0.0.0\"/' /etc/kubernetes/kubelet",
"sudo sed -i 's/# KUBELET_PORT=\"--port=10250\"/KUBELET_PORT=\"--port=10250\"/'  /etc/kubernetes/kubelet",
"sudo sed -i 's/KUBELET_HOSTNAME=\"--hostname-override=127.0.0.1\"/KUBELET_HOSTNAME=\"--hostname-override=${var.slave-1-public-ip}\"/'  /etc/kubernetes/kubelet",
"sudo sed -i 's|KUBELET_API_SERVER=\"--api-servers=http://127.0.0.1:8080\"|KUBELET_API_SERVER=\"--api-servers=http://${var.master-public-ip}:8080\"|'  /etc/kubernetes/kubelet",
"sudo /tmp/slave_bootstrap.sh",


    ]

  }
provisioner "file" {
        connection {
            host="${var.slave-2-public-ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key_path)}"
            }
        source     = "userdata/slave_bootstrap.sh"
        destination = "/tmp/slave_bootstrap.sh"
      }
provisioner "remote-exec" {
 connection {
            host="${var.slave-2-public-ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key_path)}"
            }

    inline = [
      "chmod +x /tmp/slave_bootstrap.sh",
      "sudo yum -y install flannel kubernetes",    
      "sudo sed -i 's|FLANNEL_ETCD_ENDPOINTS=\"http://127.0.0.1:2379\"|FLANNEL_ETCD_ENDPOINTS=\"http://${var.master-public-ip}:2379\"|'  /etc/sysconfig/flanneld",
     "sudo sed -i 's|KUBE_MASTER=\"--master=http://127.0.0.1:8080\"|KUBE_MASTER=\"--master=http://${var.master-public-ip}:8080\"|'  /etc/kubernetes/config",
"sudo sed -i 's/KUBELET_ADDRESS=\"--address=127.0.0.1\"/KUBELET_ADDRESS=\"--address=0.0.0.0\"/' /etc/kubernetes/kubelet",
"sudo sed -i 's/# KUBELET_PORT=\"--port=10250\"/KUBELET_PORT=\"--port=10250\"/'  /etc/kubernetes/kubelet",
"sudo sed -i 's/KUBELET_HOSTNAME=\"--hostname-override=127.0.0.1\"/KUBELET_HOSTNAME=\"--hostname-override=${var.slave-2-public-ip}\"/'  /etc/kubernetes/kubelet",
"sudo sed -i 's|KUBELET_API_SERVER=\"--api-servers=http://127.0.0.1:8080\"|KUBELET_API_SERVER=\"--api-servers=http://${var.master-public-ip}:8080\"|'  /etc/kubernetes/kubelet",
"sudo /tmp/slave_bootstrap.sh",


    ]

  }
provisioner "remote-exec" {
 connection {
            host="${var.master-public-ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key_path)}"
            }

    inline = [
      "chmod +x /tmp/app_config.sh",
      "/tmp/app_config.sh",

    ]

  }




}
