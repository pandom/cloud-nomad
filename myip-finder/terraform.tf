
terraform {
  required_version = ">= 0.11"
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "burkey"
    workspaces {
      name = "cloud-nomad-myip"
    }
  }

}
