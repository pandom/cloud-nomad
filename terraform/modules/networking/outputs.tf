output "vpc" {
  value = module.vpc
}

output "sg" {
  value = {
    consul_server = module.consul_server_sg.security_group.id
    consul_lb     = module.consul_lb_sg.security_group.id
    nomad_server  = module.nomad_server_sg.security_group.id
    nomad_client  = module.nomad_client_sg.security_group.id
    nomad_lb      = module.nomad_lb_sg.security_group.id
    fabio_lb      = module.fabio_lb_sg.security_group.id
  }
}
