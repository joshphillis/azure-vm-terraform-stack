# Storage Account for Boot Diagnostics
resource "azurerm_storage_account" "diag" {
  count                    = var.diagnostics_enabled ? 1 : 0
  name                     = "terrastorageaccountjlp"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type
  tags                     = var.tags
  depends_on               = [data.azurerm_resource_group.rg]
}

resource "azurerm_storage_share" "diag_share" {
  name                 = var.file_share_name
  storage_account_name = azurerm_storage_account.diag[0].name
  quota                = var.file_share_quota
  depends_on           = [azurerm_storage_account.diag]
}

data "azurerm_storage_account" "diag" {
  name                = azurerm_storage_account.diag[0].name
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_virtual_machine_extension" "windows_mount_diag_share" {
  name                 = "mountdiagshare"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm_main.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -Command \"New-Item -ItemType Directory -Force -Path 'Z:\\'; net use Z: '\\\\${azurerm_storage_account.diag[0].name}.file.core.windows.net\\${var.file_share_name}' /user:${azurerm_storage_account.diag[0].name} ${data.azurerm_storage_account.diag.primary_access_key} /persistent:yes\""
    }
  SETTINGS

  depends_on = [
    azurerm_windows_virtual_machine.vm_main,
    azurerm_storage_share.diag_share
  ]
}

# Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "vm_main" {
  name                  = "terraformvmjlp"
  resource_group_name   = data.azurerm_resource_group.rg.name
  location              = data.azurerm_resource_group.rg.location
  size                  = var.windows_vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.windows_nic_net.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.vm_os_disk_type
  }
  source_image_reference {
    publisher = var.vm_os_image.publisher
    offer     = var.vm_os_image.offer
    sku       = var.vm_os_image.sku
    version   = var.vm_os_image.version
  }
  boot_diagnostics {
    storage_account_uri = var.diagnostics_enabled ? azurerm_storage_account.diag[0].primary_blob_endpoint : null
  }
  tags       = var.tags
  depends_on = [azurerm_network_interface.windows_nic_net, azurerm_storage_account.diag]
}

