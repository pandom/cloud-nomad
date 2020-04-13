module "files" {
  source  = "matti/resource/shell"
  command = "curl -s ifconfig.co"

}

output "myip" {
  value = module.files.stdout
}