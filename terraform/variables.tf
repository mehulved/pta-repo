
variable "region" {
  default = "asia-east1"
}

variable "region_zone" {
  default = "asia-east1-b"
}

variable "region_zone_2" {
  default = "asia-east1-c"
}

variable "project_name" {
  description = "The ID of the Google Cloud project",
  default = "rootconf-mehul"
}

variable "public_key_path" {
  default = "../files/ssh-keys/rootconf_ed25519.pub"
}
