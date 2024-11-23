variable "libvirt_images_path" {
    description = "path for libvirt images"
    default     = "/var/lib/libvirt/images" # default based on virsh pool-list
}

variable "libvirt_qemu_uri" {
    description = "QEMU uri used by libvirt provider"
    default     = "qemu:///system" # default local qemu
}

variable "ubuntu_img_url" {
    description = "os image that will be deployed"
#    default     = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
    default     = "../images/noble-server-cloudimg-amd64.img"
}

variable "webserver_vm_hostname" {
    description = "the deployed vm hostname"
    default     = "webserver-vm"
}

variable "db_vm_hostname" {
    description = "the deployed vm hostname"
    default     = "db-vm"
}
