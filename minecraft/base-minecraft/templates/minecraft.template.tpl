job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  datacenters = [ [[ range $idx, $dc := .minecraft.datacenters ]][[if $idx]],[[end]][[ $dc | quote ]][[ end ]] ]
  group "minecraft" {
    network {
      port "access" {
        to = [[ .minecraft.http_port ]]
      }
    }
    task "minecraft" {
      driver = "java"
      config {
        jar_path = "[[ .minecraft.java_path ]]"
        jvm_options = ["[[ .minecraft.jvm_max_mem]]","[[ .minecraft.jvm_min_mem]]"]
      }
      //Server Jar from Mojang
      artifact {
          source = "[[.minecraft.server_url]]"
          mode = "file"
          destination = "[[ .minecraft.java_path ]]"

      }
      //EULA
      artifact {
          source = "[[.minecraft.server_url]]"
          mode = "file"
          destination = "[[ .minecraft.java_path ]]"

      }

      resources {
        cpu    = [[ .minecraft.resources.cpu ]]
        memory = [[ .minecraft.resources.memory ]]
        storage = [[ .minecraft.resources.storage]]
      }
    }
  }
}