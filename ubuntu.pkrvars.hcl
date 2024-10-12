# Packer variables for Ubuntu Server

vmid        = "1027"
vmname      = "ubuntu"
vmdesc      = "Ubuntu Server Base Template"
isourl      = "https://releases.ubuntu.com/24.04/ubuntu-24.04-live-server-amd64.iso"
isochecksum = "https://releases.ubuntu.com/24.04/SHA256SUMS"
isofile     = "ubuntu.iso"
httpdir     = "./http/ubuntu/"
bootwait    = "10s"
bootcmd     = [
  "<wait><up>e<wait>",
  "<down><down><down><end><wait>",
  " autoinstall console=ttyS0 net.ifnames=0 ipv6.disable=1 ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'",
  "<wait><f10><wait>"
]
provisioner = [
  # GRUB Configuration
  "cp -f /tmp/base/grub /etc/default/grub",
  "echo 'GRUB_CMDLINE_LINUX=\"console=ttyS0 net.ifnames=0 ipv6.disable=1 quiet\"' >> /etc/default/grub",
  "echo 'GRUB_DISTRIBUTOR=\"Ubuntu\"' >> /etc/default/grub",
  "update-grub2 -o /boot/grub/grub.cfg",
  "update-grub2 -o /boot/efi/EFI/ubuntu/grub.cfg",
  # Package Configuration
  "apt remove apport btrfs-progs fuse3 intel-microcode linux-firmware lvm2 lxd-installer manpages mdadm plymouth polkitd shared-mime-info snapd wireless-regdb usbutils vim vim-common vim-tiny xdg-user-dirs xfsprogs -y",
  "apt install ca-certificates cloud-init curl gpg sudo wget -y",
  "install -m 0755 -d /etc/apt/keyrings",
  "curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",
  "chmod a+r /etc/apt/keyrings/docker.asc",
  "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable\" | tee /etc/apt/sources.list.d/docker.list > /dev/null",
  "wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg",
  "echo \"deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main\" | tee /etc/apt/sources.list.d/hashicorp.list",
  "systemctl daemon-reload",
  "apt update -y",
  "apt upgrade -y",
  "apt dist-upgrade -y",
  # Setup sudoers for sudo
  "echo '%sudo ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/sudo",
  # SSH hardening
  "cp -f /tmp/base/sshd_config /etc/ssh/sshd_config",
  "cp -f /tmp/base/ssh-banner /etc/ssh/ssh-banner",
  # Foot term config
  "mkdir -p /usr/share/terminfo/f",
  "cp -f /tmp/base/foot /usr/share/terminfo/f/foot",
  "cp -f /tmp/base/foot-direct /usr/share/terminfo/f/foot-direct",
  # Enable Guest Agent
  "systemctl start qemu-guest-agent",
  "systemctl enable qemu-guest-agent",
  # Setup cloud-init
  #"rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
  "cp -f /tmp/base/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg",
  "cloud-init clean --logs",
  # Cleanup VM
  "apt remove curl wget -y",
  "apt autoclean -y",
  "apt autoremove -y",
  "truncate -s 0 /etc/machine-id",
  "truncate -s 0 /etc/resolv.conf",
  "rm -f /var/lib/systemd/random-seed",
  "rm -rf /root/* /tmp/* /var/tmp/*",
  "rm -f /etc/cloud/cloud.cfg.d/*",
  "sync",
  "userdel --remove --force packer",
  "passwd -l root"
]
