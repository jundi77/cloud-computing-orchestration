output "webserver_address" {
    value       = libvirt_domain.webserver.network_interface[0].addresses[0]
    description = "webserver address"
}

output "db_phpmyadmin_address" {
    value = libvirt_domain.db.network_interface[0].addresses[0]
    description = "db phpmyadmin address"
}