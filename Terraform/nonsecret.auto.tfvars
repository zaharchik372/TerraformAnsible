zone = "ru-central1-a"

existing_network_id = "enp3k4rtt74cvbou416v"
existing_subnet_id  = "e9bph6g688de8t0t4s10" 

vm_name_prefix = "TestIaC"
instance_count = 2

vm_cores     = 4
vm_memory    = 4
vm_fraction  = 20
disk_size_gb = 15

trusted_cidrs = ["0.0.0.0/0"]

resource_tags = {
  project     = "terraform-ansible"
  environment = "dev"
}

ssh_public_key_path = "~/.ssh/id_ed25519.pub"
