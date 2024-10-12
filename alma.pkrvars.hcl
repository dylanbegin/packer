# Packer variables for Alma Linux

vmid        = "1000"
vmname      = "alma"
vmdesc      = "Alma Linux Base Template"
isourl      = "https://repo.almalinux.org/almalinux/9.4/isos/x86_64/AlmaLinux-9.4-x86_64-boot.iso"
isochecksum = "file:https://repo.almalinux.org/almalinux/9.4/isos/x86_64/CHECKSUM"
isofile     = "alma.iso"
httpdir     = "./http/alma/"
bootwait    = "10s"
bootcmd     = [
  "<up><wait>e<wait>",
  "<down><down><end><wait>",
  " console=ttyS0 net.ifnames=0 ipv6.disable=1 inst.cmdline inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg",
  "<wait><f10>"
]
provisioner = [
  # GRUB Configuration
  "cp -f /tmp/base/grub /etc/default/grub",
  "echo 'GRUB_CMDLINE_LINUX=\"console=ttyS0 net.ifnames=0 ipv6.disable=1 quiet\"' >> /etc/default/grub",
  "echo 'GRUB_DISTRIBUTOR=\"AlmaLinux\"' >> /etc/default/grub",
  "grub2-mkconfig -o /boot/grub2/grub.cfg",
  "grub2-mkconfig -o /boot/efi/EFI/almalinux/grub.cfg",
  # Package Configuration
  "cp -f /tmp/dnf.conf /etc/dnf/dnf.conf",
  "dnf remove dejavu-sans-fonts firewalld gdisk langpacks-en linux-firmware man-db microcode_ctl polkit rsyslog sssd-client teamd vim-minimal xfsprogs -y",
  "dnf config-manager --set-enabled crb",
  "dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo",
  "dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo",
  "dnf install epel-release -y",
  "dnf install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm -y",
  "dnf install --nogpgcheck https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm -y",
  "dnf update -y",
  "dnf install cloud-init sudo -y",
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
  "cp -f /tmp/base/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg",
  "cloud-init clean --logs",
  # Cleanup VM
  "dnf autoremove -y",
  "dnf clean all -y",
  "truncate -s 0 /etc/machine-id",
  "truncate -s 0 /etc/resolv.conf",
  "rm -f /var/lib/systemd/random-seed",
  "rm -rf /root/* /tmp/* /var/tmp/*",
  "sync",
  "passwd -l root"
]
