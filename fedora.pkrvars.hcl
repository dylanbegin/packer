# Packer variables for Fedora Server

vmid        = "1011"
vmname      = "fedora"
vmdesc      = "Fedora Server Base Template"
isourl      = "https://download.fedoraproject.org/pub/fedora/linux/releases/41/Server/x86_64/iso/Fedora-Server-netinst-x86_64-41-1.4.iso"
isochecksum = "file:https://download.fedoraproject.org/pub/fedora/linux/releases/40/Server/x86_64/iso/Fedora-Server-40-1.14-x86_64-CHECKSUM"
isofile     = "fedora.iso"
httpdir     = "./http/fedora/"
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
  "echo 'GRUB_DISTRIBUTOR=\"Fedora\"' >> /etc/default/grub",
  "grub2-mkconfig -o /boot/grub2/grub.cfg",
  "grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg",
  # Package Configuration
  "rm -f /etc/dnf/protected.d/sudo.conf",
  "cp -f /tmp/dnf.conf /etc/dnf/dnf.conf",
  "dnf remove dejavu-sans-fonts firewalld google-noto-fonts-common hunspell langpacks-en linux-firmware man-db microcode_ctl nano rsyslog parted polkit scrot shared-mime-info sssd-client sudo vim-enhanced -y",
  "dnf install dnf-plugins-core -y",
  "dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo",
  "dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo",
  "dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y",
  "dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y",
  "dnf distro-sync -y",
  "dnf update -y",
  "dnf install cloud-init opendoas -y",
  # SSH hardening
  "cp -f /tmp/base/sshd_config /etc/ssh/sshd_config",
  "cp -f /tmp/base/ssh-banner /etc/ssh/ssh-banner",
  # Setup doas for wheel
  "cat <<EOF > /etc/doas.conf\npermit nopass keepenv :wheel\n\nEOF",
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
