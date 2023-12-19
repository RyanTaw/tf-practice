terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.85.0"
    }
  }
}

provider "azurerm" {
    subscription_id = "d8634ddc-d384-4cc3-b216-a71eef2cc982"
    tenant_id = "5ce25efb-1b14-40fa-a68e-18658b73d3b5"
    client_id = "dc90d1ed-5dcc-40b9-a69f-608053243fb5"
    client_secret = "uqC8Q~BLmkxd5axXPO~TS3GIKCjYcfrsMEBcRddG"
    features {}
}

locals {
  resource_group_name = "app-grp"
  location = "eastus"
  security_group= "appsecuritygroup"
  virtual_network= {
    address_space= "10.0.0.0/16"
  }
}

resource "azurerm_resource_group" "appgrp" {
  name     = local.resource_group_name
  location = local.location
}

resource "azurerm_network_security_group" "appsecuritygrp" {
  name     = local.security_group.name
  location = local.location
  resource_group_name = local.resource_group_name

  depends_on = [ azurerm_resource_group.appgrp ]
}

resource "azurerm_virtual_network" "appnetwork" {
  name     = local.virtual_network.name
  location = local.location
  resource_group_name = local.resource_group_name
  address_space       = [local.virtual_network.address_space]

  depends_on = [ azurerm_network_security_group.appsecuritygrp ]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.0.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.1.0/24"
    security_group = local.security_group.name
  }

  # tags = {
  #   environment = "test"
  # }
}