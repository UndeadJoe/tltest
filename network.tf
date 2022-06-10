resource "yandex_vpc_network" "tltest" {
  name = "tltest_${var.environment}"
}

resource "yandex_vpc_subnet" "tltest-a" {
  name           = "tltest-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.tltest.id
  v4_cidr_blocks = ["10.128.0.0/24"]
}

resource "yandex_vpc_subnet" "tltest-b" {
  name           = "tltest-ru-central1-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.tltest.id
  v4_cidr_blocks = ["10.129.0.0/24"]
}

resource "yandex_vpc_subnet" "tltest-c" {
  name           = "tltest-ru-central1-c"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.tltest.id
  v4_cidr_blocks = ["10.130.0.0/24"]
}

resource "yandex_vpc_address" "tltest" {
  name = "tltest_${var.environment}"

  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}