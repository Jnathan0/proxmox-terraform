# Pi-hole instance from a full clone
# ---
# Create a new VM from a clone

resource "proxmox_vm_qemu" "pi-hole-test" {
    
    # VM General Settings
    target_node = "proxmox"
    vmid = "5000"
    name = "pi-hole-test"
    desc = "pi-hole DNS black hole and DNS server"

    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = "ubuntu-server-2204-cloudinit-template"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 2
    sockets = 1
    cpu = "host"    
    
    # VM Memory Settings
    memory = 2048

    disk {
        type = "scsi"
        # set disk size here. leave it small for testing because expanding the disk takes time.
        size = "10G"
        storage = "local-lvm"
        iothread = 0
  }
    # VM Network Settings
    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    lifecycle {
        ignore_changes  = [
        network,
        ]
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"

    # (Optional) IP Address and Gateway
    # ipconfig0 = "ip=0.0.0.0/0,gw=0.0.0.0"
    
    # (Optional) Default User
    ciuser = "user"
    
    # (Optional) Add your SSH KEY
    sshkeys = var.agent_ssh_pubkey
}