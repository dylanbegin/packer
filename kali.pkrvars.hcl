# Packer variables for Kali Linux

vmid        = "1014"
vmname      = "kali"
vmdesc      = "Kali Linux Base Template"
isourl      = "https://cdimage.kali.org/kali-2024.4/kali-linux-2024.4-installer-netinst-amd64.iso"
isochecksum = "fbadb7f33e59f21789599b5da4c47d34cbfddbed97b8103073a717e8b0e36784"
isofile     = "kali.iso"
httpdir     = "./http/kali/"
efienroll   = false
sshpty      = true
bootwait    = "10s"
bootcmd     = [
  "<wait><down>c<wait>",
  "set background_color=black<enter>",
  "linux /install.amd/vmlinuz vga=788 auto=true console=ttyS0 net.ifnames=0 ipv6.disable=1 hostname=kali domain=localhost url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>",
  "initrd /install.amd/initrd.gz<enter>",
  "boot<enter>"
]
provisioner = [
  # GRUB Configuration
  "cp -f /tmp/base/grub /etc/default/grub",
  "echo 'GRUB_CMDLINE_LINUX=\"console=ttyS0 net.ifnames=0 ipv6.disable=1 quiet\"' >> /etc/default/grub",
  "echo 'GRUB_DISTRIBUTOR=\"Kali Rolling\"' >> /etc/default/grub",
  "update-grub2 -o /boot/grub/grub.cfg",
  "update-grub2 -o /boot/efi/EFI/kali/grub.cfg",
  # Package Updates and installation
  "apt remove bsdextrautils debian-faq dictionaries-common doc-debian firmware-linux-free intel-microcode laptop-detect nano man-db manpages mime-support shared-mime-info reportbug usbutils vim vim-common vim-tiny wamerican xdg-user-dirs -y",
  "apt install ca-certificates cloud-init curl gpg sudo wget -y",
  "install -m 0755 -d /etc/apt/keyrings",
  "curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc",
  "chmod a+r /etc/apt/keyrings/docker.asc",
  "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable\" | tee /etc/apt/sources.list.d/docker.list > /dev/null",
  "wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg",
  "echo \"deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main\" | tee /etc/apt/sources.list.d/hashicorp.list",
  "systemctl daemon-reload",
  "apt full-upgrade -y",
  "apt update -y",
  "apt upgrade -y",
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
  # Initialize cloud-init
  "cp -f /tmp/base/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg",
  "cloud-init clean --logs",
  # Cleanup VM
  "apt remove curl wget -y",
  "apt autoclean -y",
  "apt autoremove -y",
  "truncate -s 0 /etc/machine-id",
  "rm -f /var/lib/systemd/random-seed",
  "rm -rf /root/* /tmp/* /var/tmp/*",
  "sync",
  "passwd -l root"
]
