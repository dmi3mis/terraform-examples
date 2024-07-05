# This is an example of creating qemu-kvm vms using terraform

tested on Debian cloud image

## 1. install qemu-kvm and libvirt on Ubuntu 22.04

```console
sudo apt upgrade
egrep -c '(vmx|svm)' /proc/cpuinfo
sudo apt install -y qemu-kvm libvirt-daemon-system virtinst libvirt-clients bridge-utils virt-manager
sudo systemctl enable --now libvirtd
sudo systemctl status libvirtd
sudo usermod -aG kvm $USER
sudo usermod -aG libvirt $USER
```
## 2. install mkisofs utility.

```console
sudo apt install -y mkisofs
```

## 3. Clone this repository

```console
cd ~
git clone https://github.com/dmi3mis/terraform-examples
cd terraform-examples/create-vm-libvirt

```

## 4. Generate ssh key and apply this config

```console
ssh-keygen -t ecdsa -f ~/.ssh/id_ecdsa
terraform init
terraform plan
terraform apply
ssh -i ./id_ecdsa root@$(terraform output -raw ip)
```

note: if you are see error like this

```console
Error: error creating libvirt domain: internal error: process exited while connecting  to monitor: 2024-03-27T11:36:23.167320Z qemu-system-x86_64: -blockdev {"driver":"file",> "filename":"/home/pool/os_image_debian","node-name":"libvirt-3-storage","auto-read-only":true,"discard":"unmap"}: Could not open '/home/pool/os_image_debian': Permission denied
```

Issue is in apparmor rules that prevents qemu-kvm virtual machine to read and write in custom locations
# https://gitlab.com/apparmor/apparmor/-/wikis/Libvirt
# https://www.turek.dev/posts/add-custom-libvirt-apparmor-permissions/

you can add Pool location to Apparmor allow rules

```console
sudo sh -c 'echo /home/pool/\* rwk, >> /etc/apparmor.d/abstractions/libvirt-qemu'
systemctl restart libvirtd
```
or you can disable Apparmor security on libvirtd

```console
sudo sh -c 'echo security_driver = \"none\" >> /etc/libvirt/qemu.conf'
systemctl restart libvirtd
```
