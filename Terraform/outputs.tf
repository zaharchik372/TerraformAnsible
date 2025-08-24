output "instance_public_ips" {
  description = "Публичные IP ВМ"
  value       = [for i in yandex_compute_instance.vm : i.network_interface[0].nat_ip_address]
}

output "app_urls" {
  description = "URL-ы (http) напрямую на ВМ"
  value       = [for ip in [for i in yandex_compute_instance.vm : i.network_interface[0].nat_ip_address] : "http://${ip}"]
}

output "load_balancer_ip" {
  description = "Публичный IP NLB"
  value = flatten([
    for l in yandex_lb_network_load_balancer.app_lb.listener : [
      for a in l.external_address_spec : a.address
    ]
  ])[0]
}

output "load_balancer_url" {
  description = "URL через балансировщик"
  value = "http://${flatten([
    for l in yandex_lb_network_load_balancer.app_lb.listener : [
      for a in l.external_address_spec : a.address
    ]
  ])[0]}"
}

output "ansible_inventory_path" {
  description = "Путь к сгенерированному inventory"
  value       = local_file.ansible_inventory.filename
}
