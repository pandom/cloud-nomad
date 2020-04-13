data_dir   = "/mnt/nomad"
datacenter = "${datacenter}"
region = "${region}"
bind_addr = "0.0.0.0"
advertise {
  http = "$PUBLIC_IP"
  rpc = "$PUBLIC_IP"
  serf = "$PUBLIC_IP"
}
server {
    enabled = true
    bootstrap_expect = ${instance_count}
}

telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
}
enable_syslog = true
log_level = "DEBUG"