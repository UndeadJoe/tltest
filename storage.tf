resource "yandex_iam_service_account_static_access_key" "tltest" {
  service_account_id = yandex_iam_service_account.tltest.id
  description        = "static access key for object storage"
}

resource "yandex_storage_bucket" "tltest" {
  bucket     = "tltest"
  access_key = yandex_iam_service_account_static_access_key.tltest.access_key
  secret_key = yandex_iam_service_account_static_access_key.tltest.secret_key
}