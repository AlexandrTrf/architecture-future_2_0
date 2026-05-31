variable "yc_token" {
  type      = string
  sensitive = true
}
variable "cloud_id" {
  type = string
}
variable "folder_id" {
  type = string
}
variable "env_name" { type = string }
variable "zone" { type = string }
variable "cores" { type = number }
variable "memory" { type = number }
variable "disk_size" {
  type    = number
  default = 10
}
variable "instance_count" {
  type    = number
  default = 1
}
variable "ssh_pub_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}