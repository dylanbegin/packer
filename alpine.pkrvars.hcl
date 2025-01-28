# Packer variables for Alpine Linux

vmid        = "1001"
vmname      = "alpine"
vmdesc      = "Alpine Linux Base Template"
isourl      = "https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/x86_64/alpine-virt-3.21.2-x86_64.iso"
isochecksum = "file:https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/alpine-virt-3.20.1-x86_64.iso.sha256"
isofile     = "alpine.iso"
httpdir     = "./http/alpine/"
efienroll   = false
sshpty      = true
bootwait    = "10s"
bootcmd     = [
  # login and pull answers file
  "root<enter><wait>",
  "ifconfig eth0 up && udhcpc -i eth0<enter><wait5>",
  "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/answers<enter><wait>",
  "setup-alpine -f answers<enter><wait5>",
  # setup root user
  "packer<enter><wait>",
  "packer<enter><wait5>",
  # skip user account setup
  "<enter><wait5>",
  # erase disk
  "y<enter><wait15s>",
  # mounts and chroot
  "rc-service sshd stop<enter><wait>",
  "mount /dev/sda2 /mnt<enter>",
  "mount /dev/sda1 /mnt/boot/efi<enter>",
  "mount -t proc /proc /mnt/proc<enter>",
  "mount --rbind /dev /mnt/dev<enter>",
  "mount --make-rslave /mnt/dev<enter>",
  "mount --rbind /sys /mnt/sys<enter>",
  "chroot /mnt<enter><wait>",
  # 0 out repolist then add main and community https
  "echo > /etc/apk/repositories<enter>",
  "echo https://dl-cdn.alpinelinux.org/alpine/latest-stable/main > /etc/apk/repositories<enter>",
  "echo https://dl-cdn.alpinelinux.org/alpine/latest-stable/community >> /etc/apk/repositories<enter>",
  # install and enable guest agent
  "apk update<enter><wait>",
  "apk upgrade<enter><wait5>",
  "apk add --no-cache qemu-guest-agent<enter><wait>",
  "rc-update add qemu-guest-agent<enter><wait>",
  # temp allow root ssh login
  "echo \"PermitRootLogin yes\" >> /etc/ssh/sshd_config<enter>",
  # exit chroot and reboot
  "exit<enter>",
  "umount /mnt/dev<enter><wait>",
  "umount /mnt<enter><wait>",
  "reboot<enter>"
]
provisioner = [
  # GRUB Configuration
  "apk del syslinux",
  "apk add grub grub-efi efibootmgr",
  "grub-install --target=x86_64-efi --efi-directory=/boot/efi",
  "cp -f /tmp/base/grub /etc/default/grub",
  "echo 'GRUB_CMDLINE_LINUX=\"console=ttyS0 net.ifnames=0 ipv6.disable=1 rootfstype=ext4 modules=sd-mod,ext4 quiet\"' >> /etc/default/grub",
  "echo 'GRUB_DISTRIBUTOR=\"Alpine Linux\"' >> /etc/default/grub",
  "grub-mkconfig -o /boot/grub/grub.cfg",
  "grub-mkconfig -o /boot/efi/EFI/alpine/grub.efi",
  # Package Configuration
  "apk update",
  "apk upgrade",
  "apk add --no-cache doas cloud-init e2fsprogs-extra mount py3-pyserial py3-netifaces",
  # SSH hardening
  "cp -f /tmp/base/sshd_config /etc/ssh/sshd_config",
  "cp -f /tmp/base/ssh-banner /etc/ssh/ssh-banner",
  # Setup doas for wheel
  "cat <<EOF > /etc/doas.conf\npermit nopass keepenv :wheel\n\nEOF",
  # Foot term config
  "mkdir -p /usr/share/terminfo/f",
  "cp -f /tmp/base/foot /usr/share/terminfo/f/foot",
  "cp -f /tmp/base/foot-direct /usr/share/terminfo/f/foot-direct",
  # Setup Guest Agent
  "rc-update add qemu-guest-agent",
  "rc-service qemu-guest-agent start",
  # Setup cloud-init
  # https://git.alpinelinux.org/aports/tree/community/cloud-init/README.Alpine
  # NOTE currently, there is a bug in which dns cannot be set with static ip:
  # https://gitlab.alpinelinux.org/alpine/cloud/alpine-cloud-images/-/issues/160
  "cp -f /tmp/base/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg",
  "setup-cloud-init",
  "cloud-init clean --logs",
  # Cleanup VM
  "truncate -s 0 /etc/machine-id",
  "truncate -s 0 /etc/resolv.conf",
  "rm -f /var/lib/systemd/random-seed",
  "rm -rf /root/* /tmp/* /var/tmp/*",
  "passwd -l root"
]
