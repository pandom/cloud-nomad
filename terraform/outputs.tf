output "addresses" {
    value = module.loadbalancing.addresses
}

output "public_ips" {
    value = {
        consul_servers = module.consul_servers.public_ips
        nomad_servers = module.nomad_servers.public_ips
    }
}