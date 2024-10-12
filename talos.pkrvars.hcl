# Packer variables for Talos Linux

vmid        = "1026"
vmname      = "talos"
vmdesc      = "Talos Base Template"
isourl      = "https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-virt-3.19.1-x86_64.iso"
isochecksum = "file:https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-virt-3.19.1-x86_64.iso.sha256"
isofile     = "alpine.iso"
httpdir     = "./http/talos/"
efienroll   = false
sshpty      = true
bootwait    = "10s"
bootcmd     = [
  # login and enable network
  "root<enter><wait>",
  "ifconfig eth0 up && udhcpc -i eth0<enter><wait5>",
  # add main and community https
  "echo https://dl-cdn.alpinelinux.org/alpine/latest-stable/main >> /etc/apk/repositories<enter>",
  "echo https://dl-cdn.alpinelinux.org/alpine/latest-stable/community >> /etc/apk/repositories<enter>",
  # ensure required packages are installed
  "apk update<enter><wait>",
  "apk upgrade<enter><wait5>",
  "apk add --no-cache curl openssh qemu-guest-agent wget xz<enter><wait10s>",
  # temp allow root ssh login
  "passwd<enter><wait>",
  "packer<enter><wait>",
  "packer<enter><wait>",
  "echo \"PermitRootLogin yes\" >> /etc/ssh/sshd_config<enter>",
  # enable guest agent
  "rc-update add qemu-guest-agent<enter><wait>",
  "rc-service qemu-guest-agent start<enter><wait>",
  # enable ssh
  "rc-update add sshd<enter><wait>",
  "rc-service sshd start<enter><wait>"
]
provisioner = [
  # dd Talos disk image in /dev/sda
  # https://factory.talos.dev/?arch=amd64&cmdline-set=true&extensions=-&extensions=siderolabs%2Fqemu-guest-agent&platform=nocloud&target=cloud&version=1.7.4
  "xz -d -c /tmp/talos-1-7.xz | dd of=/dev/sda && sync"
]
