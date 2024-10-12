# Packer template universal variables for all builds

# Proxmox Connection Settings
variable "proxmox_hostname" {
  description = "The FQDN or IP of the Proxmox node."
  type        = string
}

variable "proxmox_api_id" {
  description = "API id of the user connecting to Proxmox."
  type        = string
  sensitive   = true
}

variable "proxmox_api_secret" {
  description = "API key of the user connecting to Proxmox."
  type        = string
  sensitive   = true
}

variable "proxmox_insecure_tls" {
  description = "Is the Proxmox certificate self-signed?"
  type        = bool
  default     = true
}

# VM General Settings
variable "node" {
  description = "The name of the Promxmox node."
  type        = string
  default     = "pve1"
}

variable "vmid" {
  description = "VM template id number."
  type        = number
}

variable "vmname" {
  description = "VM template name."
  type        = string
}

variable "vmdesc" {
  description = "VM template description. Notes field in Proxmox."
  type        = string
}

# VM System Settings
variable "cputype" {
  description = "VM CPU type."
  type        = string
  default     = "x86-64-v3"
}

variable "cpusocket" {
  description = "VM CPU socket number."
  type        = number
  default     = 1
}

variable "cpucores" {
  description = "VM core count per socket."
  type        = number
  default     = 4
}

variable "memsize" {
  description = "VM memory size in Megabytes."
  type        = number
  default     = 4096
}

variable "memballoon" {
  description = "VM memory balloon minimum in Megabytes."
  type        = number
  default     = 0
}

variable "disksize" {
  description = "VM disk size in Gigabytes."
  type        = string
  default     = "10G"
}

variable "disktype" {
  description = "VM disk device type."
  type        = string
  default     = "scsi"
}

variable "diskpool" {
  description = "Proxmox storage pool on which to store the disk."
  type        = string
  default     = "local-lvm"
}

variable "diskformat" {
  description = "VM disk backing file system type."
  type        = string
  default     = "raw"
}

variable "diskssd" {
  description = "VM disk an emulated ssd?"
  type        = bool
  default     = true
}

variable "diskdiscard" {
  description = "Enable VM disk discard flag?"
  type        = bool
  default     = true
}

variable "diskcache" {
  description = "VM disk cache mode"
  type        = string
  default     = "none"
}

variable "diskio" {
  description = "Enable VM disk io threads?"
  type        = bool
  default     = true
}

variable "efipool" {
  description = "Proxmox storage pool on which to store the EFI disk."
  type        = string
  default     = "local-lvm"
}

variable "efitype" {
  description = "VM EFI disk type."
  type        = string
  default     = "4m"
}

variable "efienroll" {
  description = "Enroll EFI keys?"
  type        = bool
  default     = true
}

variable "netmodel" {
  description = "VM network device model"
  type        = string
  default     = "virtio"
}

variable "netbridge" {
  description = "Proxmox network bridge device attached to VM."
  type        = string
  default     = "vmbr1"
}

variable "netfirewall" {
  description = "VM network firewall enabled?"
  type        = bool
  default     = false
}

variable "vga" {
  description = "VM VGA device type."
  type        = string
  default     = "serial0"
}

variable "os" {
  description = "VM operating system type."
  type        = string
  default     = "l26"
}

variable "scsi" {
  description = "VM SCSI controller type."
  type        = string
  default     = "virtio-scsi-single"
}

variable "bios" {
  description = "VM BIOS device type."
  type        = string
  default     = "ovmf"
}

variable "machine" {
  description = "VM machine virtualization type."
  type        = string
  default     = "q35"
}

variable "serial" {
  description = "VM TTY serial device type."
  type        = list(string)
  default     = ["socket"]
}

variable "onboot" {
  description = "VM boot on proxmox boot?"
  type        = bool
  default     = false
}

variable "boot" {
  description = "VM device boot order."
  type        = string
  default     = "order=scsi0;ide2"
}

variable "qemu" {
  description = "VM Qemu agent enabled?"
  type        = bool
  default     = true
}

variable "isodownload" {
  description = "Is the ISO to be downloaded from a URL?"
  type        = bool
  default     = false
}

variable "isourl" {
  description = "ISO URL link."
  type        = string
}

variable "isochecksum" {
  description = "ISO checksum URL link or string."
  type        = string
}

variable "isopool" {
  description = "Proxmox storage pool on which to store the iso."
  type        = string
  default     = "nomad"
}

variable "isofile" {
  description = "Proxmox storage path to iso file."
  type        = string
}

variable "isoumount" {
  description = "Umount iso after install?"
  type        = bool
  default     = true
}

variable "cloudinit" {
  description = "Enable VM cloud init flag?"
  type        = bool
  default     = true
}

variable "cloudinitpool" {
  description = "Proxmox storage pool on which the cloud init is stored."
  type        = string
  default     = "local-lvm"
}

# Packer Boot Setup
variable "bootwait" {
  description = "Packer delay before running boot command."
  type        = string
}

variable "bootcmd" {
  description = "Packer boot command to run in the boot menu."
  type        = list(string)
}

variable "httpdir" {
  description = "Packer directory path to server the HTTP server."
  type        = string
}

variable "httpaddr" {
  description = "Packer HTTP bind address."
  type        = string
  default     = "0.0.0.0"
}

variable "portmin" {
  description = "Packer HTTP port minimum range."
  type        = number
  default     = 8082
}

variable "portmax" {
  description = "Packer HTTP port maximum range."
  type        = number
  default     = 8082
}

variable "sshtimeout" {
  description = "Packer SSH timeout to kill build."
  type        = string
  default     = "20m"
}

variable "sshpty" {
  description = "Enable Packer SSH PTY feature flag?"
  type        = bool
  default     = false
}

variable "provisioner" {
  description = "Packer provisioner inline command to setup VM."
  type        = list(string)
}
