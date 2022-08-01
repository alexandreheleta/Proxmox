variable "ssh_key" {
  default = "Clé SSH pour cloudinit"
}

variable "proxmox_host" {
    default = "nom de la node proxmox"
}

variable "template_name" {
    default = "nom de la template"
}

variable "api_url_proxmox" {
    default = "url du Proxmox /api2/json"
}

variable "api_token_proxmox" {
    default = "token api"
}

variable "secret_token_proxmox" {
    default = "secret token api"
}

