variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name"
  type        = string
  // If "", the pack name will be used
  default = ""
}

variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement"
  type        = list(string)
  default     = ["dc1"]
}

variable "region" {
  description = "The region where the job should be placed"
  type        = string
  default     = "global"
}


variable "mc_port" {
  description = "The Nomad client port that routes to the minecraft"
  type        = number
  default     = 25565
}

#1.17.1
variable "server_url" {
    description = "Mojang artifact URL for server.jar"
    type = string
    default = "https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar"
}

variable "eula_url" {
    description = "File based override for Server EULA agreement"
    type = string
    #Change this to be self referential after first commit to nomad-pack-repo
    default = "https://raw.githubusercontent.com/pandom/cloud-nomad/master/minecraft/common/eula.txt"
}

variable "jvm_max_mem" {
    description = "Java runtime maximum memory"
    type = string
    default = "-Xmx768M"
}

variable "jvm_min_mem" {
    description = "Java runtime min memory"
    type = string
    default = "-Xms768M"
}

variable "java_path" {
    description = "Java runtime path"
    type = string
    default = "server.jar"
}

variable "resources" {
  description = "The resource to assign to the minecraft service task"
  type = object({
    cpu    = number
    memory = number
    storage = number
  })
  default = {
    cpu    = 800,
    memory = 900,
    storage = 2000,
  }
}