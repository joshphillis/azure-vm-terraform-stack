output "windows_vm_name" {
  description = "Name of the Windows virtual machine"
  value       = var.windows_vm_name
}

output "vm_public_ip" {
  value = azurerm_public_ip.windows_vm_ip_net.ip_address
}

output "vm_private_ip" {
  value = azurerm_network_interface.windows_nic_net.private_ip_address
}

output "windows_vm_rdp_command" {
  description = "RDP command to connect to the Windows VM"
  value       = format("mstsc /v:%s", azurerm_public_ip.windows_vm_ip_net.ip_address)
  sensitive   = true
}

output "vm_size" {
  description = "Size of the Windows virtual machine"
  value       = var.windows_vm_size
}

output "vm_os_image" {
  description = "Operating system image for the Windows virtual machine"
  value       = var.vm_os_image
}

output "vm_os_disk_type" {
  description = "OS disk type for the Windows virtual machine"
  value       = var.vm_os_disk_type
}

output "vm_location" {
  description = "Azure region for the Windows virtual machine"
  value       = data.azurerm_resource_group.rg.location
}

output "resource_tags" {
  description = "Tags applied to resources"
  value       = var.tags
}