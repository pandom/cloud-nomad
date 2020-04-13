
module "iam_instance_profile" {
  source  = "scottwinkler/iip/aws"
  actions = ["logs:*", "ec2:DescribeInstances"]
}

data "aws_region" "current" {}

locals {
  consul_config = var.consul.mode != "disabled" ? templatefile("${path.module}/templates/consul_${var.consul.mode}.json", {
    instance_count = var.instance_count,
    namespace      = var.namespace,
    datacenter     = var.datacenter,
    join_wan       = join(",",[for s in var.join_wan: join("",["\"",s,"\""])]),
  }) : ""
  nomad_config = var.nomad.mode != "disabled" ? templatefile("${path.module}/templates/nomad_${var.nomad.mode}.hcl", {
    instance_count = var.instance_count
    datacenter     = var.datacenter
    region         = data.aws_region.current.name
  }) : ""
  startup = templatefile("${path.module}/templates/startup.sh", {
    consul_version = var.consul.version,
    consul_config  = local.consul_config,
    consul_mode    = var.consul.mode
    nomad_version  = var.nomad.version,
    nomad_config   = local.nomad_config,
    nomad_mode     = var.nomad.mode,
  })
  namespace = "${var.namespace}_N${var.nomad.mode}_C${var.consul.mode}"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

resource "aws_launch_template" "server" {
  name_prefix   = local.namespace
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  user_data     = base64encode(local.startup)
  key_name      = var.ssh_keypair
  iam_instance_profile {
    name = module.iam_instance_profile.name
  }
  network_interfaces {
    associate_public_ip_address = var.associate_public_ips
    security_groups = [var.security_group_id]
    delete_on_termination = true
  }

  tags = {
    ResourceGroup = var.namespace
  }
}

resource "aws_autoscaling_group" "server" {
  name                      = local.namespace
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = var.target_group_arns
  default_cooldown          = 3600
  min_size                  = var.instance_count
  max_size                  = var.instance_count
  vpc_zone_identifier       = var.associate_public_ips ? var.vpc.public_subnets : var.vpc.private_subnets
  launch_template {
    id      = aws_launch_template.server.id
    version = aws_launch_template.server.latest_version
  }
  tags = [
    {
      key                 = "ResourceGroup"
      value               = var.namespace
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = local.namespace
      propagate_at_launch = true
    }
  ]
}

data "aws_instances" "instances" {
  depends_on = [aws_autoscaling_group.server]
  count = var.associate_public_ips ? 1 : 0
  instance_tags = {
    ResourceGroup = var.namespace
    Name = local.namespace
  }

  instance_state_names = ["running", "pending"]
}
