variable "namespace" {
  type = string
}
#CIDR value for ingress of a single IP
variable "myip" {
  // default = "120.148.1.90/32"
  default = data.terraform_remote_state.cloud-nomad-myip.outputs.myip
}