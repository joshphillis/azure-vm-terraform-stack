# 🔧 Global Configuration
variable "resource_prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "terraformjlp"
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region for resource deployment"
  type        = string
  default     = "East US"
  validation {
    condition     = contains(["East US", "West US", "Central US"], var.location)
    error_message = "Location must be one of: East US, West US, Central US"
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    environment = "dev"
    owner       = "joshua"
  }
}

# 🏗️ Resource Group & Networking
variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "terraformRGjlp"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "vnet-terraformjlp"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}


variable "admin_ip" {
  description = "Public IP address of the administrator for RDP/HTTP access"
  type        = string
  default     = "0.0.0.0/0"
}


variable "subnet_name" {
  description = "Name of the subnet within the virtual network"
  type        = string
  default     = "subnet-terraformjlp"
}

variable "subnet_prefix" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# 🖥️ Virtual Machine Configuration
variable "windows_vm_name" {
  description = "Name of the Windows virtual machine"
  type        = string
  default     = "vm-windows-terraformjlp"
}

variable "linux_vm_name" {
  description = "Name of the Linux virtual machine"
  type        = string
  default     = "vm-linux-terraformjlp"
}

variable "windows_vm_size" {
  description = "Size of the Windows virtual machine"
  type        = string
  default     = "Standard_D2s_v3"
  validation {
    condition     = contains(["Standard_B1s", "Standard_DS1_v2", "Standard_B2s", "Standard_D2s_v3"], var.windows_vm_size)
    error_message = "Windows VM size must be one of: Standard_B1s, Standard_DS1_v2, Standard_B2s, Standard_D2s_v3"
  }
}

variable "linux_vm_size" {
  description = "Size of the Linux virtual machine"
  type        = string
  default     = "Standard_B1s"
  validation {
    condition     = contains(["Standard_B1s", "Standard_DS1_v2", "Standard_B2s"], var.linux_vm_size)
    error_message = "Linux VM size must be one of: Standard_B1s, Standard_DS1_v2, Standard_B2s"
  }
}

variable "vm_os_image" {
  description = "Operating system image used for the VM"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

variable "storage_account_tier" {
  description = "Defines the performance tier of the storage account"
  type        = string
  default     = "Standard"
}

variable "storage_replication_type" {
  description = "Defines the replication strategy for the storage account"
  type        = string
  default     = "LRS"
}

variable "vm_os_disk_type" {
  description = "Specifies the type of OS disk (e.g., Standard_LRS, Premium_LRS)"
  type        = string
  default     = "Standard_LRS"
}

variable "diagnostics_enabled" {
  description = "Enable or disable diagnostics storage account creation"
  type        = bool
  default     = true
}

variable "file_share_name" {
  description = "Name of the Azure File Share"
  type        = string
  default     = "vmfileshare"
}

variable "file_share_quota" {
  description = "Quota for the Azure File Share in GB"
  type        = number
  default     = 50
}

variable "admin_username" {
  description = "Admin username for the Windows VM"
  type        = string
  default     = "localadmin"
}

variable "admin_password" {
  description = "Admin password for the Windows VM"
  type        = string
  sensitive   = true
}