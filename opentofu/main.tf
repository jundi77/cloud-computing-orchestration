provider "libvirt" {
    uri = var.libvirt_qemu_uri
}

# https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/pool
resource "libvirt_pool" "ubuntu_cluster" {
    name = "ubuntu_cluster"
    type = "dir"

    target {
        path = var.libvirt_images_path
    }
}

# https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/volume
resource "libvirt_volume" "ubuntu_img" {
    name    = "ubuntu_img"
    pool    = libvirt_pool.ubuntu_cluster.name
    source  = var.ubuntu_img_url
    format  = "qcow2"
}

# https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/volume
resource "libvirt_volume" "webserver_ubuntu_img" {
    name    = "webserver_ubuntu_img"
    pool    = libvirt_pool.ubuntu_cluster.name
    format  = "qcow2"

    base_volume_id = libvirt_volume.ubuntu_img.id
}


# https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/volume
resource "libvirt_volume" "db_ubuntu_img" {
    name    = "db_ubuntu_img"
    pool    = libvirt_pool.ubuntu_cluster.name
    size    = 8589934592 # in bytes, in gb = 8gb
    format  = "qcow2"
    
    base_volume_id = libvirt_volume.ubuntu_img.id
}

# https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/cloudinit
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/examples/v0.12/ubuntu/ubuntu-example.tf
resource "libvirt_cloudinit_disk" "webserver_commoninit" {
  name            = "webserver_commoninit.iso"
  pool            = libvirt_pool.ubuntu_cluster.name
  user_data       = data.template_file.webserver_user_data.rendered
}
data "template_file" "webserver_user_data" {
  template = file("${path.module}/../config/cloud-init/webserver/user-data")
}

# https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/cloudinit
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/examples/v0.12/ubuntu/ubuntu-example.tf
resource "libvirt_cloudinit_disk" "db_commoninit" {
  name            = "db_commoninit.iso"
  pool            = libvirt_pool.ubuntu_cluster.name
  user_data       = data.template_file.db_user_data.rendered
}
data "template_file" "db_user_data" {
  template = file("${path.module}/../config/cloud-init/db/user-data")
}

# https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/domain
resource "libvirt_domain" "webserver" {
    name      = var.webserver_vm_hostname
    memory    = 512
    vcpu      = 1
    cloudinit = libvirt_cloudinit_disk.webserver_commoninit.id

    network_interface {
        network_name    = "default"
        hostname        = var.webserver_vm_hostname
        wait_for_lease  = true
    }

    console {
        type        = "pty"
        target_port = 0
        target_type = "serial"
    }

    disk {
        volume_id = libvirt_volume.webserver_ubuntu_img.id
    }
}

# https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/domain
resource "libvirt_domain" "db" {
    name      = var.db_vm_hostname
    memory    = 4096
    vcpu      = 2
    cloudinit = libvirt_cloudinit_disk.db_commoninit.id

    network_interface {
        network_name    = "default"
        hostname        = var.db_vm_hostname
        wait_for_lease  = true
    }

    console {
        type        = "pty"
        target_port = 0
        target_type = "serial"
    }

    disk {
        volume_id = libvirt_volume.db_ubuntu_img.id
    }
}
