resource "null_resource" "myip" {
    provisioner "local-exec" {
        command = "curl -s ifconfig.co >> myip.txt"
    }
}

