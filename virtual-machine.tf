terraform {
  required_providers {
    virtualbox = {
      source = "terra-farm/virtualbox"
      version = "0.2.2-alpha.1"
    }
  }
}

# There are currently no configuration options for the provider itself. 
# So, there is no way of specifying the location of Virtualbox
# Therefore, Terraform & Jenkins MUST be installed on the same base host [the same laptop for instance]. Trying to run a Jenkins or
# Terraform job from a VM to install another virtual machine on the same Virtualbox hosting the Terraform or Jenkins VM won't work
# Either the Terraform, Jenkins and the Virtualbox are both installed on the same laptop, or the Terraform, Jenkins and the Virtualbox
# are both installed on the same VM.

resource "virtualbox_vm" "node" {
  count     = 1
  name      = format("node-%02d", count.index + 1)
  image     = "https://app.vagrantup.com/ubuntu/boxes/bionic64/versions/20180903.0.0/providers/virtualbox.box"
  cpus      = 1
  memory    = "512 mib"
#  user_data = file("${path.module}/user_data")

  network_adapter {
    type           = "hostonly"
    host_interface = "VirtualBox Host-Only Ethernet Adapter"
  }
}

output "IPAddr" {
  value = element(virtualbox_vm.node.*.network_adapter.0.ipv4_address, 1)
}

output "IPAddr_2" {
  value = element(virtualbox_vm.node.*.network_adapter.0.ipv4_address, 2)
}
