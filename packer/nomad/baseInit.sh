#!/bin/bash -e

main() {
  sudo apt-get update
  sudo apt-get install -y jq
  sudo apt-get install -y unzip
  sudo unzip /tmp/nomad-enterprise_0.11.0+ent_linux_amd64.zip
}

main



