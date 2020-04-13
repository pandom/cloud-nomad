variable "consul" {
  default = {
    version              = "1.7.2"
    servers_count        = 3
    server_instance_type = "m1.small"
  }
  type = object({
    version              = string
    servers_count        = number
    server_instance_type = string
  })
}

variable "nomad" {
  default = {
    version              = "0.11.0"
    servers_count        = 3
    server_instance_type = "m1.small"
    clients_count        = 3
    client_instance_type = "m1.small"
  }
  type = object({
    version              = string
    servers_count        = number
    server_instance_type = string
    clients_count        = number
    client_instance_type = string
  })
}

variable "region" {
  default = "ap-southeast-2"
  type    = string
}

variable "namespace" {
  default = "burkey"
  type    = string
}

variable "ssh_keypair" {
  default = "burkey"
  type    = string
}

variable "datacenter" {
  default = "aws"
  type    = string
}

variable "join_wan" {
  type    = list(string)
  default = []
}

variable "associate_public_ips" {
  default = true
  type = bool
}
