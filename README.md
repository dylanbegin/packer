> [!WARNING]
> This README is still under development!

# ![logo](https://icon.horse/icon/www.packer.io) Packer Templates for Proxmox
> [!IMPORTANT]
> This repo is built for my own environment so please review all configurations to verify compatibility!

This repo is used to build Packer template files used in Proxmox and ready for cloudinit/Terraform deployments.

Features used in these templates are:
- Bare minimal installations.
- UEFI images with TTYS enabled.
- Single 10GB root volume.
- Includes cloudinit for terraform deployments.
- Includes QEMU guest agent.
- Includes Docker, Hashicorp, and community repos (when availible).

TODO features to add:
- CIS/STIG hardening
- Secureboot/TPM

> [!TIP]
> This repo is part of my IaC automation series. If you are building this in mind please follow my repo's in the order below.

1.  [terraform-iso-get](https://github.com/dylanbegin/terraform-iso-get)
1.  *you are here* [packer](https://github.com/dylanbegin/packer)
1.  [terraform-core](https://github.com/dylanbegin/terraform-core)
1.  [ansible](https://github.com/dylanbegin/ansible)
1.  [terraform-talos](https://github.com/dylanbegin/terraform-talos)
1.  [k8s-apps](https://github.com/dylanbegin/k8s-apps)

# ISO Setup
The Packer builder is configured to boot from an ISO. There are two aproaches to using a ISO, download the file from a URL or mount from a file. This repo is configured to use the file method but if you want to use a URL you can read the [Proxmox ISO Builder](https://developer.hashicorp.com/packer/integrations/hashicorp/proxmox/latest/components/builder/iso#required) for configuration details.

# Build Your Secrets File
Keeping in best practice, this repo does not contain any sensitive information. You will need to create a directory outside of this git repo on a properly encrypted disk/usb to save the secrets file. Below is the template needed for the file which needs to be named `pkr-secrets.pkrvars.hcl`.
The builds will run using the root (password `packer`) account temporarily and then disable the account. This means you will need to supply the primary user when you deploy a vm with something such as cloudinit/Terraform.
```hcl
# This is a sensitive file. Do not share!
# All variables for all Packer files.

proxmox_hostname = "pve1.example.com:8006"
proxmox_api_id = "username@pam!build"
proxmox_api_secret = "API-KEY-HERE"
```

# Building Packer Templates
Packer usage ref:
```sh

├─ http
│ ├─ base        # base files for all images
│ └─ <image>     # additional files for the image
├─ packer-config # base config applied to all images
├─ packer-vars   # base variables applied to all images
└─ <image>       # variables custom to the image
```
Each image has it's own variables file so all you need to do is define the correct OS file and your secrets file.

Init/upgrade Packer modules:
```shell
packer init -upgrade .
```

Validate the packer build with:
```shell
packer validate \
-var-file=<image>.pkrvars.hcl \
-var-file=/path/to/secrets/pkr-secrets.pkrvars.hcl .
```

Run the Packer build with:
```shell
packer build \
-var-file=<image>.pkrvars.hcl \
-var-file=/path/to/secrets/pkr-secrets.pkrvars.hcl .
```

# Current Images Supported
> [!IMPORTANT]
> Distro flavor choice is based off the latest, stable, slim version availible.

| OS                                                    | Version    | VMID | Status |
| ----------------------------------------------------- | ---------- | ---- | ------ |
|  [Alma](https://almalinux.org/)                      | 9.4        | 1000 | Completed |
|  [Alpine](https://www.alpinelinux.org/)              | 3.20       | 1001 | Completed |
|  [Antix](https://antixlinux.com/)                    | 22         | 1002 | |
| 󰣇 [Arch](https://archlinux.org/)                      | rolling    | 1003 | |
|  [Artix](https://artixlinux.org/index.php)           | rolling    | 1004 | |
|  [Centos](https://www.centos.org/centos-stream/)     | Streams 9  | 1005 | Completed |
|  [ClearOS](https://www.clearlinux.org/index.html)    | rolling    | 1006 | |
|  [Core](http://www.tinycorelinux.net/)               | 15         | 1007 | |
| 󰣚 [Debian](https://www.debian.org/)                   | 12.6       | 1008 | Commpleted |
|  [Elementary](https://elementary.io/)                | 7.1        | 1009 | |
|  [Endeavour](https://endeavouros.com/)               | Gemini     | 1010 | |
| 󰣛 [Fedora](https://fedoraproject.org/)                | 40         | 1011 | Completed |
| 󰣠 [FreeBSD](https://www.freebsd.org/)                 | 13.3       | 1012 | |
| 󰣨 [Gentoo](https://www.gentoo.org/)                   | rolling    | 1013 | |
|  [Kali](https://www.kali.org/)                       | rolling    | 1014 | initrd err |
|  [Kali Purple](https://www.kali.org/)                | rolling    | 1015 | |
| 󱘊 [Manjaro](https://manjaro.org/)                     | 23.1       | 1016 | |
| 󰣭 [Mint](https://linuxmint.com/)                      | 21.3       | 1017 | |
| 󱄅 [Nix](https://nixos.org/)                           | 23.11      | 1018 | |
|  [OpenBSD](https://www.openbsd.org/)                 | 7.5        | 1019 | |
|  [OpenSUSE](https://www.opensuse.org/)               | Tumbleweed | 1020 | |
|  [Parrot](https://parrotlinux.org/)                  | 6          | 1021 | |
|  [Peppermint](https://peppermintos.com/)             | rolling    | 1022 | |
|  [Pop!](https://pop.system76.com/)                   | 22.04      | 1023 | |
|  [QubesOS](https://www.qubes-os.org/)                | 4.2        | 1024 | |
|  [Rocky](https://rockylinux.org/)                    | 9.4        | 1025 | Completed |
| 󱃾 [Talos](https://www.talos.dev/)                     | 1.7        | 1026 | Completed |
| 󰕈 [Ubuntu](https://ubuntu.com/)                       | 24.04      | 1027 | Completed |
|  [Vanilla](https://vanillaos.org/)                   | 22.10      | 1028 | |
|  [Void](https://voidlinux.org/)                      | glibc      | 1029 | |
|  [Windows](https://www.microsoft.com/en-us/windows/) | 11         | 1030 | |
|  [Zorin](https://zorin.com/os/)                      | 17.1       | 1031 | |
> [!WARNING]
> The Talos xz image is pulled from [Image Factory](https://factory.talos.dev/). Use the Disk Image link in the packer variable file after you finish the customize.

# Acknowledgements
Huge shout out to Pumba98 for his excellent repo which much of this was inspired. You can find his repo here:
[github.com/Pumba98/proxmox-packer-templates)](https://github.com/Pumba98/proxmox-packer-templates)
