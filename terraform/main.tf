
module "resourcegroup" {
  source = "./modules/resourcegroup"

  namespace = var.namespace
}

module "networking" {
  source    = "./modules/networking"
  namespace = module.resourcegroup.namespace
}

module "loadbalancing" {
  source = "./modules/loadbalancing"

  namespace = module.resourcegroup.namespace
  sg        = module.networking.sg
  vpc       = module.networking.vpc
}

module "consul_servers" {
  source               = "./modules/cluster"
  associate_public_ips = var.associate_public_ips
  ssh_keypair          = var.ssh_keypair
  instance_count       = var.consul.servers_count
  instance_type        = var.consul.server_instance_type
  datacenter           = var.datacenter
  join_wan             = var.join_wan
  consul = {
    version = var.consul.version
    mode    = "server"
  }

  namespace         = module.resourcegroup.namespace
  vpc               = module.networking.vpc
  security_group_id = module.networking.sg.consul_server
  target_group_arns = module.loadbalancing.target_group_arns.consul
}

module "nomad_servers" {
  source               = "./modules/cluster"
  associate_public_ips = var.associate_public_ips
  ssh_keypair          = var.ssh_keypair
  instance_count       = var.nomad.servers_count
  instance_type        = var.nomad.server_instance_type
  datacenter           = var.datacenter
  nomad = {
    version = var.nomad.version
    mode    = "server"
  }
  consul = {
    version = var.consul.version
    mode    = "client"
  }

  namespace         = module.resourcegroup.namespace
  vpc               = module.networking.vpc
  security_group_id = module.networking.sg.nomad_server
  target_group_arns = module.loadbalancing.target_group_arns.nomad
}

module "nomad_clients" {
  source               = "./modules/cluster"
  associate_public_ips = var.associate_public_ips
  ssh_keypair          = var.ssh_keypair
  instance_count       = var.nomad.clients_count
  instance_type        = var.nomad.client_instance_type
  datacenter           = var.datacenter
  nomad = {
    version = var.nomad.version
    mode    = "client"
  }
  consul = {
    version = var.consul.version
    mode    = "client"
  }

  namespace         = module.resourcegroup.namespace
  security_group_id = module.networking.sg.nomad_client
  vpc               = module.networking.vpc
  target_group_arns = module.loadbalancing.target_group_arns.fabio
}
