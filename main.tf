resource "azurerm_resource_group" "rg" {
  name     = "${var.sftp_deployment.prefix}-RG"
  location = var.sftp_deployment.location
}

data "http" "myip" {
  url = "https://ifconfig.me"
}