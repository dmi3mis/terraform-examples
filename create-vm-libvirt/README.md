# This is an example of creating qemu-kvm vms using terraform

tested on Debian cloud image

## configure KVM / QEMU

check if you are in the `libvirt` group:

```console
sudo getent group | grep libvirt
```

otherwise add:

```console
sudo usermod -a -G libvirt $(whoami)
service libvirtd restart
```

### 1. create/define pool storage

```console
sudo mkdir -p /home/pool
sudo chmod o+w /home/pool
virsh pool-define-as pool --type dir --target /home/pool
virsh pool-autostart pool
virsh pool-start pool
```

Uncomment pool block in main.tf and change os_image_debian.source download link if you want to create pool and download qcow2 image automatticaly

### 2. Download debian qcow2 cloud image

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
ssh-keygen -t ecdsa -f id_ecdsa
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
echo security_driver = "none" >> /etc/libvirt/qemu.conf
systemctl restart libvirtd
```
