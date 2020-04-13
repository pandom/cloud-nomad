module "files" {
  source  = "matti/resource/shell"
  command = "curl -s -4 ifconfig.co"

}

resource "null_resource" "trigger" {
  command = "curl -s -4 ifconfig.co >> ipv4.txt"
}

output "myip" {
  value = module.files.stdout
}