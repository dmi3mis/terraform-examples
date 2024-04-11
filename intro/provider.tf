terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.113.0"
    }
  }
}

locals {
  cloud_id  = "b1gon01d1naocfdcpc0b"
  folder_id = "b1gtho3en7gbj3osce23"
}

provider "yandex" {

  cloud_id                 = local.cloud_id
  folder_id                = local.folder_id
  service_account_key_file = "../../authorized_key.json"
  zone                     = "ru-central1-a"
}