// https://www.youtube.com/watch?v=y1eqR0xL1ZI

locals {
  # Bucket name must be unique across the entire cloud.
  bucket_name = "tf-dmi3mis-bucket"
  index       = "index.html"
  cat         = "cat.png"
}

// Create SA
resource "yandex_iam_service_account" "sa" {
  folder_id = local.folder_id
  name      = "tf-test-sa"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = local.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

// Use keys to create bucket
resource "yandex_storage_bucket" "test" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = local.bucket_name
  acl        = "public-read"
  website {
    index_document = local.index
  }

}

locals {
  index_template = templatefile("site/${local.index}.tpl", {
    endpoint = yandex_storage_bucket.test.website_endpoint
  })
}

resource "yandex_storage_object" "index" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.test.id
  acl        = "public-read"
  key        = local.index
  // source = "site/${local.index}"
  content_base64 = base64encode(local.index_template)

  content_type = "text/html"

}

resource "yandex_storage_object" "cat" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.test.id
  acl        = "public-read"
  key        = local.cat
  source     = "site/${local.cat}"
}

output "site_name" {
  value = yandex_storage_bucket.test.website_endpoint
}