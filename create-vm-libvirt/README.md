# This is an example of creating qemu-kvm vms using terraform

tested on Debian cloud image

## install qemu-kvm and libvirt on Ubuntu 22.04

```console
sudo apt upgrade
egrep -c '(vmx|svm)' /proc/cpuinfo
sudo apt install -y qemu-kvm libvirt-daemon-system virtinst libvirt-clients bridge-utils
sudo systemctl enable --now libvirtd
sudo systemctl status libvirtd
sudo usermod -aG kvm $USER
sudo usermod -aG libvirt $USER

```
### 1. create/define libvirt vm pool storage

```console
sudo mkdir -p /home/pool
sudo chmod o+w /home/pool
virsh pool-define-as pool --type dir --target /home/pool
virsh pool-autostart pool
virsh pool-start pool
```

Uncomment pool block in main.tf and change os_image_debian.source download link if you want to create pool and download qcow2 image automatticaly

### 2. Download debian qcow2 cloud image
# Note: you can comment 14 line and uncomment 15 line 'source = "/home/pool/debian-12-genericcloud-amd64.qcow2"' and skip this step
```console
cd /home/pool/
wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2
```

### 3. Clone this repository

```console
git clone https://github.com/dmi3mis/terraform-examples
cd terraform-examples/create-vm-libvirt

```

### 4. Generate ssh key and apply this config

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

do this

```console
sudo sh -c 'echo security_driver = "none" >> /etc/libvirt/qemu.conf'
systemctl restart libvirtd
```
