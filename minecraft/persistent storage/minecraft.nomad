job "minecraft" {
  datacenters = ["DC1"]
  group "minecraft" {
    volume "minecraft" {
      type   = "host"
      source = "minecraft"
    }
    // Move EULA into a place that's accessible by server.jar
    task "eula" {
      driver = "exec"
      config {
        command = "mv"
        args    = ["local/eula.txt", "/var/volume/"]
      }
      lifecycle {
        hook    = "prestart"
        sidecar = false
      }
      //nomad template for file. Appends line eula=true to eula.text
      template {
        data        = "eula=true"
        destination = "local/eula.txt"
      }
      //mounts server
      volume_mount {
        volume      = "minecraft"
        destination = "/var/volume"
      }
    }
    //runs a local exec of java opposed to using java driver. 
    task "minecraft" {
      driver = "exec"
      config {
        command = "/bin/sh"
        args    = ["-c", "cd /var/volume && exec java -Xms1024M -Xmx2048M -jar /local/server.jar --nogui"]
      }
      // pull artifact
      artifact {
        source = "https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar"
      }
      // reserve resources
      resources {
        cpu    = 4000
        memory = 2048
      }
      volume_mount {
        volume      = "minecraft"
        destination = "/var/volume"
      }
    }
  }
}