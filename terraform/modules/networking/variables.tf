variable "namespace" {
  type = string
}
#CIDR value for ingress of a single IP
variable "myip" {
  type = string
  default = "120.148.1.90/32"
}