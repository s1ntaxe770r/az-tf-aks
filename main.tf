terraform {
<<<<<<< HEAD
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.39.0"
    }
  }
}
provider "azurerm" {
  features {}
}


module "cluster" {
  source                = "./modules/cluster"
  ssh_key               = var.ssh_key
  location              = var.location
  kubernetes_version    = var.kubernetes_version  
  
}
=======
    required_providers{
        azurerm = {
            source = "hashicorp/azurerm"
            version = ">=2.26"
        }
    }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.serviceprinciple_id
  client_secret   = var.serviceprinciple_key
  tenant_id       = var.tenant_id

    features {}
}

resource "azurerm_resource_group" "terraform-resource-group"{
    name = "TerraformResourceGroup"
    location = "south africa north"
}


resource "azurerm_virtual_network" "terra-net" {
    name = "terranet"
    resource_group_name = azurerm_resource_group.terraform-resource-group.name
    location = azurerm_resource_group.terraform-resource-group.location 
    address_space = ["10.0.0.0/16"]
  
}


resource "azurerm_subnet" "terra-subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.terraform-resource-group.name
  virtual_network_name = azurerm_virtual_network.terra-net.name
  address_prefixes     = ["10.0.2.0/24"]
}



resource "azurerm_network_interface" "terra-nic" {
  name                = "terraform-resource-group-NIC"
  location            = azurerm_resource_group.terraform-resource-group.location
  resource_group_name = azurerm_resource_group.terraform-resource-group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.terra-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}




resource "azurerm_linux_virtual_machine" "terravm" {
    name = "terra-vm"
    resource_group_name = azurerm_resource_group.terraform-resource-group.name
    location = azurerm_resource_group.terraform-resource-group.location 
    size = "Standard_B1ms"
    admin_username = var.username
    admin_password = var.password

    network_interface_ids = [ azurerm_network_interface.terra-nic.id,]

   
    os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    }

   disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

>>>>>>> fb2476a4647296109b364bd15faa5c406abaec7c
