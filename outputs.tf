
output "terra-vm-ip-address" {
    value = azurerm_linux_virtual_machine.terravm.public_ip_address
}