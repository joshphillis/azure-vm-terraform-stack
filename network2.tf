# Public IP for the Windows virtual machine
resource "azurerm_public_ip" "windows_vm_ip_net" {
  name                = "${var.windows_vm_name}-pip-net"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Basic"
  tags                = var.tags
  depends_on          = [data.azurerm_resource_group.rg]
}

# Network Interface for the Windows virtual machine
resource "azurerm_network_interface" "windows_nic_net" {
  name                = "${var.windows_vm_name}-nic-net"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "vm-ip-config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.windows_vm_ip_net.id
  }

  tags       = var.tags
  depends_on = [azurerm_subnet.subnet, azurerm_public_ip.windows_vm_ip_net]
}

# Network Security Group for the Windows VM
resource "azurerm_network_security_group" "windows_vm_nsg_net" {
  name                = "${var.windows_vm_name}-nsg-net"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.admin_ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = var.admin_ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Outbound-Internet"
    priority                   = 130
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "Allow-SMB"
    priority                   = 140
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "445"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags       = var.tags
  depends_on = [data.azurerm_resource_group.rg]
}

# Associate NIC with NSG
resource "azurerm_network_interface_security_group_association" "nic_nsg_net" {
  network_interface_id      = azurerm_network_interface.windows_nic_net.id
  network_security_group_id = azurerm_network_security_group.windows_vm_nsg_net.id
  depends_on                = [
    azurerm_network_interface.windows_nic_net,
    azurerm_network_security_group.windows_vm_nsg_net
  ]
}