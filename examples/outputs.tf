output "description" {
  value = "Please use below credentials to login to SFTP client of your choosen.\nHostname: ${module.sftp_deployment.firewall_nat_ip} \nUsername: ${module.sftp_deployment.local_user}\nPlease run 'terraform output sftp_password' to get the sftp user password"
}

output "sftp_password" {
  value     = module.sftp_deployment.local_password
  sensitive = true
}