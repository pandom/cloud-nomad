/*variable "enable_autoscaling" {
  default = true
  type    = bool
}*/

variable "namespace" {
  type = string
}

variable "instance_count" {
  type = number
}

variable "instance_type" {
  type = string
}

variable "vpc" {
  type = any
}

variable "security_group_id" {
  type = string
}

variable "ssh_keypair" {
  type = string
}

variable "target_group_arns" {
  type    = list(string)
  default = []
}

variable "datacenter" {
  type = string
}

variable "join_wan" {
  default = []
  type    = list(string)
}

variable "associate_public_ips" {
  default = true
  type    = bool
}

variable "nomad" {
  default = {
    version = "n/a"
    mode    = "disabled"
  }
  type = object({
    version = string
    mode    = string
  })
}

variable "consul" {
  default = {
    version = "n/a"
    mode    = "disabled"
  }
  type = object({
    version = string
    mode    = string
  })
}