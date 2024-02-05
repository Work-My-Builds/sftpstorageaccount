variable "sftp_deployment" {
  type = object({
    prefix        = string
    location      = string
    address_space = list(string)
    stfp_credential = object({
      user = string
    })

    subnets = list(object({
      subnet_name      = string
      address_prefixes = list(string)
      delegation       = optional(any, {})
    }))
  })
}