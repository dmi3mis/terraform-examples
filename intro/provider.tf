terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.113.0"
    }
  }
}

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
  service_account_key_file = "../../authorized_key.json"
  zone                     = "ru-central1-a"
}
