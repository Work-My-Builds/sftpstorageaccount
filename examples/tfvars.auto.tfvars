sftp_deployment = {
  prefix        = "sftptest"
  location      = "CentralUS"
  address_space = ["10.200.0.0/16"]

  stfp_credential = {
    user = "jonesbawah"
  }

  subnets = [
    {
      subnet_name      = "AzureFirewallSubnet"
      address_prefixes = ["10.200.1.0/24"]
    },
    {
      subnet_name      = "privateendpoint"
      address_prefixes = ["10.200.2.0/24"]
    },
    {
      subnet_name      = "compute"
      address_prefixes = ["10.200.3.0/24"]
    }
  ]
}