terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.8"
  #terraform init 
    }
  }
}

provider "proxmox" {
  pm_api_url = var.api_url_proxmox

  pm_api_token_id = var.api_token_proxmox

  pm_api_token_secret = var.secret_token_proxmox
  #Laisse TLS insecure si tu as pas un certificat TLS valide
  pm_tls_insecure = true
  pm_log_enable = true
  pm_log_file = "terraform-plugin-proxmox.log"
  pm_debug = true
  pm_log_levels = {
    _default = "debug"
    _capturelog = ""
  }
}

resource "proxmox_vm_qemu" "test_server" {
  count = 4 # just want 1 for now, set to 0 and apply to destroy VM
  name = "vm-client-${count.index + 1}"
  target_node = var.proxmox_host
  vmid = "40${count.index+1}"
  clone = var.template_name

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 2048
  scsihw = "virtio-scsi-pci"
  bootdisk = "virtio0"

  disk {
    slot = 0
    # Le disque de la template doit etre inferieur ou égal à cette valeur
    size = "25G"
    # Important de mettre le meme type de disque que la template sinon crée il crée un nouveau hard disk   
    type = "virtio"
    storage = "local"
    iothread = 1
  }
  
  #LAN 
  network {
    model = "virtio"
    bridge = "vmbr1"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  # Je laisse en DHCP car pour passer en ip statique
  # Car la config packer prend le dessus il faudrait reboot la VM
  ipconfig0 = "ip=dhcp"
  #clé SSH  
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

