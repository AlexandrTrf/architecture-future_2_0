variable "env_name" { type = string }
variable "zone" { type = string }
variable "cores" { type = number }
variable "memory" { type = number }
variable "disk_size" {
    type = number
    default = 10
}
variable "instance_count" {
    type = number
    default = 1
}
variable "ssh_pub_key_path" {
  type        = string
  default	  = "./ssh/terraform.pub"
}
variable "keyfile" {
 type		 = string
 default	 = "key.json"
}
variable "folder_id" {
 type		 = string
 default	 ="b1go6bu7fgndh1mvb8gp"
}