resource "yandex_iam_service_account" "tltest" {
  name        = "tltest-${var.environment}"
  description = "service account to manage VMs"
}

data "yandex_iam_policy" "admin" {
  binding {
    role = "admin"

    members = [
      "userAccount:foobar_user_id",
    ]
  }
}

resource "yandex_iam_service_account_iam_policy" "admin-account-iam" {
  service_account_id = yandex_iam_service_account.tltest.id
  policy_data        = data.yandex_iam_policy.admin.policy_data
}

resource "yandex_kms_symmetric_key" "tltest" {
  name              = "tltest-${var.environment}"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" // equal to 1 year
}

resource "yandex_kubernetes_cluster" "tltest" {
  name        = "tltest-${var.environment}"
  description = "tltest Cluster for ${var.environment} env"

  network_id = yandex_vpc_network.tltest.id

  master {
    version = "1.17"
    zonal {
      zone      = yandex_vpc_subnet.tltest-a.zone
      subnet_id = yandex_vpc_subnet.tltest-a.id
    }

    public_ip = true

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "15:00"
        duration   = "3h"
      }
    }
  }

  service_account_id      = yandex_iam_service_account.tltest.id
  node_service_account_id = yandex_iam_service_account.tltest.id

  release_channel = "STABLE"

  kms_provider {
    key_id = yandex_kms_symmetric_key.tltest.id
  }
}


resource "yandex_kubernetes_node_group" "tltest" {
  cluster_id  = yandex_kubernetes_cluster.tltest.id
  name        = "tltest-${var.environment}"
  description = "Nodes for tltest cluster"
  version     = "1.17"

  instance_template {
    platform_id = "standard-v2"

    metadata = {
      ssh-keys = "ubuntu:${file("~/.ssh/tltest.pub")}"
    }

    network_interface {
      nat        = true
      subnet_ids = ["${yandex_vpc_subnet.tltest-a.id}"]
    }

    resources {
      memory = 16
      cores  = 8
    }

    boot_disk {
      type = "network-ssd"
      size = 200
    }

    scheduling_policy {
      preemptible = false
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}