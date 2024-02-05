resource "random_id" "sa" {
  byte_length = 8
}

resource "azurerm_storage_account" "sa" {
  name                     = "${var.sftp_deployment.prefix}${lower(random_id.sa.hex)}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
  sftp_enabled             = true

  //public_network_access_enabled = false
}

#resource "azurerm_storage_share" "share" {
#  name                 = "${var.sftp_deployment.prefix}share"
#  storage_account_name = azurerm_storage_account.sa.name
#  quota                = 50
#}

resource "azurerm_storage_container" "container" {
  name                  = "${var.sftp_deployment.prefix}container"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_storage_account_local_user" "local_user" {
  name               = var.sftp_deployment.stfp_credential.user
  storage_account_id = azurerm_storage_account.sa.id
  //ssh_key_enabled      = true
  ssh_password_enabled = true
  home_directory       = azurerm_storage_container.container.name

  permission_scope {
    permissions {
      read   = true
      create = true
      list   = true
      delete = true
      write  = true
    }
    service       = "blob"
    resource_name = azurerm_storage_container.container.name
  }
}

resource "azurerm_private_endpoint" "blob_private_endpoint" {
  name                = "${azurerm_storage_account.sa.name}-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnets["privateendpoint"].id

  private_service_connection {
    name                           = "privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.sa.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "blob-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone.id]
  }

  depends_on = [
    azurerm_storage_container.container,
    azurerm_storage_account_local_user.local_user
  ]
}

//resource "azapi_update_resource" "update_resource-sa" {
//  count       = azurerm_storage_account.sa.public_network_access_enabled == true ? 1 : 0
//  type        = "Microsoft.Storage/storageAccounts@2022-09-01"
//  resource_id = azurerm_storage_account.sa.id
//
//  body = jsonencode({
//    properties = {
//      allowBlobPublicAccess = false
//    }
//  })
//
//  depends_on = [
//    azurerm_private_endpoint.blob_private_endpoint
//  ]
//}