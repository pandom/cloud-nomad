output "public_ips" {
    value = var.associate_public_ips&&length(data.aws_instances.instances)>=1 ? data.aws_instances.instances[0].public_ips : []
}
