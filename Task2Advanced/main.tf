module "vm" {
  source = "./modules/vm"

  env_name         = var.env_name
  zone             = var.zone
  cores            = var.cores
  memory           = var.memory
  disk_size        = var.disk_size
  instance_count   = var.instance_count
  ssh_pub_key_path = var.ssh_pub_key_path
}



