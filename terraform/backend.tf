terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "burkey"
    workspaces {
      name = "cloud-nomad"
    }
  }
}