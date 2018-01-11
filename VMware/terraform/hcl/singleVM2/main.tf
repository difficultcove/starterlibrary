##################### Variables ###############################

variable "name" {
	description = "Name of the Virtual Machine"
}

variable "folder" {
	description = "Target vSphere folder for Virtual Machine"
	default = "CAM"
}

variable "datacenter" {
	description = "Target vSphere datacenter for Virtual Machine creation"
	default = "isstlab"
}

variable "vcpu" {
	description = "Number of Virtual CPU for the Virtual Machine"
	default = 1
}

variable "memory" {
	description = "Memory for Virtual Machine in MBs"
	default = 1024
}

variable "cluster" {
	description = "Target vSphere Cluster to host the Virtual Machine"
	default = "underground"
}

variable "network_label" {
	description = "vSphere Port Group or Network label for Virtual Machine's vNIC"
	default = "VLAB_MGMT_0019"
}

variable "ipv4_address" {
	description = "IPv4 address for vNIC configuration"
}

variable "ipv4_gateway" {
	description = "IPv4 gateway for vNIC configuration"
}

variable "ipv4_prefix_length" {
	description = "IPv4 Prefix length for vNIC configuration"
}

variable "storage" {
	description = "Data store or storage cluster name for target VMs disks"
	default = "cluster01/ESX6-volume-01"
}

variable "vm_template" {
	description = "Source VM or Template label for cloning"
	default = "vt-w8str2sp1-64"
}

variable "create_vm_folder" {
	description = "A vSphere folder need to be create or it is precreated"
	default = 0
}

variable "allow_selfsigned_cert" {
    description = "Communication with vsphere server with self signed certificate"
    default = true
}

############### Optinal settings in provider ##########
provider "vsphere" {
    allow_unverified_ssl = "${var.allow_selfsigned_cert}"
}


################## Resources ###############################

#
# Create vSphere folder for the Virtual Machine
#
resource "vsphere_folder" "folder_vm_1" {
  count = "${var.create_vm_folder}"
  path = "${var.folder}"
  datacenter = "${var.datacenter}"
}


#
# Create VM with single vnic on a network label by cloning
#
resource "vsphere_virtual_machine" "vm_1" {
  depends_on = ["vsphere_folder.folder_vm_1"]
  name   = "${var.name}"
  folder = "${var.folder}"
  datacenter = "${var.datacenter}"
  vcpu   = "${var.vcpu}"
  memory = "${var.memory}"
  cluster = "${var.cluster}"
  network_interface {
      label = "${var.network_label}"
      ipv4_gateway = "${var.ipv4_gateway}"
      ipv4_address = "${var.ipv4_address}"
      ipv4_prefix_length = "${var.ipv4_prefix_length}"
  }
  disk {
    datastore = "${var.storage}"
    template = "${var.vm_template}"
  }
}
