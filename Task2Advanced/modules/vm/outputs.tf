output "vm_external_ip" {
  value = yandex_compute_instance.app-vm[*].network_interface[0].nat_ip_address
}

output "vm_name" {
  value = yandex_compute_instance.app-vm[*].name
}

output "vm_id" {
  value = yandex_compute_instance.app-vm[*].id
}