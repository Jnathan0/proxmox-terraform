# Proxmox Provider
# ---
# Initial Provider Configuration for Proxmox
# Modified from: https://github.com/ChristianLempa/boilerplates/blob/main/terraform/proxmox/provider.tf

terraform {

    required_version = ">= 0.13.0"

    required_providers {
        proxmox = {
            source = "telmate/proxmox"
            version = "2.9.14"
        }
    }
}

variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
}

variable "proxmox_api_token_secret" {
    type = string
}

variable "agent_maintainer_ssh_pubkey" {
    type = string
}

variable "controller_ssh_pubkey" {
    type = string
}
variable "controller_ssh_private_key" {
    type = string
}

provider "proxmox" {

    pm_api_url = var.proxmox_api_url
    pm_api_token_id = var.proxmox_api_token_id
    pm_api_token_secret = var.proxmox_api_token_secret

    # (Optional) Skip TLS Verification
    pm_tls_insecure = true

}