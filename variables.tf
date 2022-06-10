
variable "folder_id" {
  description = "Folder ID"
}

variable "cloud_id" {
  description = "Cloud ID"
}

variable "zone" {
  description = "Yandex Zone"
  default     = "ru-central1-a"
}

variable "token" {
  description = "Private token"
}

variable "environment" {
  description = "environment for all names"
  default     = "staging"
}

variable "external_IP" {
  description = "external IP address for loadbalancer"
  default     = "178.154.226.237"
}