terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.113.0"
    }

  }
  # https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-state-storage
  # Добавить в ~/.bashrc
  # export ACCESS_KEY="<идентификатор_ключа>"
  # export SECRET_KEY="<секретный_ключ>"
  # terraform init -backend-config="access_key=$ACCESS_KEY" -backend-config="secret_key=$SECRET_KEY"

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    # Бакет создаётся в отдельном файле, имя бакета должно быть уникальным
    bucket = "tf-<changeme>-vm-bucket"
    region = "ru-central1"
    key    = "vms-state/vms-state.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.

  }
}
# terraform init -backend-config="access_key=$ACCESS_KEY" -backend-config="secret_key=$SECRET_KEY"


# Что такое cloud_id и как узнать свой cloud_id?
# cloud_id это идентификатор каталога
# https://yandex.cloud/ru/docs/resource-manager/operations/cloud/get-id
# Перейдите в консоль управления и выберите нужное облако. 
# На открывшейся странице идентификатор облака  указан сверху,
# рядом с именем облака, а также на вкладке Обзор в строке Идентификатор.

# Что такое folder_id и как узнать свой folder_id?
# folder_id это идентификатор каталога
# https://yandex.cloud/ru/docs/resource-manager/operations/folder/get-id
# Получить идентификатор каталога можно из URL страницы каталога в консоли управления
# https://console.cloud.yandex.ru/folders/<идентификатор_каталога>


locals {
  cloud_id  = "changeme"
  folder_id = "changeme"
}


provider "yandex" {
  cloud_id                 = local.cloud_id
  folder_id                = local.folder_id
  service_account_key_file = "path/to/authorized_key.json"
  zone                     = "ru-central1-a"
}

