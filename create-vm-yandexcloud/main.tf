# https://yandex.cloud/ru/docs/compute/operations/images-with-pre-installed-software/create
# https://yandex.cloud/ru/docs/organization/concepts/os-login
# https://yandex.cloud/ru/docs/compute/operations/vm-create/create-preemptible-vm#tf_1

resource "yandex_compute_image" "ubuntu_2204" {
  source_family = "ubuntu-2204-lts-oslogin"
}

resource "yandex_compute_disk" "boot-disk-vm1" {
  name     = "boot-disk-1"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "20"
  image_id = yandex_compute_image.ubuntu_2204.id
}

resource "yandex_compute_instance" "vm-1" {
  name                      = "terraform1"
  allow_stopping_for_update = true
  platform_id               = "standard-v1"
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-vm1.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  scheduling_policy {
    preemptible = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("/changeme/id_rsa.pub")}"
  }

  # https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec
  provisioner "remote-exec" {

    inline = [
      "sudo apt update -y",
      "sudo apt install apache2 -y",
      "echo '<h1><center>hello world</center></h1>' |sudo tee /var/www/html/index.html"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      # ssh private key file
      private_key = file("/path/to/id_rsa")
      host        = self.network_interface.0.nat_ip_address
    }

  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "subnet-1" {
  value = yandex_vpc_subnet.subnet-1.id
}
