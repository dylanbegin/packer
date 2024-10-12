# Packer template used by all builds

# Requirements
packer {
  required_plugins {
    proxmox-iso = {
      version   = ">= 1.1.8"
      source    = "github.com/hashicorp/proxmox"
    }
  }
}

# VM Resource Definitions
source "proxmox-iso" "main" {
 
  # Proxmox Connection Settings
  proxmox_url = "https://${var.proxmox_hostname}/api2/json"
  username    = var.proxmox_api_id
  token       = var.proxmox_api_secret
  insecure_skip_tls_verify = var.proxmox_insecure_tls
  
  # VM General Settings
  node                 = var.node
  vm_id                = var.vmid
  vm_name              = var.vmname
  template_description = var.vmdesc

  # VM System Settings
  cpu_type           = var.cputype
  sockets            = var.cpusocket
  cores              = var.cpucores

  memory             = var.memsize
  ballooning_minimum = var.memballoon

  disks {
    disk_size    = var.disksize
    type         = var.disktype
    storage_pool = var.diskpool
    format       = var.diskformat
    ssd          = var.diskssd
    discard      = var.diskdiscard
    cache_mode   = var.diskcache
    io_thread    = var.diskio
  }

  efi_config {
    efi_storage_pool  = var.efipool
    efi_type          = var.efitype
    pre_enrolled_keys = var.efienroll
  }

  network_adapters {
    model    = var.netmodel
    bridge   = var.netbridge
    firewall = var.netfirewall
  }

  vga {
    type = var.vga
  }

  os               = var.os
  scsi_controller  = var.scsi
  bios             = var.bios
  machine          = var.machine
  serials          = var.serial
  onboot           = var.onboot
  boot             = var.boot
  qemu_agent       = var.qemu

  iso_url                 = var.isodownload ? var.isourl : ""
  iso_checksum            = var.isochecksum
  iso_file                = var.isodownload ? "" : "${var.isopool}:iso/${var.isofile}"
  iso_storage_pool        = var.isopool
  unmount_iso             = var.isoumount
  cloud_init              = var.cloudinit
  cloud_init_storage_pool = var.cloudinitpool

  # Packer Boot Setup
  boot_wait            = var.bootwait
  boot_command         = var.bootcmd
  http_directory       = var.httpdir
  http_bind_address    = var.httpaddr
  http_port_min        = var.portmin
  http_port_max        = var.portmax
  ssh_username         = "root"   # temp use, disabled after build
  ssh_password         = "packer" # temp use, removed after build
  ssh_timeout          = var.sshtimeout
  ssh_pty              = var.sshpty
}

# Build Definition to create the VM Template
build {

  name    = "linux"
  sources = ["source.proxmox-iso.main"]

  # Upload all base files to tmp
  provisioner "file" {
    source      = "./http/base"
    destination = "/tmp/"
  }

  # Upload all OS specific files to tmp
  provisioner "file" {
    source      = var.httpdir
    destination = "/tmp"
  }

  # Post provisioning the VM
  provisioner "shell" {
    inline = var.provisioner
  }
}
