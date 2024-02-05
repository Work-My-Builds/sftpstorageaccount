output "local_user" {
  value = "${azurerm_storage_account.sa.name}.${azurerm_storage_account_local_user.local_user.name}"
}

output "local_password" {
  value = azurerm_storage_account_local_user.local_user.password
}

output "firewall_nat_ip" {
  value = azurerm_public_ip.pip.ip_address
}