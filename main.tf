provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "tltest-terraform-storage"
    region     = "ru-central1"
    key        = "tltest_cloud.tfstate"
    access_key = "YCAJEhEeKpoNnZ4Pa9VnbhneA"
    secret_key = "YCMid4ydTCiDVAYwITEJgazaJmMqBvKjabWYCxSC"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}