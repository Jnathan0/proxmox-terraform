# Pi-hole instance from a full clone
# ---
# Create a new VM from a clone

resource "proxmox_vm_qemu" "vault" {
    
    # VM General Settings
    target_node = "proxmox"
    vmid = "3000"
    name = "vault"
    desc = "Vault secrets store"
    full_clone = true
    cpu = "host"
    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = "ubuntu-server-2204"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 2
    sockets = 1
    
    # VM Memory Settings
    memory = 2048

    # disk settings for agent
    scsihw = "virtio-scsi-pci"
    bootdisk = "scsi0"
    
    disk {
        slot = 0
        type = "scsi"
        # set disk size here. leave it small for testing because expanding the disk takes time.
        size = "16G"
        storage = "local-lvm"
        iothread = 0
  }
    # VM Network Settings
    network {
        bridge = "vmbr0"
        model  = "virtio"
        macaddr = "AA:88:40:8B:D2:28"
        firewall = false
    }

    lifecycle {
        ignore_changes  = [
        network,
        ]
    }

    # VM Cloud-Init Settings
    # os_type = "cloud-init"

    # (Optional) IP Address and Gateway
    ipconfig0 = "ip=192.168.0.125/24,gw=192.168.0.1"
    
    # (Optional) Default User
    ciuser = "user"
    
    # (Optional) Add your SSH KEY
    sshkeys = <<EOF
    ${var.agent_maintainer_ssh_pubkey} 
    ${file(var.controller_ssh_pubkey)}
    EOF

  provisioner "remote-exec" {

    inline = ["echo Connection Done!"]

    connection {
      host        = "192.168.0.125"
      type        = "ssh"
      user        = "user"
      private_key = file(var.controller_ssh_private_key)
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u user -i '192.168.0.125,' --private-key ${var.controller_ssh_private_key} -e 'pub_key=${var.controller_ssh_pubkey}' playbooks/vault-playbook.yml"
  }
}
