include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../resource-group"]
}
initial
terraform {
  source = "${get_parent_terragrunt_dir()}/terraform-modules/virtual-network"
}

inputs = {
  default_virtual_network_name          = "dev-vnet-1"
  default_virtual_network_address_space = ["10.10.0.0/16"]
  app_subnet_name                  = "devsubnet1"
  app_subnet_address_prefixes      = ["10.10.0.0/21"]
  app_subnet_security_group_name   = "devnsg1"
}