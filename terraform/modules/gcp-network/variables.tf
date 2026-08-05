variable "project_id" {
  description = "GCP project that owns the VPC."
  type        = string
}

variable "network_name" {
  description = "Name of the custom-mode VPC."
  type        = string
}

variable "network_cidr" {
  description = "Address reservation for this VPC. GCP VPCs do not own a CIDR directly; this value enforces the documented allocation boundary."
  type        = string

  validation {
    condition = (
      can(cidrhost(var.network_cidr, 0)) &&
      (
        sum([for index, octet in split(".", cidrhost(var.network_cidr, -1)) : tonumber(octet) * pow(256, 3 - index)]) <
        sum([for index, octet in split(".", cidrhost("10.10.0.0/16", 0)) : tonumber(octet) * pow(256, 3 - index)]) ||
        sum([for index, octet in split(".", cidrhost(var.network_cidr, 0)) : tonumber(octet) * pow(256, 3 - index)]) >
        sum([for index, octet in split(".", cidrhost("10.10.0.0/16", -1)) : tonumber(octet) * pow(256, 3 - index)])
      ) &&
      (
        sum([for index, octet in split(".", cidrhost(var.network_cidr, -1)) : tonumber(octet) * pow(256, 3 - index)]) <
        sum([for index, octet in split(".", cidrhost("10.20.0.0/16", 0)) : tonumber(octet) * pow(256, 3 - index)]) ||
        sum([for index, octet in split(".", cidrhost(var.network_cidr, 0)) : tonumber(octet) * pow(256, 3 - index)]) >
        sum([for index, octet in split(".", cidrhost("10.20.0.0/16", -1)) : tonumber(octet) * pow(256, 3 - index)])
      )
    )
    error_message = "network_cidr must be valid and must not overlap Azure 10.10.0.0/16 or 10.20.0.0/16."
  }
}

variable "subnets" {
  description = "Subnets to create in the custom VPC."
  type = map(object({
    region                   = string
    ip_cidr_range            = string
    private_ip_google_access = optional(bool, true)
    flow_logs_enabled        = optional(bool, false)
  }))

  validation {
    condition = alltrue([
      for subnet in values(var.subnets) :
      can(cidrhost(subnet.ip_cidr_range, 0)) &&
      sum([for index, octet in split(".", cidrhost(subnet.ip_cidr_range, 0)) : tonumber(octet) * pow(256, 3 - index)]) >=
      sum([for index, octet in split(".", cidrhost(var.network_cidr, 0)) : tonumber(octet) * pow(256, 3 - index)]) &&
      sum([for index, octet in split(".", cidrhost(subnet.ip_cidr_range, -1)) : tonumber(octet) * pow(256, 3 - index)]) <=
      sum([for index, octet in split(".", cidrhost(var.network_cidr, -1)) : tonumber(octet) * pow(256, 3 - index)])
    ])
    error_message = "Every subnet must be a valid CIDR fully contained in network_cidr."
  }
}

variable "routing_mode" {
  description = "VPC dynamic routing mode. GLOBAL supports the later multi-region hybrid design."
  type        = string
  default     = "GLOBAL"

  validation {
    condition     = contains(["GLOBAL", "REGIONAL"], var.routing_mode)
    error_message = "routing_mode must be GLOBAL or REGIONAL."
  }
}

variable "description" {
  description = "Purpose recorded on the VPC."
  type        = string
  default     = "Hybrid identity development network"
}
