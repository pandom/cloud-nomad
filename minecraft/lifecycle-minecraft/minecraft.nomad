job "minecraft"{
    datacenters = ["DC1"]
    priority = 80
    group "mc-server" {
        task "eula-setup"{
             lifecycle {
               hook = "prestart"
               //sidecar - true value will ensure it runs for duration of job allocation; and on restart
               //false will only run once. Perhaps move to false when using persistent 
               sidecar = "true"
            }
            //eula required otherwise runtime will fail to start
            artifact {
                source = "https://raw.githubusercontent.com/pandom/cloud-nomad/master/minecraft/common/eula.txt"
                mode = "file"
                destination = "eula.txt"
            }
            driver = "exec"
        } 
        task "minecraft" {
            resources {
                cpu = 800
                memory = 800
                disk = 2000
                network {
                    port "access" {
                        static = 25565
                    }
                }
            }
            artifact {
                source = "https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar"
                mode = "file"
                destination = "server.jar"
            }
            driver = "java"

            config {
                jar_path    = "server.jar"
                jvm_options = ["-Xmx768M", "-Xms768M"]
                args = ["EULA=true", "nogui"]
            }
        }
    }
}
